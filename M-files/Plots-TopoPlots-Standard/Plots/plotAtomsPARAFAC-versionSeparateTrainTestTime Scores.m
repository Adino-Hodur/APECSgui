function hF = plotAtomsPARAFAC(res,param)

set(0,'DefaultFigureWindowStyle','docked')
%param.smoothFac = 10;
smoothMethod = 'moving'; % 'rloess'


%%%% get channels 
load mont88
if isfield(param,'Xlabels2use')
    Labels = param.Xlabels2use; 
else 
    Labels = param.Xlabels; 
end 

for i=1:length(Labels)
    poz =  find(strcmpi(mont88.name,strtrim(Labels{i}))==1); 
    if ~isempty(poz)
        channels(i,1)=poz; 
    end 
end 



fM = 1; %%% multiplication factor for y-axis range

hF =[];
for i=1:param.numFactors
    str = ['fig_atomParafac',num2str(i)];
    hF{end+1} = str;
end

%%%%% set ticks Step
fL1 = param.fLines(param.fLinesInd2use);
numP=10;
stIn=[5 10:100];jj=1;
stT=0;
while ~stT
    if (fL1(end)/stIn(jj)) < numP
        stT=stIn(jj);
    else
        jj=jj+1;
    end
end


cstring='brgcmk';
lenColor=length(cstring);


if isfield(res,'Xfactors1')
    nR=4;
else
    nR=2;
end


