function GC = parameters_GC(ePairs,chanstr)
GC.MapProjection = 'werner';
GC.gridm = 'on';
GC.framem = 'off';
GC.Origin = [70 180 0];
GC.MapLatLimit = [-60 90];
GC.MapLonLimit = [-180 180];
GC.FlatLimit = [-75 90];
GC.FlonLimit = [-180 180];
% GC.PLineLocation = [.1:.1:.9]*180-90;
GC.PLineLocation = [0 30 45 67.5];
GC.MLineLocation = -180:18:162;
GC.MLineLimit = [0 90];
GC.Aspect = 'normal';
GC.HeadPlotAxis = [-1.75 1.75 -3 0.5];
GC.HeadPlotTextPos = [1.7 0.45];
GC.SR.lx = [-1.7 -1.6]; GC.SR.ly = [0.3 0.3];
GC.MR.lx = [-1.7 -1.6]; GC.MR.ly = [0.1 0.1];
GC.LR.lx = [-1.7 -1.6]; GC.LR.ly = [-.1 -.1];
GC.SR.tx = -1.55; GC.SR.ty = 0.3;
GC.MR.tx = -1.55; GC.MR.ty = 0.1;
GC.LR.tx = -1.55; GC.LR.ty = -.1;
GC.SR.col = [.8 .4 .8]; % Light Magenta
GC.SR.lim = [0 6];
GC.SR.wid = 7;
GC.MR.col = [0 .75 .75]; % Medium-light Cyan
GC.MR.lim = [6 12];
GC.MR.wid = 3.5;
GC.LR.col = [.6 .3 0]; % Dark Orange
GC.LR.lim = [12 18];
GC.LR.wid = 1.75;
GC.Marker = 'o';
GC.MarkerEdgeColor = [0 0 .5]; % Dark blue
GC.MarkerFaceColor = [0 0 .5]; 
GC.colormap = 'gray';
GC.SmallCircleRadius = 1.5;
GC.geoid = [9 0];
GC.ePairs = ePairs;
GC.chanstr = chanstr;