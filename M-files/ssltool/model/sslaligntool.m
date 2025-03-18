function X = sslaligntool(M,E)
%SSLALIGNTOOL A GUI Tool for mesh and electrode alignment.
%   C = SSLALIGNTOOL(A,B) brings up the alignment tool GUI for
%   target B with reference mesh A, the aligned info is stored in C.
%   A should be a mesh structure.
%   B can be either a mesh or an electrode structure.

% Siyi Deng; 03-01-2011; 05-11-2011;

%% Setting up the GUI;
H = sslcanvas3d;
view(90,0);
set(H.Fig,'unit','pixel','position',[100,100,900,640],...
    'name','SSLTool :: Alignment','visible','off');

H.PaneControl = uipanel(H.Fig,'units','pixel',...
    'position',[8 20 360 600],'Title','Control panel',...
    'Backgr',[240 240 240]./255,'BorderType','line');

H.PaneCanvas = uipanel(H.Fig,'units','norm',...
    'position',[.42 .02 .57 .96],'Backgr',[0 0 0],'BorderType','none');

set(H.Axes,'parent',H.PaneCanvas,'unit','norm','position',[0 0 1 1]);

H.SliderRotX = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 400 280 60],...
    'Maximum',180,'Minimum',-180,'value',0,...
    'MajorTickSpacing',60,'MinorTickSpacing',10,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerRotX = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 420 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Rot X',...
    'Units','pixel','Position',[300 442 50 20],'Horiz','left');

H.SliderRotY = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 335 280 60],...
    'Maximum',180,'Minimum',-180,'value',0,...
    'MajorTickSpacing',60,'MinorTickSpacing',10,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerRotY = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 355 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Rot Y',...
    'Units','pixel','Position',[300 377 50 20],'Horiz','left');

H.SliderRotZ = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 270 280 60],...
    'Maximum',180,'Minimum',-180,'value',0,...
    'MajorTickSpacing',60,'MinorTickSpacing',10,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerRotZ = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 290 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Rot Z',...
    'Units','pixel','Position',[300 312 50 20],'Horiz','left');

H.SliderShiftX = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 205 280 60],...
    'Maximum',100,'Minimum',-100,'value',0,...
    'MajorTickSpacing',25,'MinorTickSpacing',5,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerShiftX = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 225 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Shift X',...
    'Units','pixel','Position',[300 247 50 20],'Horiz','left');

H.SliderShiftY = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 140 280 60],...
    'Maximum',100,'Minimum',-100,'value',0,...
    'MajorTickSpacing',25,'MinorTickSpacing',5,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerShiftY = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 160 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Shift Y',...
    'Units','pixel','Position',[300 182 50 20],'Horiz','left');

H.SliderShiftZ = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 75 280 60],...
    'Maximum',100,'Minimum',-100,'value',0,...
    'MajorTickSpacing',25,'MinorTickSpacing',5,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerShiftZ = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 95 50 21],'value',0);
uicontrol(H.PaneControl,'style','text','string','Shift Z',...
    'Units','pixel','Position',[300 117 50 20],'Horiz','left');

H.SliderScale = jcontrol(H.PaneControl,'javax.swing.JSlider',...
    'Units','Pixel','Position',[10 10 280 60],...
    'Maximum',200,'Minimum',0,'value',100,...
    'MajorTickSpacing',50,...
    'MinorTickSpacing',10,...
    'PaintLabels',true,'PaintTicks',true);
H.SpinnerScale = jcontrol(H.PaneControl,'javax.swing.JSpinner',...
    'Units','pixel','Position',[300 30 50 21],'value',100);
uicontrol(H.PaneControl,'style','text','string','Scale',...
    'Units','pixel','Position',[300 52 50 20],'Horiz','left');

H.Button1 = uicontrol(H.PaneControl,'style','push',...
    'string','Reset All',...
    'Units','pixel','Position',[10 550 160 25]);
H.Button2 = uicontrol(H.PaneControl,'style','push',...
    'string','Help',...
    'Units','pixel','Position',[190 550 160 25]);
H.Button3 = uicontrol(H.PaneControl,'style','push',...
    'string','Auto-scaling',...
    'Units','pixel','Position',[10 515 160 25]);
