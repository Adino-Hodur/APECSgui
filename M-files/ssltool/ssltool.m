function varargout = ssltool(D,M)
% SSLTOOL A tool for EEG surface Laplacian and topography.
%   SSLTOOL without any input arguments brings up the user interface.
%
%   SSLTOOL(D,M) will initialize the GUI with model structure M and 
%   data structure D.
%   
%   X = SSLTOOL(D,M) when an output X is specified, will not bring up the
%   GUI but directly compute the surface Laplacians and filters and then
%   output X. 

% Siyi Deng; 03-14-2011;

if nargout > 0 && ~isdeployed
    if nargin < 2
        error('SSLTOOL:Not enough inputs.'); 
    end
    D = sslimportfilter(D,'DATA');
    M.Head = sslimportfilter(M,'MESH');
    M.Electrode = sslimportfilter(M,'ELEC');    
    varargout{1} = localSslRoutine(D,M,D.ExcludeChannel);
    return;
end

H = rmfield(guihandles(openfig('SSL_GUI_MAIN.fig','new','invisible')),...
    {'text1','text2','text3','text4','text8','text9'});
set(H.Fig,'unit','pixel','Name','SSLTool :: Main',...
    'position',[200,200,292,284],'visible','off','resize','off');
H.PanelTab = uitabpanel('parent',H.Fig,...
    'Title',{'Main','Graphics','Plot & Movie'},...
    'FrameBackGroundColor',[.76 .76 .76],...
    'PanelBackgroundColor',[.94 .94 .94],...
    'TitleForegroundColor',[0 0 0],...
    'TitleHighlightColor',[1 1 1]);
H.Tab = getappdata(H.PanelTab ,'panels');
set(H.Panel2,'parent',H.Tab(2),'unit','norm','position',[0 0 1 1]);
set(H.Panel3,'parent',H.Tab(3),'unit','norm','position',[0 0 1 1]);
set(H.Panel1,'parent',H.Tab(1),'unit','norm','position',[0 0 1 1]);

tmp = get(H.PanelTab,'children');
H.TabBase(3) = findobj(tmp,'Tag','TabBase03');
H.TabBase(2) = findobj(tmp,'Tag','TabBase02');
H.TabBase(1) = findobj(tmp,'Tag','TabBase01');
set(H.TabBase(2:3),'hittest','off');

H.JavaCompatible = ~verLessThan('matlab','7.11');

if H.JavaCompatible
    H.SliderAlpha = jcontrol(H.Panel2,'javax.swing.JSlider',...
        'Units','Pixel','Position',[175 30 50 200],...
        'Maximum',100,'Minimum',0,'value',80,'orientation',1,...
        'MajorTickSpacing',25,'MinorTickSpacing',5,...
        'PaintLabels',true,'PaintTicks',true,...
        'StateChangedCallback',{@localSliderAlphaCall,H.Fig});
else
    H.SliderAlpha = uicontrol(H.Panel2,'style','slider',...
        'Units','Pixel','Position',[185 30 15 200],...
        'Max',100,'Min',0,'value',80,...
        'callback',{@localSliderAlphaCall,H.Fig});
end

if H.JavaCompatible
    H.SliderCut = jcontrol(H.Panel2,'javax.swing.JSlider',...
        'Units','Pixel','Position',[230 30 50 200],...
        'Maximum',100,'Minimum',-100,'value',0,'orientation',1,...
        'MajorTickSpacing',50,'MinorTickSpacing',10,...
        'PaintLabels',true,'PaintTicks',true,...
        'StateChangedCallback',{@localSliderCutCall,H.Fig});  
else
    H.SliderCut = uicontrol(H.Panel2,'style','slider',...
        'Units','Pixel','Position',[240 30 15 200],...
        'Max',100,'Min',-100,'value',0,...
        'callback',{@localSliderCutCall,H.Fig});
end

if H.JavaCompatible
    H.SpinnerFrame = jcontrol(H.Panel3,'javax.swing.JSpinner',...
        'Units','pixel','Position',[80 218 70 21],'value',1,...
        'StateChangedCallback',{@localSpinnerFrameCall,H.Fig});
