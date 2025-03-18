function setGC = GeoCoherenceMap(GC,pairNum)
% Plot connected pairs of coherent electrodes on a ellipsoidal map projection
% Usage: GC      = structure of parameters for map projection and graphing 
%        pairNum = electrode pair number (for xyz coordinate lookup) 
%        ePairs  = table of individual numbers for each electrode in a spacific pair number

% Set up the ellipsoidal map projection and map view
axesm('MapProjection',GC.MapProjection);
setm(gca,'Origin',GC.Origin,'MapLatLimit',GC.MapLimit,'MapLonLimit',GC.MapLonLimit,'FlatLimit', ...
    GC.FlatLimit,'FlonLimit',GC.FlonLimit,'PLineLocation',GC.PLineLocation,'Aspect',GC.Aspect, ...
    'Grid',GC.gridm,'Frame',GC.framem)

% Look up indices (individual numbers) of each electrode in the pair
inds = [GC.ePairs(pairNum,1) GC.ePairs(pairNum,2)];

% Compute geodetic coordinates of electrode positions from Cartesian xyz
%         coordinates stored in the channel information structure (chanstr)
[phi1, lambda1, h1]= ecef2geodetic(GC.chanstr(inds(1),1).x3, GC.chanstr(inds(1),1).y3, GC.chanstr(inds(1),1).z3, GC.geoid);
[phi2, lambda2, h2]= ecef2geodetic(GC.chanstr(inds(2),1).x3, GC.chanstr(inds(2),1).y3, GC.chanstr(inds(2),1).z3, GC.geoid);

% Plot small circles around centers of electrode positions
[latc1, longc1] = scircle1(rad2deg(phi1),rad2deg(lambda1),GC.SmallCircleRadius);
plotm(latc1, longc1,'Color',GC.LineColor,'Marker',GC.Marker,'MarkerFaceColor',GC.MarkerFaceColor)
[latc2, longc2] = scircle1(rad2deg(phi2),rad2deg(lambda2),GC.SmallCircleRadius);
plotm(latc2, longc2,'Color',GC.LineColor,'Marker',GC.Marker,'MarkerFaceColor',GC.MarkerFaceColor)

% Plot lines connecting the electrode centers
[lattrkgc, lontrkgc] = track2(rad2deg(phi1),rad2deg(lambda1),rad2deg(phi2),rad2deg(lambda2));
linem(lattrkgc, lontrkgc,'Color',GC.LineColor)
setGC = getm(gca);


% Default settings for GC structure
% GC.MapProjection = 'wetch';
% GC.gridm = 'on';
% GC.framem = 'off';
% GC.Origin = [90 0 0];
% GC.MapLimit = [-60 60];
% GC.MapLonLimit = [-180 180];
% GC.FlatLimit = [-70 70];
% GC.FlonLimit = [-100 100];
% GC.PLineLocation = [.1:.1:.9]*180-90;
% GC.Aspect = 'transverse';
% GC.LineColor = 'b';
% GC.LineWidth = '1';
% GC.Marker = 'o';
% GC.MarkerFaceColor = 'b';
% GC.colormap = 'gray';
% GC.SmallCircleRadius = 2;
% GC.geoid = [9 0];
% GC.ePairs2d3d = ePairs2d3d;

% Unused 3D solid projection code
% [X,Y,Z] = sphere(100) ;
% colormap gray
% surfl(X,Y,Z,[0 90])
% shading interp
% axis('square')
% elec3d = ePairs2(1:30,11:13)./9;
% hold
% plot3(elec3d(:,1),elec3d(:,2),elec3d(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','b')
% view([90 90])