H.Button4 = uicontrol(H.PaneControl,'style','push',...
    'string','Center to Origin',...
    'Units','pixel','Position',[190 515 160 25]);
H.Button5 = uicontrol(H.PaneControl,'style','push',...
    'string','Snap to Mesh',...
    'Units','pixel','Position',[10 480 160 25]);
H.Button6 = uicontrol(H.PaneControl,'style','push',...
    'string','Done',...
    'Units','pixel','Position',[190 480 160 25]);

%% Callbacks for most GUI components;
set(H.SliderRotX,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerRotX,H.Fig});
set(H.SpinnerRotX,...
    'StateChangedCallback',{@localTransformCall,H.SliderRotX,H.Fig});
set(H.SliderRotY,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerRotY,H.Fig});
set(H.SpinnerRotY,...
    'StateChangedCallback',{@localTransformCall,H.SliderRotY,H.Fig});
set(H.SliderRotZ,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerRotZ,H.Fig});
set(H.SpinnerRotZ,...
    'StateChangedCallback',{@localTransformCall,H.SliderRotZ,H.Fig});

set(H.SliderShiftX,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerShiftX,H.Fig});
set(H.SpinnerShiftX,...
    'StateChangedCallback',{@localTransformCall,H.SliderShiftX,H.Fig});
set(H.SliderShiftY,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerShiftY,H.Fig});
set(H.SpinnerShiftY,...
    'StateChangedCallback',{@localTransformCall,H.SliderShiftY,H.Fig});
set(H.SliderShiftZ,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerShiftZ,H.Fig});
set(H.SpinnerShiftZ,...
    'StateChangedCallback',{@localTransformCall,H.SliderShiftZ,H.Fig});

set(H.SliderScale,...
    'StateChangedCallback',{@localTransformCall,H.SpinnerScale,H.Fig});
set(H.SpinnerScale,...
    'StateChangedCallback',{@localTransformCall,H.SliderScale,H.Fig});

set(H.Button1,'Callback',{@localResetCall,H.Fig});
set(H.Button2,'Callback',{@localHelpCall});
set(H.Button3,'Callback',{@localAutoScalingCall,H.Fig});
set(H.Button4,'Callback',{@localAlignCenterCall,H.Fig});
set(H.Button5,'Callback',{@localMeshSnapCall,H.Fig});
set(H.Button6,'Callback',{@localExportCall,H.Fig});

%% Setting up the scenario;
set(H.Axes,'color','k','nextplot','add');

H.IsElectrode = isfield(E,'Coordinate');