else
    H.SpinnerFrame = uicontrol(H.Panel3,'Style','Edit',...
        'Units','pixel','Position',[80 218 70 21],'string',1,...
        'value',1,'Callback',{@localSpinnerFrameCall,H.Fig});
end

H.ImgColormap = imagesc(linspace(0,1,40),'parent',H.AxesColormap);
axis(H.AxesColormap,'off');
colormap(H.AxesColormap,jet(40));

A = sslcanvas3d(1);
set(A.Fig,'unit','pixel','position',[520,200,520,520],...
    'name','SSLTool :: Plot Canvas');
H.FigCanvas = A.Fig;
H.AxesCanvas = A.Axes;
set(H.FigCanvas,'color','k');
colormap(H.AxesCanvas,[[.6 .75 .9];jet(80)]);
H.Axes3DFrame = ssldraw3dframe(H.AxesCanvas);

Icon = load('SSL_GUI_ICON.mat');
set(H.ButtonP1,'backgroundc',[.9 .9 .9],'CData',Icon.Data(:,:,:,1),...
    'Callback',{@localMoviePlayCall,H.Fig,Icon.Data(:,:,:,1),...
    Icon.Data(:,:,:,2)});
set(H.ButtonP2,'backgroundc',[.9 .9 .9],'CData',Icon.Data(:,:,:,4));
set(H.ButtonP3,'backgroundc',[.9 .9 .9],'CData',Icon.Data(:,:,:,3));
set(H.ButtonP4,'backgroundc',[.9 .9 .9],'CData',Icon.Data(:,:,:,5),...
    'Callback',{@localMovieResetCall,H.SpinnerFrame});
set(H.ButtonP5,'backgroundc',[.9 .9 .9],'CData',Icon.Data(:,:,:,6),...
    'Callback',{@localMovieLimCall,H.Fig,H.AxesCanvas});

set(H.Panel1,'visible','on');
set(H.Fig,'visible','on');
set(H.FigCanvas,'visible','on');

set(H.PanelRenderer,'SelectionChangeFcn',...
    {@localRendererChangeCall,H.FigCanvas});

chk = [H.Check1,H.Check2,H.Check3,H.Check4];
set(chk,'Callback',...
    {@localDrawItemChangeCall,chk,H.Fig});

set(H.Pop1,'callback',{@localPopColormapCall,...
    H.AxesColormap,H.AxesCanvas});
set(H.ToggleCanvas,'callback',{@localToggleCanvasCall,H.FigCanvas});
set(H.FigCanvas,'CloseRequestFcn',...
    {@localFigCanvasCloseReqCall,H.ToggleCanvas});
set(H.Fig,'CloseRequestFcn',{@localFigCloseReqCall,H.FigCanvas});
set(H.EditExclude,'callback',{@localEditExcludeCall,H.Fig});

set(H.Button11,'callback',{@localLoadModelCall,H.Fig});
set(H.Button12,'callback',{@localLoadDataCall,H.Fig});
set(H.Button13,'callback',{@localMakeModelCall,H.Fig});
set(H.Button14,'callback',{@localExportCall,H.Fig});
set(H.Button15,'callback',{@localHelpCall});
set(H.Button31,'callback',{@localPlotTopoCall,H.Fig,false});
set(H.Button32,'callback',{@localPlotGeoCall,H.Fig,false});
set(H.Button33,'callback',{@localPlotSphCall,H.Fig,false});
set(H.Button34,'callback',{@localFixColorbarCall,H.Fig,H.FigCanvas});

setappdata(H.Fig,'H',H);
setappdata(H.Fig,'mCurrent',[]);
setappdata(H.Fig,'mTopo',[]);
setappdata(H.Fig,'mGeo',[]);
setappdata(H.Fig,'mSph',[]);
setappdata(H.Fig,'colorLim',zeros(3,2));

if ~ispc
    set(findobj(H.Fig,'-property','fontname'),...
        'fontname','Arial','fontsize',8);
end

if nargin < 2 || isempty(M), M = []; end
if nargin < 1 || isempty(D), D = []; end

