% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [datX,param]=genNP(datX,param)


for mod=1:length(datX)
    
    data       = datX{mod}.chan; %%% eeg data
    inChans    = 1:length(param.Xlabels); %%% at the moment take all
    lenInChans = length(inChans); %%% number of channels to be used
    
    nTrials = size(data{1}.X,1);
    
    for i=1:nTrials
        chX=[];
        for ch=1:lenInChans %%% by channel
            datSeg=data{ch}.X(i,:);
            %%%% zero-mean
%             if param.zeroMean
%                 datSeg=datSeg - mean(datSeg);
%             end
            %%%%%% compute CWT
            chX=[chX , datSeg];
        end
        datX{mod}.X(i,:)=chX;
    end

    datX{mod}=rmfield(datX{mod},'chan');
    
    if lenInChans > 1
        param.multiWay = [lenInChans size(datX{1}.X,2)/lenInChans];
    elseif lenInChans == 1
        param.multiWay = [1 size(datX{1}.X,2)/lenInChans];
    end

end

