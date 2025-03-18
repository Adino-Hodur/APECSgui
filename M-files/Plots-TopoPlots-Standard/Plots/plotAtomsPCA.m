function hF = plotAtomsPCA(res,param)

%param.smoothFac = 10;
smoothMethod = 'moving'; % 'rloess'

if isfield(param,'Xlabels2use')
    Labels=param.Xlabels2use;
else
    Labels=param.Xlabels;
end


fM = 1; %%% multiplication factor for y-axis range

hF =[];
for i=1:param.numFactors
    str = ['fig_atomParafac',num2str(i)];
    hF{end+1} = str;
end

cstring='brgcmk';
lenColor=length(cstring);
nR=2;

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
    
    %%%% spatio-temporal atom 
    subplot(nR,2,3)
    lenVar=length(param.var2use);
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
    title(str(1:end-1))
    xlabel('freq. [Hz] (x Electrodes)')
end


