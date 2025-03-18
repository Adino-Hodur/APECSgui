% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [param,datX,newArt]=genCoherence(param,datX,Art)

if nargin == 2  
    newArt=[];
end 

logZeroParam = exp(-15) ; %%%% when computing log this replaces 0 values

for mod=1:length(datX)
    
    data       = datX{mod}.chan; %%% eeg data
    inChans    = 1:length(param.Xlabels); %%% at the moment take all
    lenInChans = length(inChans); %%% number of channels to be used
    
    
    lenInChans=length(inChans); %%% number of channels to be used
    lenChanPairs = ((lenInChans * (lenInChans -1))/2) + lenInChans ;
    
    nTrials=size(data{1}.X,1);
    %%% compute coherence
    for i=1:nTrials
        indL = 1; 
        for ch1=1:lenInChans
            for ch2=ch1:lenInChans
                datSeg1=data{ch1}.X(i,:);
                datSeg2=data{ch2}.X(i,:);
                
                
                %%%% zero-mean
                if param.zeroMean
                    datSeg1 = datSeg1 - mean(datSeg1);
                    datSeg2 = datSeg2 - mean(datSeg2);
                end
                %%%% set window
                switch param.coherWindowType
                    case 'hamming'
                        w = window(@hamming, param.coherWin);
                    case 'hann'
                        w = window(@hann, param.coherWin);
                    case 'blackman'
                        w = window(@blackman, param.coherWin);
                    case 'tukey'
                        w = window(@tukeywin, param.coherWin);
                    case 'none'
                        w = ones(param.coherWin,1);
                end
                %%%% compute coherence
                switch param.coherMethod
                    case 'fft'
                        xF = fft(datSeg1,param.nFFT);
                        yF = fft(datSeg2,param.nFFT);
                        %Pxx = (xF.* conj(xF))./ param.nFFT ; % (param.sampleFreq*param.nFFT);
                        %Pxx = Pxx(1:param.nFFT/2+1)';
                        %Pyy = (yF.* conj(yF))./ param.nFFT ; % (param.sampleFreq*param.nFFT);
                        %Pyy = Pyy(1:param.nFFT/2+1)';
                        tmpPxy = (xF.* conj(yF))./ (param.nFFT*(param.sampleFreq/2));
                        Pxy    = tmpPxy(1:param.nFFT/2)';
                        %%%  if include 0
                        %%%   Pxy = tmpPxy(1:param.nFFT/2+1)';
                        
                        if ~exist('f_lines')
                            %%% ignores 0 bin - DC to be equal with BCI2000
                            f_lines = param.sampleFreq*(1:param.nFFT/2)/param.nFFT;
                            %%% include 0 bin
                            % f_lines = param.sampleFreq*(0:param.nFFT/2)/param.nFFT;
                        end
                    case 'cpsd'
                        %%%% return coherence for the whole spectrum
                        [cXY,f_lines] = cpsd(datSeg1,datSeg2,w,param.coherWinOverlap,param.nFFT,param.sampleFreq);
                    case 'mscohere'
                        [cXY,f_lines] = mscohere(datSeg1,datSeg2,w,param.coherWinOverlap,param.nFFT,param.sampleFreq);
                    case 'tfestimate'
                        [cXY,f_lines] = tfestimate(datSeg1,datSeg2,w,param.coherWinOverlap,param.nFFT,param.sampleFreq);
                end
                if i==1 %%% first epoch (sample)
                    indF=findFlines(param.freqIn,f_lines);
                    f_lines_in=f_lines(indF);
                    lenfLines=length(f_lines_in);
                end 
                if indL==1 %%% first pair 
                    cXYChAll=zeros(1,lenChanPairs*lenfLines);
                end
                %%%% take the magnitute only !!!!!
                bg=(indL-1)*lenfLines +1; en=bg+lenfLines -1; 
                indL=indL+1; 
                cXYChAll(1,bg:en) = cXY(indF); 
            end %%% ch2
        end  %%% ch1
        if i==1
            d.cXY = zeros(nTrials,lenChanPairs*lenfLines);
        end
        d.cXY(i,:)=cXYChAll;
        % disp(i)
    end % i
    
    datX{mod}.X=d.cXY;
    param.f_lines_in=f_lines_in;
    datX{mod}=rmfield(datX{mod},'chan');
    
    if lenChanPairs > 1
        param.multiWay = [lenChanPairs length(param.f_lines_in)];
    elseif lenChanPairs == 1
        param.multiWay = [1 length(param.f_lines_in)];
    end
    
    %%%% create new Xlabels
    indX=1;
    for ch1=1:lenInChans
        for ch2=ch1:lenInChans
            cXlabels{indX}=[param.Xlabels{ch1},'-',param.Xlabels{ch2}];
            indX=indX + 1;
        end
    end
    param.origXlabels = param.Xlabels; 
    param.Xlabels =  cXlabels;
    
    %%%%% make new artifacts for a pair of electrodes
    if exist('Art','var')
        for ch1=1:lenInChans
            for ch2=ch1:lenInChans
                newArt=[newArt, sign(Art(:,ch1) + Art(:,ch2))];
            end
        end
        newArt=[newArt, sign(sum(newArt,2))];
    end
    
    
end % mod


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function indF=findFlines(freqIn,f_lines)

indF=[];
nSeg=length(freqIn);

for i=1:nSeg
    indFp=find(f_lines >=freqIn{i}(1) &  f_lines <=freqIn{i}(2));
    indF = [indF , indFp];
end