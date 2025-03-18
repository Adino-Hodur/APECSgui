function T = sslmeshimport
%SSLMESHIMPORT GUI to import several kinds of triangular mesh file.
%   T = SSLMESHIMPORT brings up the gui. The imported mesh is stored in T.

% Siyi Deng; 03-01-2011;

H = guihandles(openfig('SSL_GUI_IMPORT.fig','reuse','invisible'));

set(H.figure1,'Name','SSLTool :: Import');
set(H.uipanel1,'Title','Import triangular mesh from');
set(H.radiobutton4,'string','A Geomview .OFF file',...
    'enable','on','visible','on');
set(H.radiobutton3,'string','A BrainVoyager .SRF file',...
    'enable','on','visible','on');
set(H.radiobutton2,'string','A workspace variable',...
    'enable','on','visible','on');
set(H.radiobutton1,'string','Use default model',...
    'enable','on','visible','on','value',1);

% check if BVQX is installed;
% if exist('BVQXfile.m','file')
%     set(H.radiobutton2,'enable','on');
% end

set(H.pushbutton1,'Callback',{@localOkCall,H.figure1});
set(H.pushbutton2,'Callback',{@localCancelCall,H.figure1});
set(H.pushbutton3,'Callback',{@localHelpCall});

setappdata(H.figure1,'H',H);
set(H.figure1,'visible','on');

uiwait(H.figure1);
try
    T = getappdata(H.figure1,'T');
    close(H.figure1,'force');
catch %#ok<CTCH>
    T = [];
end

end % SSLMESHIMPORT;

function localOkCall(~,~,hBase)
H = getappdata(hBase,'H');
switch(find([get(H.radiobutton1,'value');...
    get(H.radiobutton2,'value');get(H.radiobutton3,'value');...
    get(H.radiobutton4,'value')]))
    case {4}
        T = localImportOff;
    case {3}
        T = localImportSrf;
    case {2}
        T = localImportVar;
    case {1}
        T = load('SSL_MODEL_DEFAULT','Head');
        T = T.Head;
end
if isempty(T), return; end
setappdata(H.figure1,'T',T);
uiresume(H.figure1);
end % LOCALOKCALL;

function T = localImportOff
T = [];
w = pwd;
cd([sslrootpath,filesep,'data']);
[theFile,thePath] = uigetfile('*.off','Pick a OFF file');
if all(~theFile) || all(~thePath) || isempty(theFile) || isempty(thePath)
    cd(w);
    return; 
end
try
    T = sslreadtrioff(fullfile(thePath,theFile));
catch Me
    disp(Me.message);
    cd(w);
    return;
end
cd(w);
end % LOCALIMPORTOFF;

function T = localImportSrf
T = [];
w = pwd;
cd([sslrootpath,filesep,'data']);
[theFile,thePath] = uigetfile('*.srf','Pick a PLY file');
if all(~theFile) || all(~thePath) || isempty(theFile) || isempty(thePath)
    cd(w);
    return; 
end
try
    theFullFile = fullfile(thePath,theFile);
    if exist('BVQXfile.m','file')
        B = BVQXfile(theFullFile);
        T.Face = B.TriangleVertex;
        T.Vertex = B.VertexCoordinate;
    else
        T = sslreadtrisrf(theFullFile);
    end
catch Me
    disp(Me.message);
    cd(w);
    return;
end
cd(w);
end % LOCALIMPORTSRF;

function T = localImportVar
T = [];
[V,vName] = uigetvar({'struct','BVQXfile'});
if isempty(V) && isempty(vName), return; end
T = sslimportfilter(V,'MESH');
end % LOCALIMPORTVAR;

function localCancelCall(~,~,hBase)
T = [];
setappdata(hBase,'T',T);
uiresume(hBase);
end % LOCALCANCELCALL;

function localHelpCall(~,~)
%LOCALHELPCALL;
web([sslrootpath,filesep,'doc',filesep,'format.html#HEAD']);
end % LOCALHELPCALL;


