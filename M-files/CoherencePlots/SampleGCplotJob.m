% Sample script for GeoCoherenceMap with different coherence ranges
% A percentile "pct" mustr be set to cut off low coherences
% GC parameters are set in GC.m
% Factors and loadings in workspace
for f = 1:factors
    magic_str = [subs(s,:),'.Factors1{1,2}(:,',num2str(pfact(f)),');'];
    loadings = eval(magic_str);
    crit = prctile(loadings,pct);
    subplot(2,2,f,'align');
    hold on;
    %         axis('square')
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
        end
    end
    % Label the plot with the Atom number and percentile
    text(GC.HeadPlotTextPos(1),GC.HeadPlotTextPos(2),['Atom ',num2str(f); ['  ',num2str(pct),'%+']],'FontSize',12, ...
        'HorizontalAlignment','right','Color',lc(f,:),'VerticalAlignment','top')
    % Custom legend of the plot lines with range letters (SML)
    line(GC.SR.lx,GC.SR.ly,'Color',GC.SR.col,'LineWidth',GC.SR.wid)
    text(GC.SR.tx,GC.SR.ty,'S','FontSize',12,'Color','k','HorizontalAlignment','left')
    line(GC.MR.lx,GC.MR.ly,'Color',GC.MR.col,'LineWidth',GC.MR.wid)
    text(GC.MR.tx,GC.MR.ty,'M','FontSize',12,'Color','k','HorizontalAlignment','left')
    line(GC.LR.lx,GC.LR.ly,'Color',GC.LR.col,'LineWidth',GC.LR.wid)
    text(GC.LR.tx,GC.LR.ty,'L','FontSize',12,'Color','k','HorizontalAlignment','left')
    %         magic_str = ['pset(gca, sp',num2str(f+2-1),'p)'];
    %         eval(magic_str);
    axis(GC.HeadPlotAxis);
    if f == 1 || f == 3
        ylabel('Posterior \leftrightarrow Anterior','FontSize',12,'Color','k','VerticalAlignment','baseline')
    end
    if f ==3 || f == 4
        xlabel('Left \leftrightarrow Right','FontSize',12,'Color','k','VerticalAlignment','middle')
    end
end