if H.IsElectrode    
    H.Fiducial = ssldrawelectrode(E.Fiducial,'markersize',8,...
        'markerfacecolor',[.3 .8 .4],'markeredgecolor',[.9 .9 .7]);
    H.Electrode = ssldrawelectrode(E.Coordinate);
    H.X = [E.Coordinate.';ones(1,size(E.Coordinate,1))];
    H.XC = [E.Fiducial.';ones(1,size(E.Fiducial,1))];
else
    H.Electrode = ssldrawmesh(E);
    set(H.Electrode,'facecolor',[.9 .4 .4],...
        'facealpha',0.35,'edgecolor','none');
    H.X = [E.Vertex.';ones(1,size(E.Vertex,1))];
    H.XC = [];
    set(H.Button5,'visible','off','enable','off');
end

H.Mesh = ssldrawmesh(M);
set(H.Mesh,'facealpha',0.35,'edgecolor','none');

H.Tr1 = eye(4); % transformation from GUI;
H.Tr2 = eye(4); % transformation from auto-scale and centering;

H.X0 = H.X; % A copy, for reset usage;
H.XC0 = H.XC;
H.ShiftLim = abs(max(max(M.Vertex)-min(M.Vertex)));

H.Axes3DFrame = ssldraw3dframe(H.Axes,H.PaneCanvas);

setappdata(H.Fig,'H',H);
rotate3d(H.Axes);

set(H.Fig,'visible','on');

X = [];
uiwait(H.Fig);
try
    X = E;    
    H = getappdata(H.Fig,'H');
    if H.IsElectrode
        X.Coordinate = [get(H.Electrode,'XData');...
            get(H.Electrode,'YData');get(H.Electrode,'ZData')].';
        
        if ~isempty(H.Fiducial)
            X.Fiducial = [get(H.Fiducial,'XData');...
                get(H.Fiducial,'YData');get(H.Fiducial,'ZData')].';
        else
            X.Fiducial = nan(4,3);
        end
    else
        X.Vertex = get(H.Electrode,'vertices');
    end
    X.SpatialTransform = H.Tr1*H.Tr2;
    close(H.Fig,'force');
catch %#ok<CTCH>
end

end % SSLALIGNTOOL;

function localTransformCall(hSrce,~,hConj,hBase)
%LOCALTRANSFORMCALL Callback for world transform events.
H = getappdata(hBase,'H');

set(hConj,'Value',get(hSrce,'Value'));

vRotX = get(H.SpinnerRotX,'Value');
if vRotX < -180, vRotX = -180; end
if vRotX > 180, vRotX = 180; end
set(H.SpinnerRotX,'Value',vRotX);
set(H.SliderRotX,'Value',vRotX);

vRotY = get(H.SpinnerRotY,'Value');
if vRotY < -180, vRotY = -180; end
if vRotY > 180, vRotY = 180; end
set(H.SpinnerRotY,'Value',vRotY);
set(H.SliderRotY,'Value',vRotY);

vRotZ = get(H.SpinnerRotZ,'Value');
if vRotZ < -180, vRotZ = -180; end
if vRotZ > 180, vRotZ = 180; end
set(H.SpinnerRotZ,'Value',vRotZ);
set(H.SliderRotZ,'Value',vRotZ);

vShiftX = get(H.SpinnerShiftX,'Value');
if vShiftX < -100, vShiftX = -100; end
if vShiftX > 100, vShiftX = 100; end
set(H.SpinnerShiftX,'Value',vShiftX);
set(H.SliderShiftX,'Value',vShiftX);

vShiftY = get(H.SpinnerShiftY,'Value');
if vShiftY < -100, vShiftY = -100; end
if vShiftY > 100, vShiftY = 100; end
set(H.SpinnerShiftY,'Value',vShiftY);
set(H.SliderShiftY,'Value',vShiftY);

vShiftZ = get(H.SpinnerShiftZ,'Value');
if vShiftZ < -100, vShiftZ = -100; end
if vShiftZ > 100, vShiftZ = 100; end
set(H.SpinnerShiftZ,'Value',vShiftZ);
set(H.SliderShiftZ,'Value',vShiftZ);

vScale = get(H.SpinnerScale,'Value');
if vScale < 1, vScale = 1; end
if vScale > 200, vScale = 200; end
set(H.SpinnerScale,'Value',vScale);
set(H.SliderScale,'Value',vScale);

H.Tr1 = makehgtform('translate',...
    [vShiftX,vShiftY,vShiftZ].*H.ShiftLim./100,...
    'xrotate',vRotX.*pi./180,...
    'yrotate',vRotY.*pi./180,...
    'zrotate',vRotZ.*pi./180,...
    'scale',vScale./100);
e = H.Tr1*H.Tr2*H.X;

if H.IsElectrode 
    set(H.Electrode,'XData',e(1,:),'YData',e(2,:),'ZData',e(3,:));
    
    ec = H.Tr1*H.Tr2*H.XC;
    set(H.Fiducial,'XData',ec(1,:),'YData',ec(2,:),'ZData',ec(3,:));
else
    set(H.Electrode,'Vertices',e(1:3,:).');
end
setappdata(hBase,'H',H);

end % LOCALTRANSFORMCALL;

function localResetCall(~,~,hBase)
%LOCALRESETCALL Reset transformations.
H = getappdata(hBase,'H');
localResetRoutine(H);

if H.IsElectrode 
    set(H.Electrode,'XData',H.X0(1,:),'YData',H.X0(2,:),'ZData',H.X0(3,:));
    set(H.Fiducial,'XData',H.XC0(1,:),'YData',H.XC0(2,:),'ZData',H.XC0(3,:));
else
    set(H.Electrode,'vertices',H.X0(1:3,:).');
end

H.X = H.X0;
H.XC = H.XC0;
H.Tr1 = eye(4);
H.Tr2 = eye(4);
setappdata(hBase,'H',H);
end % LOCALRESETCALL;

function localResetRoutine(H)
%LOCALRESETROUTINE;
set(H.SpinnerRotX,'Value',0);
set(H.SliderRotX,'Value',0);
set(H.SpinnerRotY,'Value',0);
set(H.SliderRotY,'Value',0);
set(H.SpinnerRotZ,'Value',0);
set(H.SliderRotZ,'Value',0);
set(H.SpinnerShiftX,'Value',0);
set(H.SliderShiftX,'Value',0);
set(H.SpinnerShiftY,'Value',0);
set(H.SliderShiftY,'Value',0);
set(H.SpinnerShiftZ,'Value',0);
set(H.SliderShiftZ,'Value',0);
set(H.SpinnerScale,'Value',100);
set(H.SliderScale,'Value',100);
set(H.Button3,'enable','on');
set(H.Button4,'enable','on');
end % LOCALRESETROUTINE;

function localAlignCenterCall(hSrc,~,hBase)
%LOCALALIGNCENTERCALL;
H = getappdata(hBase,'H');
if H.IsElectrode
    v = [get(H.Electrode,'XData').',...
        get(H.Electrode,'YData').',...
        get(H.Electrode,'ZData').'];    
else
    v = get(H.Electrode,'Vertices');    
end
mv = mean(v);
H.Tr2 = makehgtform('translate',-mv)*H.Tr2;
setappdata(H.Fig,'H',H);
localTransformCall([],[],[],H.Fig);
set(hSrc,'enable','off');
end % LOCALALIGNCENTERCALL;

function localMeshSnapCall(~,~,hBase)
%LOCALMESHSNAPCALL;
H = getappdata(hBase,'H');
e = [get(H.Electrode,'XData').',...
    get(H.Electrode,'YData').',...
    get(H.Electrode,'ZData').'];
nE = size(e,1);
v = get(H.Mesh,'Vertices');
f = get(H.Mesh,'faces');
c = (v(f(:,1),:)+v(f(:,2),:)+v(f(:,3),:))./3; % centroid of each face;
b = ones(size(f,1),1);
whichF = zeros(nE,1);
for k = 1:nE
    [~,whichF(k)] = min(sum((c-b*e(k,:)).^2,2));
end
e = c(whichF,:).';

% localResetRoutine(H);

set(H.Electrode,'XData',e(1,:));
set(H.Electrode,'YData',e(2,:));
set(H.Electrode,'ZData',e(3,:));

% tmp = pinv(H.Tr1*H.Tr2)*[e;ones(1,nE)];
% H.X(1:3,:) = tmp(1:3,:);

set(H.Button3,'enable','off');
set(H.Button4,'enable','off');
end % LOCALMESHSNAPCALL;

function localExportCall(~,~,hBase)
%LOCALEXPORTCALL;
uiresume(hBase);
end % LOCALEXPORTCALL;

function localHelpCall(~,~)
%LOCALHELPCALL;
web([sslrootpath,filesep,'doc',filesep,'model.html']);
end % LOCALHELPCALL;

function localAutoScalingCall(hSrc,~,hBase)
H = getappdata(hBase,'H');
set(H.SliderScale,'Value',100);
v1 = get(H.Mesh,'Vertices');
v1 = bsxfun(@minus,v1,mean(v1));
if H.IsElectrode
    v2 = [get(H.Electrode,'XData').',...
        get(H.Electrode,'YData').',...
        get(H.Electrode,'ZData').'];    
else
    v2 = get(H.Electrode,'Vertices');    
end
mv2 = mean(v2);
v2 = bsxfun(@minus,v2,mv2);
r = mean(sqrt(sum(v1.^2,2)))./mean(sqrt(sum(v2.^2,2)));
if ~isfinite(r), r = 1; end
H.Tr2 = makehgtform('scale',r)*H.Tr2;
setappdata(hBase,'H',H);
localTransformCall([],[],[],H.Fig);
set(hSrc,'enable','off');
end % LOCALAUTOSCALINGCALL;











