function D = sslelectrodeimport
%SSLELECTRODEIMPORT GUI to import electrode coordinates.
%   D = SSLELECTRODEIMPORT brings up the gui, the output is stored in D.

% Siyi Deng; 03-01-2011;

H = guihandles(openfig('SSL_GUI_IMPORT.fig','reuse','invisible'));

set(H.figure1,'Name','SSLTool :: Import');
set(H.uipanel1,'Title','Import electrode data from');
set(H.radiobutton1,'string','A text file',...
    'enable','on','visible','on','value',1);
set(H.radiobutton2,'string','A workspace variable',...
    'enable','on','visible','on');
set(H.radiobutton3,'string','manually input');

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

end % SSLELECTRODEIMPORT;

function localOkCall(~,~,hBase)
H = getappdata(hBase,'H');
switch(find([get(H.radiobutton1,'value');...
    get(H.radiobutton2,'value');...
    get(H.radiobutton3,'value')]))
    case {1}
        D = localImportText;       
    case {2}
        D = localImportVar;
    case {3}
        D = localImportManual;         
end
if isempty(D), return; end
setappdata(H.figure1,'D',D);
uiresume(H.figure1);
end % LOCALOKCALL;

function D = localImportManual
D = [];
n = 'nan';
while ~(isnumeric(n) && isscalar(n) && isfinite(n) && n > 0 ...
        && n == round(n))
    x = inputdlg('Enter the number of electrodes','Electrode');
    try
        n = str2double(x);
    catch %#ok<CTCH>
        n = 'nan';
    end
end

end % LOCALIMPORTMANUAL;

function D = localImportText
D = [];
w = pwd;
cd([sslrootpath,filesep,'data']);

S = uiimport('-file');
if isempty(S)
    cd(w);
    return; 
end
D.Coordinate = S.data;
D.Label = S.textdata;

% handle fiducial points;
[tf,id] = ismember({'LPA';'RPA';'NAS';'VER'},upper(D.Label));
D.Label(id(tf)) = [];
D.Fiducial = nan(4,3);
D.Fiducial(tf,:) = D.Coordinate(id(tf),:);
D.Coordinate(id(tf),:) = [];

cd(w);
end % LOCALIMPORTTEXT;

function D = localImportVar
D = [];
[v,vName] = uigetvar({'struct','double','single'});
if isempty(v) && isempty(vName), return; end
switch(class(v))
    case {'double','single'}
        D.Coordinate = v;
        n = size(v,1);        
        D.Label = cell(n,1);
        D.Fiducial = nan(4,3);
        for k = 1:n
            D.Label{k} = num2str(k);
        end
    case {'struct'}
        % D = v;
        D = sslimportfilter(v,'ELEC');
        if isempty(D), return; end
        if ~isfield(D,'Label') || isempty(D.Label)
            n = size(D.Coordinate,1); 
            for k = 1:n
                D.Label{k} = num2str(k);
            end
        end
        if ~isfield(D,'Fiducial')
            D.Fiducial = nan(4,3);
        end
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
web([sslrootpath,filesep,'doc',filesep,'format.html#ELEC']);
end % LOCALHELPCALL;



