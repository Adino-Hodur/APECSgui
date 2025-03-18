function plotGC = GCplot(GC,pairNum)

% Look up indices (individual numbers) of each electrode in the pair
inds = [GC.ePairs(pairNum,1) GC.ePairs(pairNum,2)];

% Compute geodetic coordinates of electrode positions from Cartesian xyz
%         coordinates stored in the channel information structure (chanstr)
[phi1, lambda1, h1]= ecef2geodetic(GC.chanstr(inds(1),1).x3, GC.chanstr(inds(1),1).y3, ...
    GC.chanstr(inds(1),1).z3, GC.geoid);
[phi2, lambda2, h2]= ecef2geodetic(GC.chanstr(inds(2),1).x3, GC.chanstr(inds(2),1).y3, ...
    GC.chanstr(inds(2),1).z3, GC.geoid);

% Plot lines connecting the electrode centers
[lattrkgc, lontrkgc] = track2(rad2deg(phi1),rad2deg(lambda1),rad2deg(phi2),rad2deg(lambda2));
linem(lattrkgc, lontrkgc,'Color',GC.LineColor,'LineWidth',GC.LineWidth)

% Plot small circles around centers of electrode positions
[latc1, longc1] = scircle1(rad2deg(phi1),rad2deg(lambda1),GC.SmallCircleRadius);
plotm(latc1, longc1,'Marker',GC.Marker,'MarkerEdgeColor',GC.MarkerEdgeColor, ...
    'MarkerFaceColor',GC.MarkerFaceColor)
[latc2, longc2] = scircle1(rad2deg(phi2),rad2deg(lambda2),GC.SmallCircleRadius);
plotm(latc2, longc2,'Marker',GC.Marker,'MarkerEdgeColor',GC.MarkerEdgeColor, ...
    'MarkerFaceColor',GC.MarkerFaceColor)

plotGC = getm(gca);