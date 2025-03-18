% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [datX,datErr,param]=genSpectra(datX,param)

logAddConst = 1; % %%%% for log_power+ adds this to all values before log 
logZeroParam = exp(-15) ; %%%% when computing log this replaces 0 values

switch param.psdMethod
    case 'fft'
        if strfind(param.psdSpectraType,'power')
            spectExp=2;
        elseif strfind(param.psdSpectraType,'amp')
            spectExp=1;
        else
            error('FFT: neither power nor amplitude')
        end
end

for mod=1:length(datX)
    data       = datX{mod}.chan; %%% eeg data
    inChans    = 1:length(param.Xlabels); %%% at the moment take all
    lenInChans = length(inChans); %%% number of channels to be used
    
    spectCh=[];
    for ch=1:lenInChans %%% by channel
        chan = ch; %%%
        datSeg=data{chan}.X';
        S=size(data);
        % detrend signal, for FFT 
        if strcmp(param.detrendL,'yes')
            datSeg = detrend(datSeg,'linear');
        end
        %%%% zero-mean
        if param.zeroMean
            datSeg = detrend(datSeg,'constant');
        end
        %%%%% 
        for t=1:size(datSeg,2)
            d.epochVar(t,chan)=var(datSeg(:,t));
        end
        %%%% window/taper data 
        if ~strcmp(param.psdWindowType,'none')
            switch param.psdMethod
                case{'welch','thompson'}
                    taper = gettaper(size(datSeg),param.psdWindowType);
                    datSeg=datSeg.*taper;
                case {'fft'}
                    if ~(isfield(param,'nSubset') &  param.nSubset > 1) %%% don't do for more than 1 subset, it is done within the soubroutine 
                        taper = gettaper(size(datSeg),param.psdWindowType);
                        datSeg=datSeg.*taper;
                    end
            end
        end
        %%%%%% compute spectra
        switch param.psdMethod
            case 'fft'
                if param.nSubset > 1
                    [Ntotal,dim] = size(datSeg);
                    % Ndata is the power of 2 that does not exceed 90% of Ntotal.
                    Ndata = 2^floor(log2(Ntotal*0.9));
                    L = floor((Ntotal-Ndata)/(param.nSubset-1));
                    % set nfft greater than ceil(hset(end))*Ndata, asure that do fft without truncating
                    param.nFFT = 2^nextpow2(2*Ndata); %%% 2 = ceil(hset(end)) from irasaRR.m (line 133)
                    Nfrac = param.nFFT/2 + 1;
                    % compute the spectrum of mixed data
                    Pyy = zeros(Nfrac,dim);
                    if strcmp(param.psdWindowType,'none')
                        taper=[];
                    else
                        taper = gettaper([Ndata dim],param.psdWindowType);
                    end
                    for k = 0:param.nSubset-1
                        i0 = L*k+1;
                        x1 = datSeg(i0:1:i0+Ndata-1,:);
                        if isempty(taper)
                            yF = fft(x1,param.nFFT); % /min(param.nFFT,size(x1,1));
                        else
                            yF = fft(x1.*taper,param.nFFT); % /min(param.nFFT,size(x1,1));
                        end
                        if strcmp(param.fftNorm2Hz,'yes')
                            yF=yF/min(param.nFFT,size(x1,1));
                        end 
                        yF(2:end,:) = yF(2:end,:)*2; %%% don't take the first 0 bin
                        yF        = yF(1:param.nFFT/2 + 1,:);
                        Pyy = Pyy + (abs(yF).^spectExp);
                    end
                    Pyy = Pyy/param.nSubset;
                    if ~exist('f_lines','var')
                        %%% include 0 bin
                        f_lines = param.sampleFreq*(0:param.nFFT/2)/param.nFFT;
                    end
                else
                    %%%%% normalize by the data length
                    if strcmp(param.fftNorm2Hz,'yes')
                        yF        = fft(datSeg,param.nFFT)/length(datSeg);
                    else
                        yF        = fft(datSeg,param.nFFT);
                    end
                    yF(2:end,:) = yF(2:end,:)*2; %%% don't take the first 0 bin
                    yF        = yF(1:param.nFFT/2 + 1,:);
                    Pyy       = (abs(yF).^spectExp);
                    if ~exist('f_lines','var')
                        %%% include 0 bin
                        f_lines = param.sampleFreq*(0:param.nFFT/2)/param.nFFT;
                    end
                end
            case 'welch'
                for t=1:S(2)
                    [Pyy(:,t), f_lines]= pwelch(datSeg(:,t), [], param.psdWinOverlap_pwelch, param.nFFT, param.sampleFreq);
                end
            case 'thomson'
                for t=1:S(2)
                    [Pyy(:,t),f_lines]=pmtm(datSeg(:,t),param.nw_pmtm,param.nFFT,param.sampleFreq);
                end
                
        end
        if ch==1 
            param.outEpochLength=length(f_lines);
            param.f_lines_all=f_lines;
        end
        if isinf(spectCh)
            error('spcetCh is infinite')
        end
        spectCh=[spectCh, Pyy'];
    end
    

    %%%% select only desired lines and correct spectra if required
    indF=findFlines(param.freqIn,f_lines);
    f_lines_in=f_lines(indF);
    sAll=[];
    for ch=1:lenInChans
        bg=(ch-1)*param.outEpochLength +1;
        en=bg + param.outEpochLength  -1;
        sCol=[];
        for j=1:size(spectCh,1)
            sT=spectCh(j,bg:en);
            switch  param.psdSpectraType
                case {'log_power','log_amp'}
                    sT(sT == 0)=logZeroParam; %%%% treat zeros
                    sT=10*log10(sT);
                case {'log_power+','log_amp+'}
                    sT=10*log10(sT + logAddConst);
                case 'amplitude'
                    switch param.psdMethod
                        case {'welch','thompson'}
                            sT=sqrt(sT);
                    end
            end            
            sCol=[sCol ; sT(indF)];
        end
        sAll=[sAll sCol];
    end

    datX{mod}.X=sAll;
    param.f_lines_in=f_lines_in;
    datErr{mod}.timeEpochVariance=d.epochVar;
    datX{mod}=rmfield(datX{mod},'chan');
    
    if lenInChans > 1
        param.multiWay = [lenInChans length(param.f_lines_in)];
    elseif lenInChans == 1
        param.multiWay = [1 length(param.f_lines_in)];
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function taper = gettaper(S,psdWindowType)
% get a tapering function for power spectrum density calculation
switch psdWindowType
    case 'hamming'
        taper = hann(S(1),'periodic');
    case 'hann'
        taper = hann(S(1),'periodic');
    case 'blackman'
        taper = blackman(S(1),'periodic');
    case 'tukey'
        taper = window(@tukeywin, size(datSeg,1));
end
taper = repmat(taper,1,S(2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function indF=findFlines(freqIn,f_lines)

indF=[];
nSeg=length(freqIn);

for i=1:nSeg
    indFp=find(f_lines >=freqIn{i}(1) &  f_lines <=freqIn{i}(2));
    indF = [indF , indFp];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

