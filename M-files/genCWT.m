% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [datX,param]=genCWT(datX,param,datErr)


for mod=1:length(datX)
    
    data       = datX{mod}.chan; %%% eeg data
    lenEpoch   = size(datX{mod}.chan{1}.X,2);  %%% length of a single epoch, i.e. time-points  
    inChans    = 1:length(param.Xlabels); %%% at the moment take all
    lenInChans = length(inChans); %%% number of channels to be used
    nTrials = size(data{1}.X,1);

    
    %%%%% scale <-> freq.
    if isfield(param,'sampleFreq')
        switch param.sampleFreqUnit
            case 'Hz'
                sF=param.sampleFreq;
            case 'kHz'
                sF=param.sampleFreq/1000;
            otherwise
                error('Sample freq. not Hz or kHz')
        end
        sP=1/sF; %%%% sampling period 
    else
        warndlg('Sample freq. not present, need to define sampling period for scal2freq to compute wavelet center frequencies','!! Warning !!')
    end
            
    switch param.cwtUnit 
        case 'scales' 
            param.cwtFreqs=scal2frq(param.cwtScales,param.cwtType,sP);
        case 'freqs'
            Fc=centfrq(param.cwtType); 
            param.cwtScales=Fc./(param.cwtFreqs.*sP);
    end 
    
    lenScales  = length(param.cwtScales);
    dimX2      = lenScales*lenInChans; 
    
    
    switch param.procWTcoef
        case{'ITPC','ITLC','ERSP','WTav','avWT','WTav-avWT','avg'} %%%% avg - average through all trials 
            %%%% flip scale to freq ascending
            [param.cwtFreqs, indSort]=sort(param.cwtFreqs);
            param.cwtScales=param.cwtScales(indSort);
            param.f_lines_in=param.cwtFreqs;
            param.freqIn{1}=[min(param.cwtFreqs) max(param.cwtFreqs)];
            
            if exist('datErr','var')
                iC=find(datErr{1}.artifact==0);
                nTrialsClean=length(iC);
            else
                nTrialsClean=nTrials; 
                iC=[1:nTrials]; 
            end
            param.cleanEpochsPerc=(nTrialsClean/nTrials)*100;
    end 
    
    
    %%% compute CWT by epoch
    switch param.procWTcoef
        case {'none'}
            for i=1:nTrials
                chX=[];
                for ch=1:lenInChans %%% by channel
                    datSeg=data{ch}.X(i,:);
                    %%%% zero-mean
                    if param.zeroMean
                        datSeg=datSeg - mean(datSeg);
                    end
                    %%%%%% compute CWT
                    chX=[chX , cwt(datSeg,param.cwtScales,param.cwtType)];
                end
                datX{mod}.epoch(i).X=chX;
            end
            param.outEpochLength=size(data{mod}.X,1);
        case {'avg'}
            datX{mod}.X=zeros(lenScales,lenInChans*lenEpoch);
            for i=1:nTrialsClean
                chX=[];
                for ch=1:lenInChans %%% by channel
                    datSeg=data{ch}.X(iC(i),:);
                    %%%% zero-mean
                    if param.zeroMean
                        datSeg=datSeg - mean(datSeg);
                    end
                    %%%%%% compute CWT and transpose to get scales/freq on x
                    chX=[chX , cwt(datSeg,param.cwtScales,param.cwtType)];
                end
                datX{mod}.X=datX{mod}.X +  chX;
            end
            datX{mod}.X=datX{mod}.X/nTrialsClean;
            param.outEpochLength=size(datX{mod}.X,1);
        case {'ITLC'}
            for i=1:nTrialsClean
                chX=[];
                for ch=1:lenInChans %%% by channel
                    datSeg=data{ch}.X(i,:);
                    %%%% zero-mean
                    if param.zeroMean
                        datSeg=datSeg - mean(datSeg);
                    end
                    %%%%%% compute CWT
                    chX=[chX , cwt(datSeg,param.cwtScales,param.cwtType)'];
                end
                datX{mod}.epoch(i).X=chX;
            end
            avgX=zeros(lenEpoch,dimX2);
            for i=1:nTrialsClean
                avgX=avgX + abs(datX{mod}.epoch(i).X).^2;
            end
            avgX=sqrt(avgX/nTrialsClean);
            
            datX{mod}.X=zeros(lenEpoch,dimX2);
            for i=1:nTrialsClean
                datX{mod}.X=datX{mod}.X + datX{mod}.epoch(i).X./avgX;
            end
            datX{mod}.X=abs(datX{mod}.X)/nTrialsClean;
            datX{mod}=rmfield(datX{mod},'epoch');
            param.outEpochLength=size(data{mod}.X,1);
        case {'ITPC','ERSP','WTav','avWT'}
            datX{mod}.X=zeros(lenEpoch,dimX2);
            for i=1:nTrialsClean
                chX=[];
                for ch=1:lenInChans %%% by channel
                    datSeg=data{ch}.X(iC(i),:);
                    %%%% zero-mean
                    if param.zeroMean
                        datSeg=datSeg - mean(datSeg);
                    end
                    %%%%%% compute CWT and transpose to get scales/freq on x
                    chX=[chX , cwt(datSeg,param.cwtScales,param.cwtType)'];
                end
                switch param.procWTcoef
                    case {'ITPC'}
                        datX{mod}.X=datX{mod}.X +  chX./abs(chX);
                    case {'ERSP'}
                        datX{mod}.X=datX{mod}.X +  abs(chX).^2;
                    case {'WTav'}
                        datX{mod}.X=datX{mod}.X +  abs(chX);
                    case {'avWT'}
                        datX{mod}.X=datX{mod}.X +  chX;
                end  
            end
            switch param.procWTcoef
                case {'ITPC','avWT'}
                    datX{mod}.X=abs(datX{mod}.X)/nTrialsClean;
                case {'ERSP','WTav'}
                    datX{mod}.X=datX{mod}.X/nTrialsClean;
            end
            param.outEpochLength=size(datX{mod}.X,1);
        case {'WTav-avWT'}'
            datX{mod}.X =zeros(lenEpoch,dimX2); %%% WTav
            datX{mod}.X1=zeros(lenEpoch,dimX2); %%% avWT
            for i=1:nTrialsClean
                chX=[];
                for ch=1:lenInChans %%% by channel
                    datSeg=data{ch}.X(iC(i),:);
                    %%%% zero-mean
                    if param.zeroMean
                        datSeg=datSeg - mean(datSeg);
                    end
                    %%%%%% compute CWT and transpose to get scales/freq on x
                    chX=[chX , cwt(datSeg,param.cwtScales,param.cwtType)'];
                end
                datX{mod}.X  = datX{mod}.X  +  abs(chX);
                datX{mod}.X1 = datX{mod}.X1 +  chX;
            end
            datX{mod}.X=(datX{mod}.X - abs(datX{mod}.X1))./nTrialsClean;
            datX{mod}=rmfield(datX{mod},'X1'); 
            param.outEpochLength=size(datX{mod}.X,1);
    end
     %%%% length of a segment
    datX{mod}=rmfield(datX{mod},'chan');
    
    if lenInChans > 1
        param.multiWay = [lenInChans length(param.cwtScales)];
    elseif lenInChans == 1
        param.multiWay = [1 length(param.cwtScales)];
    end
    
    %datX{mod}.param=param;
    
end

