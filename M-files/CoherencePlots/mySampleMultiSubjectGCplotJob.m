rootdir = ['C:\Users\PDT\Documents\ARO-STIR-Analyses\'];
homedir = [rootdir,'Cognitive Fatigue 2'];
cd(homedir)
load('chanlist.mat')
load('chanstr.mat')
load('names.mat')
load('ePairs.mat')
load('ePairs2d3d.mat')
% load('allSubsRes.mat')
load('spXp.mat')
nchans=length(names);
subs = (['GSD']);
% subs = (['ARB';'GSD';'JCH';'JCS';'KTT';'MMB';'MMC';'RGR';'RWC';'SKH';'TBN';'WXS']);
factors=4;
pfact = 1:factors;
pct = 75;
sourcedir = [homedir,'\Data\Results\Coherence\Win2sec_Overlap0ms\4-factors\NwayConst=223\'];
resdir = [sourcedir,'\Coh-Crit-',num2str(pct),'%-223\'];
if ~isdir(resdir)
    mkdir(resdir);
end
mc = [0 0 0; .9 .9 .9];
flist={'5','10','15','20','25'};
tlist={'0','400','800','1200','1600','2000','2400'};
lc = [.3 .3 .3; .05 .05 .9; .05 .7 0; .9 .05 .05; 0 .5 .5];
for s = 1:size(subs,1)
    disp(['Subject ',subs(s,:)])
    close all;
    %     load([sourcedir,subs(s,:)]);
    gcf = figure();
    %%% Frequency plot
    disp('Frequency plot');
    set(gcf,'DefaultAxesColorOrder',lc)
    subplot(2,2,1)
    magic_str = [subs(s,:),'.Factors1{1,3}'];
    plot(eval(magic_str),'LineWidth',1.5);
    title('Frequency(Hz)','FontSize',12,'Color','k','VerticalAlignment','baseline');
    grid on;
    set(gca,'XTick',[5 10 15 20 25],'XTicklabel', flist);
    sp1p.XLim=[1 25];
    sp1p.XTick=[5 10 15 20 25];
    sp1p.XTickLabel=flist;
    pset(gca,sp1p);
    axis('normal');
    axis([1 25 0 .75]);
    text(2,.7,subs(s,:),'FontSize',12,'HorizontalAlignment','left', ...
        'VerticalAlignment','cap')
    h = legend(['Atom 0';'Atom 1';'Atom 2';'Atom 3']);
    set(h,'Box','off','Color','none','FontSize',11,'Location','NorthEast');
    ylabel('Loadings','FontSize',12,'Color','k','VerticalAlignment','baseline')
    %%% Time plot
    disp('Time plot');
    subplot(2,2,2);
    set(gcf,'DefaultAxesColorOrder',lc)
    span = 0.3;
    ycrit = [-2 -2 2 2];
    yrange = [-4 4]; % Default overall range of z-scores for graph
    for i = pfact
        % Get breakpoints
        magic_str = [subs(s,:), '.d.sessionLen1(1,1:2)']; % First two blocks (of four)
        BP1 = sum(eval(magic_str));
        magic_str = [subs(s,:), '.d.sessionLen1(1,3:4)']; % Last two blocks (of four)
        BP2 = sum(eval(magic_str))+BP1;
        % Smooth sections separately
        magic_str = [subs(s,:), '.Factors1{1,1}(1:BP1,i)'];
        timeFacS1 = smooth(eval(magic_str), span, 'rloess');
        magic_str = [subs(s,:), '.Factors1{1,1}((BP1+1):BP2,i)'];
        timeFacS2 = smooth(eval(magic_str), span, 'rloess');
        % Compute z-scores using mean and sd of Section 1 as the baseline values
        tFbar = mean(timeFacS1); tFs = std(timeFacS1);
        timeFacS1 = (timeFacS1 - tFbar) ./ tFs;
        timeFacS2 = (timeFacS2 - tFbar) ./ tFs;
        % Highlight the sections (only once)and mark the first breakpoint
        if i == 1
            area([0 BP2 BP2 0],ycrit,'facecolor',[.85 1 .85]) % Green-gray
            hold
        end
        % Plot separate lines for each section
        line(    1:BP1,timeFacS1,'Color',lc(i,:),'LineWidth',1.5,'LineStyle','-');
        line(BP1+1:BP2,timeFacS2,'Color',lc(i,:),'LineWidth',1.5,'LineStyle','-');
        % Update the overall range of z-scores if it exceeds the default range
        yrange = [min([yrange(1) min([timeFacS1; timeFacS2])]) max([yrange(2) max([timeFacS1; timeFacS2])])];
    end
    % Plot a dashed vertical line to divide the sections
    line([BP1 BP1],yrange,'Color',lc(1,:),'LineStyle','--','Linewidth',2);
    text(BP1-40,yrange(1)+.4,'\leftarrow Alert','FontSize',12,'HorizontalAlignment','right', ...
        'VerticalAlignment','baseline')
    text(BP1+40,yrange(1)+.4,'Fatigued \rightarrow ','FontSize',12,'HorizontalAlignment','left', ...
        'VerticalAlignment','baseline')
    title('Time(epoch-seconds)','FontSize',12,'Color','k','VerticalAlignment','baseline');
    ylabel('Standardized loadings (z-scores)','FontSize',12,'Color','k','VerticalAlignment','baseline')
    pset(gca,sp2p)
    axis([0 BP2 yrange])
    tickLoc1 = 0:200:BP1;
    tickLoc2 = BP1+1:200:BP2;
    set(gca,'XTick',[tickLoc1(1:length(tickLoc1)-1) tickLoc2(1:length(tickLoc2)-1)]);
    set(gca,'XTicklabel',[tlist(1:length(tickLoc1)-1) tlist(1:length(tickLoc2)-1)],'FontSize',12);
    %%% Headplots
    axis('normal')
    disp('Head plots');
    GC = parameters_GC(ePairs,chanstr);
    SR=ePairs2d3d.d3De1e2 > GC.SR.lim(1) & ePairs2d3d.d3De1e2 <= GC.SR.lim(2);
    MR=ePairs2d3d.d3De1e2 > GC.SR.lim(2) & ePairs2d3d.d3De1e2 <= GC.LR.lim(1);
    LR=ePairs2d3d.d3De1e2 > GC.LR.lim(1) & ePairs2d3d.d3De1e2 <= GC.LR.lim(2);
    for f = 2:factors % Skip "Atom 0", the mean or background factor
        magic_str = [subs(s,:),'.Factors1{1,2}(:,',num2str(pfact(f)),');'];
        loadings = eval(magic_str);
        crit = prctile(loadings,pct);
        subplot(2,factors,f+factors);
        hold on;
        axis('square')
        GC = parameters_GC(ePairs,chanstr);
        setGC = GCset(GC);
        % set(gca,'Visible','Off')
        % First plot short range coherence loadings
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            if loadings(i) >= crit & SR(pairNum)
                GC.LineColor = GC.SR.col;
                GC.LineWidth = GC.SR.wid;
                plotGC = GCplot(GC,pairNum);
                text(GC.HeadPlotTextPos(1),GC.HeadPlotTextPos(2),['    '; [num2str(pct),'%+']],'FontSize',12, ...
                    'HorizontalAlignment','right','Color',lc(f,:),'VerticalAlignment','top')
            end
        end
        % Now plot mid range coherence loadings over short range
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            if loadings(i) >= crit & MR(pairNum)
                GC.LineColor = GC.MR.col;
                GC.LineWidth = GC.MR.wid;
                plotGC = GCplot(GC,pairNum);
                text(GC.HeadPlotTextPos(1),GC.HeadPlotTextPos(2),['    '; [num2str(pct),'%+']],'FontSize',12, ...
                    'HorizontalAlignment','right','Color',lc(f,:),'VerticalAlignment','top')
            end
        end
        % Now plot long range coherence loadings over short and mid ranges
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            if loadings(i) >= crit & LR(pairNum)
                GC.LineColor = GC.LR.col;
                GC.LineWidth = GC.LR.wid;
                plotGC = GCplot(GC,pairNum);
                text(GC.HeadPlotTextPos(1),GC.HeadPlotTextPos(2),['    '; [num2str(pct),'%+']],'FontSize',12, ...
                    'HorizontalAlignment','right','Color',lc(f,:),'VerticalAlignment','top')
            end
        end
        % Label the plot with the Atom number
        text(GC.HeadPlotTextPos(1),GC.HeadPlotTextPos(2),['Atom ',num2str(f-1)],'FontSize',12, ...
            'HorizontalAlignment','right','Color',lc(f,:),'VerticalAlignment','top')
        % Custom legend of the plot lines with range letters (SML)
        line(GC.SR.lx,GC.SR.ly,'Color',GC.SR.col,'LineWidth',GC.SR.wid)
        text(GC.SR.tx,GC.SR.ty,'S','FontSize',12,'Color','k','HorizontalAlignment','left')
        line(GC.MR.lx,GC.MR.ly,'Color',GC.MR.col,'LineWidth',GC.MR.wid)
        text(GC.MR.tx,GC.MR.ty,'M','FontSize',12,'Color','k','HorizontalAlignment','left')
        line(GC.LR.lx,GC.LR.ly,'Color',GC.LR.col,'LineWidth',GC.LR.wid)
        text(GC.LR.tx,GC.LR.ty,'L','FontSize',12,'Color','k','HorizontalAlignment','left')
        magic_str = ['pset(gca, sp',num2str(f+2-1),'p)'];
        eval(magic_str);
        axis(GC.HeadPlotAxis);
        ylabel('Posterior \leftrightarrow Anterior','FontSize',12,'Color','k','VerticalAlignment','baseline')
        xlabel('Left \leftrightarrow Right','FontSize',12,'Color','k','VerticalAlignment','middle')
    end
    magic_str = [resdir,subs(s,:),'_COH_F',num2str(factors),'_',num2str(pct),'%SR_vs_LR.fig'];
    disp('Save figure');
    saveas(gcf, magic_str);
    %     clear(subs(s,:))
end