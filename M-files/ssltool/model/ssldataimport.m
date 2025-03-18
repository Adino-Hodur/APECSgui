function D = ssldataimport
%SSLDATAIMPORT GUI to import data.
%   D = SSLDATAIMPORT brings up the GUI. Imported data is stored in D.

% Siyi Deng; 03-01-2011;

H = guihandles(openfig('SSL_GUI_IMPORT.fig','reuse','invisible'));

set(H.figure1,'Name','SSLTool :: Import');
set(H.uipanel1,'Title','Import data from');
set(H.radiobutton1,'string','A .mat file','enable','on',...
     'enable','on','visible','on','value',1);
set(H.radiobutton2,'string','A text file',...
     'enable','on','visible','on');
set(H.radiobutton3,'string','A workspace variable',...
     'enable','on','visible','on');

set(H.pushbutton1,'Callback',{@localOkCall,H.figure1});
set(H.pushbutton2,'Callback',{@localCancelCall,H.figure1});
set(H.pushbutton3,'Callback',{@localHelpCall});

setappdata(H.figure1,'H',H);
set(H.figure1,'visible','on');

uiwait(H.figure1);
try
    D = getappdata(H.figure1,'D');
    close(H.figure1,'force');
catch %#ok<CTCH>
    D = [];
end

end % SSLDATAIMPORT;

function localOkCall(~,~,hBase)
H = getappdata(hBase,'H');
switch(find([get(H.radiobutton1,'value');...
    get(H.radiobutton2,'value');...
    get(H.radiobutton3,'value')]))
    case {1}
        D = localImportMat;
    case {2}
        D = localImportText;
    case {3}
        D = localImportVar;
end
if isempty(D), return; end
setappdata(H.figure1,'D',D);
uiresume(H.figure1);
end % LOCALOKCALL;

function D = localImportMat
D = [];
w = pwd;
cd([sslrootpath,filesep,'data']);
[theFile,thePath] = uigetfile('*.mat','Load data',...
    'SSL_DATA_DEFAULT.mat');
if all(~theFile) || all(~thePath) || isempty(theFile) || isempty(thePath)    
    cd(w);
    return; 
end
try
    M = load(fullfile(thePath,theFile));
    f = fieldnames(M);
    D = sslimportfilter(M.(f{1}),'DATA');
catch Me
    disp(Me.message);
    cd(w);
    return;
end
cd(w);
end % LOCALIMPORTMAT;

function D = localImportText
D = [];
S = uiimport('-file');
if isempty(S), return; end
f = fieldnames(S);
D.Data = S.(f{1});
D.ExcludeChannel = [];

end % LOCALIMPORTTEXT;

function D = localImportVar
D = [];
[v,vName] = uigetvar({'struct','double','single'});
if isempty(v) && isempty(vName), return; end
switch(class(v))
    case {'double','single'}
        D.Data = v;
        D.ExcludeChannel = [];
    case {'struct'}
        % if ~isfield(v,'Data'), return; end
        % D = v;
        D = sslimportfilter(v,'DATA');
    otherwise
        error('SSLTOOL:Unknown variable class.');
end
end % LOCALIMPORTVAR;

function localCancelCall(~,~,hBase)
D = [];
setappdata(hBase,'D',D);
uiresume(hBase);
end % LOCALCANCELCALL;

function localHelpCall(~,~)
%LOCALHELPCALL;
web([sslrootpath,filesep,'doc',filesep,'format.html#DATA']);
end % LOCALHELPCALL;




