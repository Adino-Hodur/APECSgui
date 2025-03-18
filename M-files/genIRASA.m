% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [datX,datRaw,datFrac,datErr,param]=genIRASA(datX,param)

% clc

logAddConst = 1; % %%%% for log_power+ adds this to all values before log 
logZeroParam = exp(-15) ; %%%% when computing log this replaces 0 values

for mod=1:length(datX)
    
    data       = datX{mod}.chan; %%% eeg data
    inChans    = 1:length(param.Xlabels); %%% at the moment take all
    lenInChans = length(inChans); %%% number of channels to be used
    
    iRaw=[];iOsci=[]; iFrac=[];
    
    for ch=1:lenInChans %%% by channel
        chan = ch; %%% at the moment take all %%% later can specify
        
        datSeg=data{chan}.X;
        % detrend signal, for FFT 
        if strcmp(param.detrendL,'yes')
            datSeg = detrend(datSeg','linear')';
        end
        %%%% zero-mean
        if param.zeroMean
            datSeg=detrend(datSeg','constant')';
%             for t=1:size(datSeg,1)
%                 datSeg(t,:)=datSeg(t,:) - mean(datSeg(t,:));
%             end
        end
        
        %%%% check variance of the epochs
        for t=1:size(datSeg,1)
            d.epochVar(t,chan)=var(datSeg(t,:));
        end
        
        %%%% run IRASA 
        specIRASA = irasaRR(datSeg',param.sampleFreq,param,'frange',param.freqIn{1});
        %%%% set to all <=0
        
        if isempty(param.rectOsc)
            error('Rectification paramter for IRASA not defined!')
        elseif strcmp(param.rectOsc,'yes')
            specIRASA.osci(specIRASA.osci <=0) = 0;
        end
        
        switch  param.irasaSpectraType
            case {'log_power','log_amp'}
                
                specIRASA.osci(specIRASA.osci  <= 0) = logZeroParam;
                specIRASA.osci=10*log10(specIRASA.osci);
                
                specIRASA.mixd(specIRASA.mixd  == 0) = logZeroParam;
                specIRASA.mixd=10*log10(specIRASA.mixd);
                
                specIRASA.frac(specIRASA.frac  == 0) = logZeroParam;
                specIRASA.frac=10*log10(specIRASA.frac);
                
            case {'log_power+','log_amp+'}
                specIRASA.osci=10*log10(specIRASA.osci + logAddConst);                
                specIRASA.mixd=10*log10(specIRASA.mixd + logAddConst);
                specIRASA.frac=10*log10(specIRASA.frac + logAddConst);
                
%             case 'amplitude'
%                 specIRASA.osci(specIRASA.osci  <= 0) = logZeroParam;
%                 specIRASA.osci=sqrt(specIRASA.osci);
%                 
%                 specIRASA.mixd=sqrt(specIRASA.mixd);
%                 specIRASA.frac=sqrt(specIRASA.frac);
        end
        
        if ch==1
            param.f_lines_in=specIRASA.freq';
            param.outEpochLength=length(param.f_lines_in);
        end
        
        iRaw=[iRaw, specIRASA.mixd'];
        iFrac =[iFrac , specIRASA.frac'];
        iOsci =[iOsci   , specIRASA.osci'];
        
        for t=1:size(datSeg,1)
            d.epochVar(t,chan)=var(datSeg(t,:));
        end
        
    end
    
    
    datX{mod}.X=iOsci;
    datRaw{mod}.X=iRaw;
    datFrac{mod}.X=iFrac; 
    datErr{mod}.timeEpochVariance=d.epochVar;
    datX{mod}=rmfield(datX{mod},'chan');
    
    if lenInChans > 1
        param.multiWay = [lenInChans length(param.f_lines_in)];
    elseif lenInChans == 1
        param.multiWay = [1 length(param.f_lines_in)];
    end
    
    
end