if ~isempty(M)
    M.Head = sslimportfilter(M,'MESH');
    M.Electrode = sslimportfilter(M,'ELEC');
    localDrawModelRoutine(M,H);
end

if ~isempty(D)
    D = sslimportfilter(D,'DATA');
    D = ssldatapreprocessing(D);
end

setappdata(H.Fig,'M',M);
setappdata(H.Fig,'D',D);
localPlotTopoCall([],[],H.Fig,true);
localInfoUdate(H.Fig);

end % SSLTOOL;

function localInfoUdate(hFig)
H = getappdata(hFig,'H');
M = getappdata(hFig,'M');
D = getappdata(hFig,'D');
k = getappdata(hFig,'mCurrent');
mList = {'Topo','SSLGeo','SSLSph'};
if isempty(M)
    s1 = 'empty'; 
else
    s1 = sprintf('%d vertices',size(M.Head.Vertex,1)); 
end
if isempty(M)
    s2 = 'empty'; 
else
    s2 = sprintf('%d channels',size(M.Electrode.Coordinate,1)); 
end
if isempty(D)
    s3 = 'empty'; 
else
    s3 = sprintf('%d channels',size(D.Data,2));  
end
if isempty(k), s4 = 'empty'; else s4 = mList{k}; end
s0 = ['SSLTool v%s \n \nHEAD \n    (%s) \n \nELECTRODE \n',...
    '    (%s) \n \nDATA \n    (%s) \n ',...
    '\nPLOT \n    (%s) '];
set(H.Info,'string',sprintf(s0,sslversion,s1,s2,s3,s4));
end % LOCALINFOUDATE;

function localLoadModelCall(~,~,hFig)
currentPath = pwd;
cd([sslrootpath,filesep,'data']);
[theFile,thePath] = uigetfile('*.mat','Pick a SSLTool Model File',...
    'SSL_MODEL_DEFAULT.mat');

if all(~theFile) || all(~thePath) || isempty(theFile) || isempty(thePath)
    cd(currentPath);
    return; 
end

try
    M = load(fullfile(thePath,theFile));
    if ~sslismodel(M)
        ssldialog('Warning','Invalid model file.');
        cd(currentPath);
        return;        
    end
catch Me
    disp(Me.message);
    return;
end

H = getappdata(hFig,'H');
localDrawModelRoutine(M,H);
setappdata(H.Fig,'M',M);
localInfoUdate(H.Fig);
cd(currentPath);
D = getappdata(hFig,'D');
if ~isempty(D)
    localPlotTopoCall([],[],hFig,true);

    X = localSslRoutine(D,M,D.ExcludeChannel);    
    set(H.Panel3,'visible','on');
    set(H.TabBase(3),'hittest','on'); 
    if isempty(X), return; end
    setappdata(hFig,'colorLim',[min(D.Data(:)),max(D.Data(:));...
        min(X.Geo(:)),max(X.Geo(:));min(X.Sph(:)),max(X.Sph(:))]);     
end
end % LOCALLOADMODELCALL;

function localDrawModelRoutine(M,H)
if isempty(M) || isempty(H)
    error('SSLTOOL:Draw model routine error.');
end
set(H.AxesCanvas,'nextplot','add');
H.Fiducial = ssldrawelectrode(M.Electrode.Fiducial,...
    'parent',H.AxesCanvas,'markerfacecolor',[.3 .8 .4],...
    'markeredgecolor',[.9 .9 .7],'markersize',8);
H.Electrode = ssldrawelectrode(M.Electrode.Coordinate,...
    'parent',H.AxesCanvas);
H.ElectrodeLabel = text(M.Electrode.Coordinate(:,1)*1.05,...
    M.Electrode.Coordinate(:,2)*1.05,...
    M.Electrode.Coordinate(:,3)*1.05,...
    char(M.Electrode.Label),'color','w',...
    'parent',H.AxesCanvas,'visible','off');
H.FiducialLabel = text(M.Electrode.Fiducial(:,1)*1.05,...
    M.Electrode.Fiducial(:,2)*1.05,...
    M.Electrode.Fiducial(:,3)*1.05,...
    {'LPA','RPA','NAS','VER'},'color','g',...
    'parent',H.AxesCanvas,'visible','off');