fS=strcat(param.pathName,param.fileName);
if isunix || ismac %%% change all \ to /
    fS(strfind(fS,'\'))='/';
end
load(fS,'header');

if header.fileHeader{1}.lenOverlap > 0
    switch header.fileHeader{1}.lenOverlapUnit
        case 'sec'
            epochInSec = header.fileHeader{1}.lenOverlap;
        case 'msec'
            epochInSec = header.fileHeader{1}.lenOverlap/1000;
        case 'min'
            epochInSec = header.fileHeader{1}.lenOverlap*60;
    end
else
    switch header.fileHeader{1}.lenEpochUnit
        case 'sec'
            epochInSec = header.fileHeader{1}.lenEpoch;
        case 'msec'
            epochInSec = header.fileHeader{1}.lenEpoch/1000;
        case 'min'
            epochInSec = header.fileHeader{1}.lenEpoch*60;
    end
end
clear header

for f=1:param.numFactors
    figure('Name',hF{f});
    
    timeX=([1:size(res.Xtrain,1)]*epochInSec)/60;
    if ~isempty(res.Xtest)
        timeXtst=([1:size(res.Xtest,1)]*epochInSec)/60;
    end
    
    %%%% time plot
    subplot(nR,2,1)
    sX = smooth(res.Xfactors{1}(:,f),param.smoothFac,smoothMethod);
    if isfield(res,'YtrainFileInd')
        fU=unique(res.YtrainFileInd);
        for fI=1:length(fU)
            ii=find(res.YtrainFileInd == fU(fI));
            plot(timeX(ii),sX(ii),[cstring(mod(fI,lenColor)+1)]);
            hold on
        end
    else
        plot(timeX,sX);
        hold on
    end
    %%%% factor 1
    axis([0 timeX(end) min(sX)*fM max(sX)*fM]);
    xlabel('time [min]')
    str = ['atom ',num2str(f),' / smoothing fact.', num2str(param.smoothFac)];
    title(str)
    
    %%% test prediction plot
    if ~isempty(res.Xtest)
        subplot(nR,2,2)
        sX = smooth(res.Xtest_tempAtom(:,f),param.smoothFac,smoothMethod);
        hold on
        if isfield(res,'YtestFileInd')
            fU=unique(res.YtestFileInd);
            for fI=1:length(fU)
                ii=find(res.YtestFileInd == fU(fI));
                plot(timeXtst(ii),sX(ii),[cstring(mod(fI,lenColor)+1)]);
                hold on
            end
        else
            plot(timeXtst,sX);
            hold on
        end
        
        axis([0 timeXtst(end) min(sX)*fM max(sX)*fM]);
        xlabel('time [min]')
        str = ['test: atom ', num2str(f), ' / smoothing fact.', num2str(param.smoothFac)];
        title(str)
    end
        
    subplot(nR,2,3)
    
%     xTL=Labels; 
%     xT = 1:length(xTL);
%     sX= res.Xfactors{2}(:,f);
%     plot(xT,sX,'.-'); % ,[cstring(mod(f,7)+1)]);
%     hold on
%     set(gca,'Xtick',xT);
%     set(gca,'XtickLabel',xTL);
%     axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
      mapeeg2d(channels,res.Xfactors{2}(:,f),[],[],0.01,0,[],[],[],[]);
      str = ['atom ',num2str(f)];
      title(str)
      
    
    
    %%%%% freq.
    subplot(nR,2,4)
    sX= res.Xfactors{3}(:,f);
    if isfield(param,'binProcess') && strcmpi(param.binProcess,'Avg')
        xT=[1:length(param.freqIn2use)];
        xlabel('avg.freq. in bins [Hz]') 
    else
        xT=param.fLines(param.fLinesInd2use);
        xlabel('freq. [Hz]')
    end 
    plot(xT, sX,'.-'); % ,[cstring(mod(f,7)+1)]);
    hold on
    ii=find(rem(xT,stT)==0);
    set(gca,'Xtick',xT(ii),'XminorTick','on');
    axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
    str = ['atom ',num2str(f)];
    
    title(str)
    title(str)
    
    %%%% if second run exist
    if isfield(res,'Xfactors1')        
        timeX=([1:size(res.Xtrain1,1)]*epochInSec)/60;
        if ~isempty(res.Xtest)
            timeXtst=([1:size(res.Xtest,1)]*epochInSec)/60;
        end        
        %%%% time plot
        subplot(nR,2,5)
        sX = smooth(res.Xfactors1{1}(:,f),param.smoothFac,smoothMethod);
        if isfield(res,'YtrainFileInd1')
            fU=unique(res.YtrainFileInd1);
            for fI=1:length(fU)
                ii=find(res.YtrainFileInd1 == fU(fI));
                plot(timeX(ii),sX(ii),[cstring(mod(fI,lenColor)+1)]);
                hold on
            end
        else
            plot(timeX,sX);
            hold on
        end
        %%%% factor 1
        axis([0 timeX(end) min(sX)*fM max(sX)*fM]);
        xlabel('time [min]')
        str = ['atom (2nd run) ',num2str(f),' / smoothing fact.', num2str(param.smoothFac)];
        title(str)
        
        %%% test prediction plot
        if ~isempty(res.Xtest)
            subplot(nR,2,6)
            sX = smooth(res.Xtest_tempAtom1(:,f),param.smoothFac,smoothMethod);
            hold on
            if isfield(res,'YtestFileInd')
                fU=unique(res.YtestFileInd);
                for fI=1:length(fU)
                    ii=find(res.YtestFileInd == fU(fI));
                    plot(timeXtst(ii),sX(ii),[cstring(mod(fI,lenColor)+1)]);
                    hold on
                end
            else
                plot(timeXtst,sX);
                hold on
            end
            axis([0 timeXtst(end) min(sX)*fM max(sX)*fM]);
            xlabel('time [min]')
            str = ['test: atom (2nd run) ', num2str(f), ' / smoothing fact.', num2str(param.smoothFac)];
            title(str)
        end
                
        subplot(nR,2,7)
        %         xTL=Labels;
        %         xT = 1:length(xTL);
        %         sX= res.Xfactors1{2}(:,f);
        %         plot(xT,sX,'.-'); % ,[cstring(mod(f,7)+1)]);
        %         hold on
        %         set(gca,'Xtick',xT);
        %         set(gca,'XtickLabel',xTL);
        %         axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
        %         str = ['atom (2nd run)',num2str(f)];
        %         title(str)
        mapeeg2d(channels,res.Xfactors1{2}(:,f),[],[],0.01,0,[],[],[],[]);
        str = ['atom ',num2str(f)];
        title(str)
        
        %%%%% freq.
        subplot(nR,2,8)
        xT=param.fLines(param.fLinesInd2use);
        sX= res.Xfactors1{3}(:,f);
        plot(xT, sX,'.-'); % ,[cstring(mod(f,7)+1)]);
        hold on
        ii=find(rem(xT,stT)==0);
        set(gca,'Xtick',xT(ii),'XminorTick','on');
        axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
        str = ['atom (2nd run)',num2str(f)];
        xlabel('freq. [Hz]')
        title(str)
                
    end
end
set(0,'DefaultFigureWindowStyle','normal')


