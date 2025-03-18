function [hF] = plotAtomsNPLS(res,param)
%param.smoothFac = 1;
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

modal=length(size(res.Xtrain)); %%% n-way or 2D

fM = 1; %%% multiplication factor for y-axis range

%%%%% set ticks Step
switch modal
    case 3
        fL1 = param.fLines(param.fLinesInd2use);
        numP=10;
    case 2
        %%% for one variable only
        fL1 = param.fLines(param.fLinesInd2use);
        numP=4;
end
stIn=[5 10:100];jj=1;
stT=0;
while ~stT
    if (fL1(end)/stIn(jj)) < numP
        stT=stIn(jj);
    else
        jj=jj+1;
    end
end

hF =[];
for i=1:param.numFactors
    str = ['fig_atomNPLS',num2str(i)];
    hF{end+1} = str;
end

cstring='brgcmk';
lenColor=length(cstring);

fS=strcat(param.pathName,param.fileName);
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
timeX=([1:size(res.ypred,1)]*epochInSec)/60;
timeXtst=([1:size(res.ypred_test,1)]*epochInSec)/60;
clear header

for f=1:param.numFactors
    figure('Name',hF{f});
    %%%% time plot
    subplot(2,2,1)
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
    dL = find(diff(res.Ytrain) >= 1);
    plot([timeX(dL) timeX(dL)],[min(sX) max(sX)]*fM,'k','LineWidth',2);
    axis([0 timeX(end) min(sX)*fM max(sX)*fM]);
    xlabel('time [min]')
    str = ['atom ',num2str(f),' / smoothing fact.', num2str(param.smoothFac)];
    title(str)
    
    %%% test prediction plot
    subplot(2,2,2)
    sX = smooth(res.T_test(:,f),param.smoothFac,smoothMethod);
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
    dL = find(diff(res.Ytest) >= 1);
    if ~isempty(dL)
        plot([timeXtst(dL) timeXtst(dL)],[min(sX) max(sX)]*fM,'k','LineWidth',2);
    end
    axis([0 timeXtst(end) min(sX)*fM max(sX)*fM]);
    xlabel('time [min]')
    str = ['test: atom ', num2str(f), ' / smoothing fact.', num2str(param.smoothFac)];
    title(str)
    
    switch modal
        case 3
            subplot(2,2,3)
%             xTL=Labels;                      
%             xT = 1:length(xTL);
%             sX= res.Xfactors{2}(:,f);
%             plot(xT,sX,'.-'); % ,[cstring(mod(f,7)+1)]);
%             hold on
%             set(gca,'Xtick',xT);
%             set(gca,'XtickLabel',xTL);
%             axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
            mapeeg2d(channels,res.Xfactors{2}(:,f),[],[],0.01,0,[],[],[],[]);
            str = ['atom ',num2str(f)];
            title(str)
            
            %%%%% freq.
            subplot(2,2,4)
            xT=param.fLines(param.fLinesInd2use);
            sX= res.Xfactors{3}(:,f);
            switch param.binProcess
                case {'none','RelSpect'}
                    plot(xT, sX,'.-'); % ,[cstring(mod(f,7)+1)]);
                    hold on
                    ii=find(rem(xT,stT)==0);
                    set(gca,'Xtick',xT(ii),'XminorTick','on');
                    axis([xT(1) xT(end) min(sX)*fM max(sX)*fM]);
                    str = ['atom ',num2str(f)];
                    xlabel('freq. [Hz]')
                case {'Avg','RelAvg'}
                    plot(sX,'.-'); % ,[cstring(mod(f,7)+1)]);
                    hold on                   
                    axis([1 length(sX) min(sX)*fM max(sX)*fM]);
                    str = ['atom ',num2str(f)];
                    xlabel([ param.binProcess ' freq. bins'])                    
            end
            title(str)
        case 2
            subplot(2,2,3)
            lenVar=length(param.var2use);
            switch param.binProcess
                case {'none','RelSpect'}
                    fL=length(param.fLinesInd2use);
                    xT=[];
                    for e=1:lenVar
                        bg=(e-1)*fL +1; en = bg +fL - 1;
                        plot(bg:en,res.Xfactors{2}(bg:en,f),[cstring(mod(e,lenColor)+1)]);
                        hold on
                        xT=[xT  param.fLines(param.fLinesInd2use)];
                    end
                    tmpTick = 1:fL*lenVar;
                    ii=find(rem(xT,stT)==0);
                    xT=xT(ii);
                    for iT=1:length(xT)
                        ticL{iT}=num2str(xT(iT));
                    end
                    set(gca,'Xtick',tmpTick(ii),'XminorTick','on');
                    set(gca,'XtickLabel',ticL);
                    %%% step for ticks
                    str = ['spatio-freq. atom ',num2str(f),' / Variables: '];
                    for e=1:lenVar
                        str=[str,Labels{e},','];
                    end
                    xlim([1 tmpTick(end)])
                    title(str(end-1))
                    xlabel('freq. [Hz] (x Electrodes)')
                case {'Avg','RelAvg'}
                    fL=length(param.freqIn2use);                   
                    for e=1:lenVar
                        bg=(e-1)*fL +1; en = bg +fL - 1;
                        plot(bg:en,res.Xfactors{2}(bg:en,f),[cstring(mod(e,lenColor)+1)]);
                        hold on                       
                    end
                    str = ['spatio-freq. atom ',num2str(f),' / Variables: '];
                    for e=1:lenVar
                        str=[str,Labels{e},','];
                    end
                    title(str(end-1))
                    xlabel([ param.binProcess ' freq. bins (x Electrodes)'])
            end
                    
    end
    
    
end