H.Head = ssldrawmesh(M.Head,...
    'facealpha',0.8,'edgecolor','none','parent',H.AxesCanvas);
x = max(abs(get(H.AxesCanvas,'XLim')));
y = max(abs(get(H.AxesCanvas,'YLim')));
H.CutPlane = patch('parent',H.AxesCanvas,'faces',[1 2 3 4],...
    'vertices',[x,y,0;x,-y,0;-x,-y,0;-x,y,0],...
    'facealpha',0.3,'edgecolor','none','facecolor',[.6 .6 .6]);
H.CutLim = max(abs([max(M.Head.Vertex(:,3)),min(M.Head.Vertex(:,3))]));
H.CutPart = M.Head.Vertex(:,3) > get(H.SliderCut,'Value')./100.*H.CutLim;
rotate3d(H.AxesCanvas);
H.NumChannel = size(M.Electrode.Coordinate,1);
% caxis(H.AxesCanvas,[0 80]);
set(H.Button11,'enable','off');
set(H.Button13,'enable','off');
set(H.Panel2,'visible','on');
set(H.TabBase(2),'hittest','on');
setappdata(H.Fig,'H',H);
end % LOCALDRAWMODELROUTINE;

function localLoadDataCall(~,~,hFig)
H = getappdata(hFig,'H');
D = ssldataimport;
if isempty(D), return; end
if ~sslisdata(D)
    ssldialog('Warning','Invalid data file.');
end
D = ssldatapreprocessing(D);
if ~isfield(D,'ExcludeChannel') || isempty(D.ExcludeChannel)
    D.ExcludeChannel = [];
    s = 'none';
