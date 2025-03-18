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
tlist={'0','400','800','1200','1600','2000','2400','2800','3200','3600','4000','4400','4800','5200','5600', ...
    '6000','6400','6800','7200','7600','8000','8400','8800','9200','9600','10000','10400','10800','11200', ...
    '11600','12000','12400','12800','13200','13600','14000','14400','14800','15200','15600','16000','16400', ...
    '16800','17200','17600'};
for s = 1:size(subs,1)
    disp(['Subject ',subs(s,:)])
    close all;
%     load([sourcedir,subs(s,:)]);
    figure(4);
    subplot(2,2,1)
    magic_str = [subs(s,:),'.Factors1{1,3}'];
    plot(eval(magic_str),'LineWidth',2);
    xlabel('Frequency(Hz)');
    grid on;
    set(gca,'XTick',[5 10 15 20 25],'XTicklabel', flist);
    %     h=legend('Factor 1', 'Factor 2', 'Factor 3','FontSize',12);
    %     set(h,'Color',[1 1 .8])
    sp1p.XLim=[1 30];
    sp1p.XTick=[5 10 15 20 25];
    sp1p.XTickLabel=flist;
    pset(gca,sp1p);
    axis('normal');
    yL=get(gca,'YLim');
    xL=get(gca,'XLim');
    text(24, yL(2)*.825, subs(s,:), 'FontSize', 14, 'HorizontalAlignment', 'right')
    disp('Frequency plot');
    subplot(2,2,2);
    span = 0.1;
    baseline = 450; %% was 60; now 150 or about 15 minutes
    ycrit = [-2 -2 2 2];
    yrange = [-5 5];
    disp('Time plot');
    lc = get(gca,'ColorOrder');
    for i = pfact
        magic_str = [subs(s,:), '.Factors1{1,1}(:,i)'];
        timeFac = smooth(eval(magic_str), span, 'rloess');
        timeFac = (timeFac - mean(timeFac(1:baseline))) ./ std(timeFac(1:baseline));
        if i == 1
            xmax = length(timeFac)
            area([0 xmax xmax 0],ycrit,'facecolor',[.8 .9 .8])
            hold
        end
        plot(timeFac, 'Color', lc(i,:),'LineWidth', 2, 'LineStyle', '-');
    end
    axis([0 xmax yrange])
    xlabel('Time(s)');
    yL=get(gca,'YLim');
    xL=get(gca,'XLim');
    set(gca,'XTick',[0:200:xL(2)]);
    set(gca,'XTicklabel',tlist(1:length(0:200:xL(2))),'FontSize',12);
    pset(gca,sp2p)
    axis('normal')
    disp('Head plots');
    sr = [0 6];
    lr = [12 18];
    SR=ePairs2d3d.d3De1e2 > sr(1) & ePairs2d3d.d3De1e2 <= sr(2);
    MR=ePairs2d3d.d3De1e2 > sr(2) & ePairs2d3d.d3De1e2 <= lr(1);
    LR=ePairs2d3d.d3De1e2 > lr(1) & ePairs2d3d.d3De1e2 <= lr(2);
    for f = 2:4
        magic_str = [subs(s,:),'.Factors1{1,2}(:,',num2str(pfact(f)),');'];
        loadings = eval(magic_str);
        crit = prctile(loadings,pct);
        subplot(2,factors,f+factors);
        hold on;
        axis('square')
        newplot;
        % set(gca,'Visible','Off')
        % First plot short range coherence loadings (skip very short range coherence loadings: d3De1e2 < sr)
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            inds = [ePairs2d3d.e1(pairNum) ePairs2d3d.e2(pairNum)];
            if loadings(i) >= crit & SR(pairNum) 
                line('Xdata',[chanstr(inds(1),1).x chanstr(inds(2),1).x],'Ydata',[chanstr(inds(1),1).y chanstr(inds(2),1).y], ...
                    'Color', [0 0 .8],'LineWidth', 2, 'LineStyle', '-')
            end
        end
        % Now plot mid range coherence loadings over short range
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            inds = [ePairs2d3d.e1(pairNum) ePairs2d3d.e2(pairNum)];
            if loadings(i) >= crit & MR(pairNum) 
                line('Xdata',[chanstr(inds(1),1).x chanstr(inds(2),1).x],'Ydata',[chanstr(inds(1),1).y chanstr(inds(2),1).y], ...
                    'Color', [0 .5 0],'LineWidth', 2, 'LineStyle', '-')
            end
        end
        % Now plot long range coherence loadings over short and mid ranges
        for i = 1:length(loadings)
            magic_str = [subs(s,:),'.indPairsIn(',num2str(i),')'];
            pairNum = eval(magic_str);
            inds = [ePairs2d3d.e1(pairNum) ePairs2d3d.e2(pairNum)];
            if loadings(i) >= crit & LR(pairNum) 
                line('Xdata',[chanstr(inds(1),1).x chanstr(inds(2),1).x],'Ydata',[chanstr(inds(1),1).y chanstr(inds(2),1).y], ...
                    'Color', [.8 0 0],'LineWidth', 2, 'LineStyle', '-')
            end
        end
        scatter([chanstr(1:30,1).x], [chanstr(1:30,1).y], [chanstr(1:30,1).size], 'MarkerEdgeColor', mc(1,:), 'MarkerFaceColor', mc(2,:))
        text([chanstr(1:30,1).x], [chanstr(1:30,1).y], names(1:30), 'FontSize', 6, 'HorizontalAlignment', 'center')
        magic_str = ['pset(gca, sp',num2str(f+2-1),'p)'];
        eval(magic_str);
        axis('normal')
        axis([-1 1 -1 1])
    end
    magic_str = [resdir,subs(s,:),'_COH_F',num2str(factors),'_',num2str(pct),'%SR_vs_LR.fig'];
    disp('Save figure');
    saveas(4, magic_str);
%     clear(subs(s,:))
end