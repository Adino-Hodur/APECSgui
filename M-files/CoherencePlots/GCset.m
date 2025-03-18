function setGC = GCset(GC)
% Plot connected pairs of coherent electrodes on a ellipsoidal map projection
% Usage: GC      = structure of parameters for map projection and graphing 
%        pairNum = electrode pair number (for xyz coordinate lookup) 
%        ePairs  = table of individual numbers for each electrode in a spacific pair number

% Set up the ellipsoidal map projection and map view
axesm('MapProjection',GC.MapProjection);
setm(gca,'Origin',GC.Origin,'MapLatLimit',GC.MapLatLimit,'MapLonLimit',GC.MapLonLimit,'FlatLimit', ...
    GC.FlatLimit,'FlonLimit',GC.FlonLimit,'PLineLocation',GC.PLineLocation,'MLineLimit',GC.MLineLimit, ...
    'MLineLocation',GC.MLineLocation,'Aspect',GC.Aspect,'Grid',GC.gridm,'Frame',GC.framem);
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
% GC.ePairs = ePairs;

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