else
    s = num2str(D.ExcludeChannel(:).');
end
setappdata(hFig,'D',D);
set(H.EditExclude,'string',s);
localInfoUdate(hFig);
setappdata(hFig,'mCurrent',[]);
setappdata(hFig,'mTopo',[]);
setappdata(hFig,'mGeo',[]);
setappdata(hFig,'mSph',[]);

M = getappdata(hFig,'M');
if ~isempty(M)
    localPlotTopoCall([],[],hFig,true);

    X = localSslRoutine(D,M,D.ExcludeChannel);
    if isempty(X), return; end
    setappdata(hFig,'colorLim',[min(D.Data(:)),max(D.Data(:));...
    	min(X.Geo(:)),max(X.Geo(:));min(X.Sph(:)),max(X.Sph(:))]);
    set(H.Panel3,'visible','on');
    set(H.TabBase(3),'hittest','on');    
end
end % LOCALLOADDATACALL;

function localExportCall(~,~,hFig)
D = getappdata(hFig,'D');
M = getappdata(hFig,'M');
H = getappdata(hFig,'H');
if isempty(D) || isempty(M), return; end
i = localParseEditInput(H.EditExclude);
if any(i == 0) || any(i > H.NumChannel), return; end
assignin('base','SslToolExported',localSslRoutine(D,M,i));
ssldialog('Export','Exported to workspace variable SslToolExported');
end % LOCALEXPORTCALL;

function X = localSslRoutine(D,M,i)
nc = size(M.Electrode.Coordinate,1);
if nc ~= size(D.Data,2)
    X = [];
    ssldialog('Something is wrong',...
        'Data and model dimension mismatch.','','normal');
    return;
    % error('SSLTOOL:Dimension mismatch.');
end
c = M.Electrode.Coordinate;
c(i,:) = [];
d = D.Data;
d(:,i) = [];
X.SphFilter = sslsph(c,M.Electrode.Coordinate,[]).';
X.Sph = d*X.SphFilter;
v = M.Head.Vertex;
f = M.Head.Face;
vn = M.Head.VertexNormal;
vj = M.Head.VertexNormalJacobian;
g = (v(f(:,1),:)+v(f(:,2),:)+v(f(:,3),:))./3;
b = ones(size(f,1),1);
j = zeros(nc,1);
for k = 1:nc
    [~,j(k)] = min(sum((g-b*M.Electrode.Coordinate(k,:)).^2,2));
end
c = g(j,:);
c(i,:) = [];
vn = (vn(f(j,1),:)+vn(f(j,2),:)+vn(f(j,3),:))./3;
vj = (vj(:,:,f(j,1))+vj(:,:,f(j,2))+vj(:,:,f(j,3)))./3;
X.GeoFilter = sslgeo(c,M.Electrode.Coordinate,[],vn,vj).';
X.Geo = d*X.GeoFilter;
end % LOCALSSLROUTINE;

function localPlotTopoCall(~,~,hFig,isForceUpdate)
D = getappdata(hFig,'D');
M = getappdata(hFig,'M');
H = getappdata(hFig,'H');
if isempty(D) || isempty(M), return; end
if size(D.Data,2) ~= size(M.Electrode.Coordinate,1)
	ssldialog('Warning',...
    'Size of Data and Electrode mismatch. Import data again.');    
    setappdata(hFig,'D',[]);
    return;
end
m = getappdata(hFig,'mTopo');
if isempty(m) || isForceUpdate
    i = localParseEditInput(H.EditExclude);
    if any(i == 0) || any(i > H.NumChannel), return; end
    c = M.Electrode.Coordinate;
    c(i,:) = [];
    m = sslphs(c,M.Head.Vertex);
    setappdata(hFig,'mTopo',m);    
end
setappdata(hFig,'mCurrent',1);
localMovieLimCall(H.ButtonP5,[],H.Fig,H.AxesCanvas);
localPlotRoutine(hFig,1);
localInfoUdate(hFig);

set(H.Panel2,'visible','on');
set(H.TabBase(2),'hittest','on');
set(H.Panel3,'visible','on');
set(H.TabBase(3),'hittest','on');    
end % LOCALPLOTTOPOCALL;

function localPlotGeoCall(~,~,hFig,isForceUpdate)
D = getappdata(hFig,'D');
M = getappdata(hFig,'M');
H = getappdata(hFig,'H');
if isempty(D) || isempty(M), return; end
m = getappdata(hFig,'mGeo');
if isempty(m) || isForceUpdate
    i = localParseEditInput(H.EditExclude);
    if any(i == 0) || any(i > H.NumChannel), return; end
    c = M.Electrode.Coordinate;
    c(i,:) = [];    
    m = sslgeo(c,M.Head.Vertex,[],...
        M.Head.VertexNormal,M.Head.VertexNormalJacobian);
    setappdata(hFig,'mGeo',m);    
end
setappdata(hFig,'mCurrent',2);
localMovieLimCall(H.ButtonP5,[],H.Fig,H.AxesCanvas);
localPlotRoutine(hFig,2);
localInfoUdate(hFig);
end % LOCALPLOTGEOCALL;
 
function localPlotSphCall(~,~,hFig,isForceUpdate)
D = getappdata(hFig,'D');
M = getappdata(hFig,'M');
H = getappdata(hFig,'H');
if isempty(D) || isempty(M), return; end
m = getappdata(hFig,'mSph');
if isempty(m) || isForceUpdate
    i = localParseEditInput(H.EditExclude);
    if any(i == 0) || any(i > H.NumChannel), return; end
    c = M.Electrode.Coordinate;
    c(i,:) = [];
    m = sslsph(c,M.Head.Vertex,[]);
    setappdata(hFig,'mSph',m);    
end
setappdata(hFig,'mCurrent',3);
localMovieLimCall(H.ButtonP5,[],H.Fig,H.AxesCanvas);
localPlotRoutine(hFig,3);
localInfoUdate(hFig);
end % LOCALPLOTSPHCALL;

function localPlotRoutine(hFig,k)
D = getappdata(hFig,'D');
H = getappdata(hFig,'H');
if isempty(D), return; end
if isempty(k), return; end
if(size(D.Data,2) ~= H.NumChannel)
    ssldialog('Warning',...
    'Size of Data and Electrode mismatch. Import data again.');
    setappdata(hFig,'D',[]);
    return;
    % error('SSLTOOL:Dimension mismatch');    
end

if H.JavaCompatible
    theFrame = get(H.SpinnerFrame,'value');
else
    theFrame = localParseEditInput(H.SpinnerFrame);
    if isempty(theFrame), theFrame = 1; end
end
if theFrame > D.NumFrame
    theFrame = D.NumFrame;
    if H.JavaCompatible
        set(H.SpinnerFrame,'value',D.NumFrame);
    else
        set(H.SpinnerFrame,'string',num2str(D.NumFrame));
    end
end
if theFrame < 1
    theFrame = 1;
    if H.JavaCompatible
        set(H.SpinnerFrame,'value',1);
    else
        set(H.SpinnerFrame,'string','1');
    end
end
mList = {'mTopo','mGeo','mSph'};
u = D.Data(theFrame,:).';
u(localParseEditInput(H.EditExclude)) = [];
v = getappdata(hFig,mList{k})*u;
x = H.CutPart;
cMin = min(v(x));
cMax = max(v(x));
% set(H.TextColorMin,'string',sprintf('%0.2e',cMin));
% set(H.TextColorMax,'string',sprintf('%0.2e ',cMax));
if get(H.ButtonP5,'value')
    v(~x) = -inf;
else
    v(~x) = cMin-(cMax-cMin)./79;    
end
set(H.Head,'facevertexcdata',v,...
    'facecolor','interp','FaceLighting','none');
end % LOCALPLOTROUTINE;

function localPopColormapCall(hSrc,~,hTarget1,hTarget2)
switch get(hSrc,'Value')
    case 1
        c = jet(80);
    case 2
        c = hot(80);
    case 3
        c = gray(80);
    case 4
        c = hsv(80);
end
colormap(hTarget1,c);
colormap(hTarget2,[[.6 .75 .9];c]);
end % LOCALPOPCOLORMAPCALL;

function localToggleCanvasCall(hSrc,~,hTarget)
if get(hSrc,'Value') == 1
    set(hSrc,'String','Hide Canvas');
    set(hTarget,'visible','on');
else
    set(hSrc,'String','Show Canvas');
    set(hTarget,'visible','off');
end
end % LOCALTOGGLECANVASCALL;

function localFigCanvasCloseReqCall(hSrc,~,hTarget)
set(hTarget,'value',0,'string','Show Canvas');
set(hSrc,'visible','off');
end % LOCALFIGCANVASCLOSEREQCALL;

function localFigCloseReqCall(~,~,hTarget)
closereq;
close(hTarget,'force');
end % LOCALFIGCLOSEREQCALL;

function localSliderAlphaCall(hSrc,~,hFig)
H = getappdata(hFig,'H');
set(H.Head,'facealpha',get(hSrc,'Value')./100);
end % LOCALSLIDERALPHACALL;

function localSliderCutCall(hSrc,~,hFig)
H = getappdata(hFig,'H');
M = getappdata(hFig,'M');
m = getappdata(hFig,'mCurrent');
v = get(H.CutPlane,'vertices');
v(:,3) = (get(hSrc,'Value')./100).*H.CutLim;
set(H.CutPlane,'vertices',v);
H.CutPart = M.Head.Vertex(:,3) > get(H.SliderCut,'Value')./100.*H.CutLim;
setappdata(hFig,'H',H);
localPlotRoutine(hFig,m);
end % LOCALSLIDERCUTCALL;

function localSpinnerFrameCall(~,~,hFig)
m = getappdata(hFig,'mCurrent');
localPlotRoutine(hFig,m);
end % LOCALSPINNERFRAMECALL;

function localRendererChangeCall(~,Event,hFigCanvas)
switch get(Event.NewValue,'Tag')
    case 'Radio1'
        set(hFigCanvas,'renderer','OpenGl');
    case 'Radio2'
        set(hFigCanvas,'renderer','ZBuffer');
end
end % LOCALRENDERERCHANGECALL;

function localDrawItemChangeCall(~,~,hChk,hFig)
H = getappdata(hFig,'H');
v = get(hChk,'value');
onOff = {'off','on'};
set(H.Head,'visible',onOff{v{1}+1});
set(H.CutPlane,'visible',onOff{v{2}+1});
set(H.Electrode,'visible',onOff{v{3}+1});
set(H.Fiducial,'visible',onOff{v{3}+1});
set(H.ElectrodeLabel,'visible',onOff{v{4}+1});
set(H.FiducialLabel,'visible',onOff{v{4}+1});
end % LOCALDRAWITEMCHANGECALL;

function localMoviePlayCall(hSrc,~,hFig,iconPlay,iconPause)
D = getappdata(hFig,'D');
M = getappdata(hFig,'M');
H = getappdata(hFig,'H');
if isempty(D) || isempty(M), return; end
if get(hSrc,'value')
    set(hSrc,'CData',iconPause);
else
    set(hSrc,'CData',iconPlay);
end
localMovieRoutine(H.SpinnerFrame,H.ButtonP1,H.ButtonP2,H.ButtonP3,...
    H.Fig,H.FigCanvas,size(D.Data,1),iconPlay,H.JavaCompatible);
end % LOCALMOVIEPLAYCALL;

function localMovieResetCall(~,~,hFrame)
set(hFrame,'value',1);
end % LOCALMOVIERESETCALL;

function localMovieLimCall(hSrc,~,hFig,hAxesCanvas)
if get(hSrc,'value')    
    c = getappdata(hFig,'colorLim');
    set(hAxesCanvas,'CLimMode','manual',...
        'CLim',c(getappdata(hFig,'mCurrent'),:))
else
    set(hAxesCanvas,'CLimMode','auto')
end
end % LOCALMOVIELIMCALL;

function localMovieRoutine(hFrame,hPlay,hFast,hRep,hFig,hFigCanvas,...
    iMax,iconPlay,isJavaComp)
set(hFig,'CloseRequestFcn',[]);
if isJavaComp
    while get(hPlay,'value')
        i = get(hFrame,'value');
        if  i >= iMax
            if get(hRep,'value')
                set(hFrame,'value',1);                
                drawnow;
                pause(0.002+(1-get(hFast,'value')).*0.058);            
            else   
                set(hPlay,'value',0);
                set(hPlay,'CData',iconPlay);
                break;
            end
        else
            set(hFrame,'value',i+1);
            drawnow;
            pause(0.002+(1-get(hFast,'value')).*0.058);        
        end
    end
else
    while get(hPlay,'value')
        i = localParseEditInput(hFrame);
        if isempty(i), return; end
        if  i >= iMax
            if get(hRep,'value')
                set(hFrame,'string','1');
                localSpinnerFrameCall([],[],hFig);
                drawnow;
                pause(0.002+(1-get(hFast,'value')).*0.058);            
            else   
                set(hPlay,'value',0);
                set(hPlay,'CData',iconPlay);
                break;
            end
        else
            set(hFrame,'string',num2str(i+1));
            localSpinnerFrameCall([],[],hFig);
            drawnow;
            pause(0.002+(1-get(hFast,'value')).*0.058);        
        end
    end
end
set(hFig,'CloseRequestFcn',{@localFigCloseReqCall,hFigCanvas});
end % LOCALMOVIEROUTINE;

function localMakeModelCall(~,~,hFig)
H = getappdata(hFig,'H');
set(H.Fig,'visible','off')
set(H.FigCanvas,'visible','off')
set(H.ToggleCanvas,'String','Show Canvas','value',0);
currentPath = pwd;
cd([sslrootpath,filesep,'data']);
load('SSL_MODEL_DEFAULT.mat','Head');

x = ssldialog('STEP 1: Import the head mesh.',...
    {'Import a triangular mesh of the head.'},...
    [sslrootpath,filesep,'doc',filesep,'format.html#head']);
if ~x, nestEnableUiRoutine(H); cd(currentPath); return; end

T = sslmeshimport;

if isempty(T) || ~sslmeshqualitycheck(T)
    ssldialog('Warning','Invalid or empty mesh, process aborted.',[]);
    nestEnableUiRoutine(H);
    cd(currentPath);
    return;
end

x = ssldialog('STEP 2: Align the imported mesh.',...
    {'Make the imported mesh (red) and the reference mesh (blue)',...
    'align with each other as close as possible.'},...
    [sslrootpath,filesep,'doc',filesep,'alignmesh.html']);
if ~x, nestEnableUiRoutine(H); cd(currentPath); return; end

Head = sslaligntool(Head,T); %#ok<NODEF>

x = ssldialog('STEP 3: Import electrode coordinates',...
    {'Import electrode 3D-coordinates.'},...
    [sslrootpath,filesep,'doc',filesep,'format.html#electrode']);
if ~x, nestEnableUiRoutine(H); cd(currentPath); return; end

E = sslelectrodeimport;

if isempty(E) || ~sslelectrodequalitycheck(E)
    ssldialog('Warning',...
        'Invalid or empty electrode data, process aborted.',...
        []);
    nestEnableUiRoutine(H);
    cd(currentPath);
    return;
end

x = ssldialog('STEP 4: Align electrode and mesh',...
    {'Make the imported electrode align with the imported mesh.',...
    'use ''Snap to mesh'' to improve the align quality.'},...
    [sslrootpath,filesep,'doc',filesep,'alignelec.html']);
if ~x, nestEnableUiRoutine(H); cd(currentPath); return; end

Electrode = sslaligntool(Head,E);

x = ssldialog('STEP 5: Save the model',...
    {'Save the newly created model.'},...
    [sslrootpath,filesep,'doc',filesep,'format.html#model']);
if ~x, nestEnableUiRoutine(H); cd(currentPath); return; end

[theFile,thePath] = uiputfile('*.mat','Save the model','SSL_MODEL_CUSTOM');

if all(~theFile) || all(~thePath) || isempty(theFile) || isempty(thePath)
    fileName = fullfile([sslrootpath,filesep,'data'],'SSL_MODEL_CUSTOM');
else
    fileName = fullfile(thePath,theFile);
end

v1 = sslmeshsmooth(Head,ceil(sqrt(size(Head.Vertex,1))./3),true);
Head.VertexNormal = sslmeshvertexnormal(sslmeshstruct(v1,Head.Face));
Head.VertexNormalJacobian = sslmeshcurvature(...
    sslmeshstruct(v1,Head.Face),sslmeshvertexneighbor(Head),...
    Head.VertexNormal);

save(fileName,'Head','Electrode','-v7.3');

M.Head = Head;
M.Electrode = Electrode;

localDrawModelRoutine(M,H);

setappdata(H.Fig,'M',M);
localInfoUdate(H.Fig);
nestEnableUiRoutine(H);
cd(currentPath);
    function nestEnableUiRoutine(H)
    set(H.Fig,'visible','on')
    set(H.FigCanvas,'visible','on')
    set(H.ToggleCanvas,'String','Hide Canvas','value',1);
    end % NESTENABLEUIROUTINE;
end % LOCALMAKEMODELCALL;

function localFixColorbarCall(~,~,hFig,hTarget) %#ok<INUSL>
h = findobj(hTarget,'tag','Colorbar');
if isempty(h) || ~ishandle(h), return; end
end % LOCALFIXCOLORBARCALL;

function localEditExcludeCall(hSrc,~,hFig)
localParseEditInput(hSrc);
mCurrent = getappdata(hFig,'mCurrent');
if isempty(mCurrent), return; end
setappdata(hFig,'mGeo',[]);
setappdata(hFig,'mSph',[]);
setappdata(hFig,'mTopo',[]);
switch mCurrent
    case {1}
        localPlotTopoCall([],[],hFig,true);
    case {2}
        localPlotGeoCall([],[],hFig,true);
    case {3}
        localPlotSphCall([],[],hFig,true);
end
end % localEditExcludeCall;

function i = localParseEditInput(hSrc)
s = get(hSrc,'string');
if any(regexp(s,'[^0-9, ]')) || isempty(s)
    set(hSrc,'string','null');
    i = [];
else
    i = unique(str2num(s)); %#ok<ST2NM>
end
end % LOCALPARSEEDITINPUT;

function localHelpCall(~,~)
web([sslrootpath,filesep,'doc',filesep,'index.html']);
end % LOCALHELPCALL;










