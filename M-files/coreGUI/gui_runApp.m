function varargout = gui_runApp(varargin)
% GUI_RUNAPP MATLAB code for gui_runApp.fig
%      GUI_RUNAPP, by itself, creates a new GUI_RUNAPP or raises the existing
%      singleton*.
%
%      H = GUI_RUNAPP returns the handle to a new GUI_RUNAPP or the handle to
%      the existing singleton*.
%
%      GUI_RUNAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RUNAPP.M with the given input arguments.
%
%      GUI_RUNAPP('Property','Value',...) creates a new GUI_RUNAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_runApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_runApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_runApp

% Last Modified by GUIDE v2.5 23-Aug-2016 18:28:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_runApp_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_runApp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_runApp is made visible.
function gui_runApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_runApp (see VARARGIN)
clear global
global paramRunApp

set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.3 0.15 0.6 0.7]);  

% Choose default command line output for gui_runApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes gui_runApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_runApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadFile.
function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.loadFile,'Enable','off');
set(handles.loadParam,'Enable','off');
set(handles.pushLoadRes,'Enable','off');

% ---- begin modification ----
% added buton for plotting results
set(handles.pushPlotRes, 'Enable', 'off');
% ---- end modification ----
    
[fileName, pathName] = uigetfile ({'./Data/TrainValTest/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if fileName
    paramRunApp.fileName = fileName;
    paramRunApp.pathName = pathName;
    %%% load header file
    strF=strcat(pathName,fileName);
    warning off 
    load(strF,'header')
    warning on 
    if ~exist('header','var')
        hE=errordlg('Header not present in the file ...','Error - header missing');
        uiwait(hE);
        set(handles.loadFile,'Enable','on');
        set(handles.loadParam,'Enable','on');
        set(handles.pushLoadRes,'Enable','on');
        
        % ---- begin modification ----
        % added buton for plotting results
        set(handles.pushPlotRes, 'Enable', 'on');
        % ---- end modification ----
    else
        paramRunApp.numClass=header.numClass;
        paramRunApp.Xlabels=header.Xlabels;
        if isfield(header,'origXlabels')
            paramRunApp.origXlabels=header.origXlabels;
        end
       if isfield(header,'freqIn')
           paramRunApp.freqIn =header.freqIn; 
           paramRunApp.fLines =header.fLines;
       end  
       if isfield(header,'excludeLaplacian')
           paramRunApp.excludeLaplacian=header.excludeLaplacian;
       end
       %if isfield(header,'multiWay')
       paramRunApp.multiWay =header.multiWay;
       %end 
%        if isfield(header,'errorType')
%            paramRunApp.errorType =header.errorType;
%        end
       if isfield(header,'classLabel')
           paramRunApp.classLabel =header.classLabel;
       end
       if isfield(header,'artifactLabel')
           paramRunApp.artifactLabel =header.artifactLabel;
       end
       %%%% set file print
       handles = printfileText(handles, paramRunApp.fileName, header);
       %%%% start initial menu
       handles = fcn_setInitMenu(paramRunApp,handles);
       
       set(handles.loadFile,'Visible','off');
       set(handles.loadParam,'Visible','off');
       set(handles.pushLoadRes,'Visible','off');
       
       % ---- begin modification ----
       % added buton for plotting results
       set(handles.pushPlotRes, 'Visible', 'off');
       % ---- end modification ----
    end
else
    set(handles.loadFile,'Enable','on');
    set(handles.loadParam,'Enable','on');
    set(handles.pushLoadRes,'Enable','on');
    
    % ---- begin modification ----
    % added buton for plotting results
    set(handles.pushPlotRes, 'Enable', 'on');
    % ---- end modification ----
end

guidata(hObject,handles) 

% --- Executes on button press in loadParam.
function loadParam_Callback(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.loadFile,'Enable','off');
set(handles.loadParam,'Enable','off');
set(handles.pushLoadRes,'Enable','off');

% ---- begin modification ----
% added buton for plotting results
set(handles.pushPlotRes, 'Enable', 'off');
% ---- end modification ----

[fileName, pathName] = uigetfile ({'./ParameterFiles/*.mat'},'Open File');
pathName=getRelPath(pathName);

if fileName
    %%% load parameters
    strF=strcat(pathName,fileName);
    warning off
    s=load(strF,'paramRunApp');
    warning on
    
    if ~isfield(s,'paramRunApp')
        hE=msgbox([fileName,' is not a correct parameter''s file'],'Error - not parameter''s file','error');
        uiwait(hE);
        set(handles.loadFile,'Enable','on');
        set(handles.loadParam,'Enable','on');
        set(handles.pushLoadRes,'Enable','on');
        
        % ---- begin modification ----
        % added buton for plotting results
        set(handles.pushPlotRes, 'Enable', 'on');
        % ---- end modification ----
    else
        paramRunApp=s.paramRunApp;
        set(handles.loadParam,'Visible','off');
        set(handles.pushLoadRes,'Visible','off');
        set(handles.loadFile,'Visible','off');
        
        % ---- begin modification ----
        % added buton for plotting results
        set(handles.pushPlotRes, 'Visible', 'off');
        % ---- end modification ----
        
        %%%% reset parameters to run new file
        hNames=fieldnames(handles);
        %%%%% resetting values
        %%%% clear some properties
        for i=1:length(hNames)
            if ~((strcmp(hNames{i},'figure1')) | (strcmp(hNames{i},'File')) | ...
                    (strcmp(hNames{i},'Open')) | (strcmp(hNames{i},'output')))
                hTmp=strcat('handles.',hNames{i});
                if isprop(eval(hTmp),'Visible')
                    set(eval(hTmp),'Visible','off')
                end
                if isprop(eval(hTmp),'Value')
                    set(eval(hTmp),'Value',0)
                end
                if isprop(eval(hTmp),'UserData')
                    set(eval(hTmp),'UserData',[])
                end
            end
        end
        
        %%%% set file print
        %%%% load header
        strF=strcat(paramRunApp.pathName,paramRunApp.fileName);
        warning off
        load(strF,'header')
        warning on
        handles = printfileText(handles, paramRunApp.fileName, header);
        %%%%  menu
        set(handles.pushRunApp,'Visible','on');
        set(handles.pushSaveParam,'Visible','on');
        set(handles.pushFinish,'Visible','on');
        set(handles.pushGoBack,'Visible','on');
        set(handles.topPanel,'Visible','on');
        %%%%% print right text panel
        %%%% fcn right panel print
        handles = printRightPanel(paramRunApp, handles);
        
        if isfield(paramRunApp,'Xlabels2use') && length(paramRunApp.Xlabels2use) ~= length(paramRunApp.Xlabels)
            strR1FT(1) = {'Variables to use: '};
            nstr=[];
            for i=1:length(paramRunApp.Xlabels2use)
                nstr = [nstr,paramRunApp.Xlabels2use{i},','];
            end
            strR1FT(2)={nstr(1:end-1)};
        else
            strR1FT(1) ={'Variables to use: all'};
        end
        strR1FT(end+1)={'--------------------------------'};
        if isfield(paramRunApp,'origXlabels')
            if paramRunApp.useSelfPairs
                strR1FT(end+1)={['Self-pairs  : ','yes']};
            else
                strR1FT(end+1)={['Self-pairs  : ','no']};
            end
            if paramRunApp.useInter
                strR1FT(end+1)={['Inter-hemis: ','yes']};
            else
                strR1FT(end+1)={['Inter-hemis: ','no']};
            end
            strR1FT(end+1)={'--------------------------------'};
        end
        if isfield(paramRunApp,'plotFileName')
            strR1FT(end+1)={paramRunApp.plotFileName};
        else
            strR1FT(end+1)={'Plot m-file: no'};
        end
        set(handles.fileTextR1,'Visible','on','String',strR1FT);
    end
else
    set(handles.loadFile,'Enable','on');
    set(handles.loadParam,'Enable','on');
    set(handles.pushLoadRes,'Enable','on');
    
    % ---- begin modification ----
    % added buton for plotting results
    set(handles.pushPlotRes, 'Enable', 'on');
    % ---- end modification ----
end

guidata(hObject,handles)


% --- Executes on button press in pushOK1.
function pushOK1_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

str = get(handles.listGenMethod,'String');
pos = get(handles.listGenMethod,'Value');
paramRunApp.genMethod=str{pos};

handles = printRightPanel(paramRunApp,handles); 

set(handles.textSelMethod,'Visible','off');
set(handles.listGenMethod,'Visible','off');
set(handles.pushOK1,'Visible','off','Value',0);

set(handles.pushClass,'Visible','off','Value',0);
set(handles.pushReg,'Visible','off','Value',0);
set(handles.pushReg,'Visible','off','Value',0);
set(handles.pushReg,'Visible','off','Value',0);
set(handles.pushModel,'Visible','off','Value',0);
set(handles.checkMultiY,'Visible','off','Value',0);
set(handles.checkMultiN,'Visible','off','Value',0);
set(handles.textRunMulti,'Visible','off');
set(handles.textTaskType,'Visible','off');
set(handles.pushOK1,'Visible','off','Value',0);

%%%% set new OK2 win 
set(handles.textBinProcess,'Visible','on'); 
set(handles.listBinMeth,'Value',1); 
%set(handles.listBinMeth,'Visible','on','String',{'none','Average','GF power','GF power + Average',});
set(handles.listBinMeth,'Visible','on','String',{'none','Relative Spectra','Average','Relative Average'});
[handles] = setParamTable(handles); 

guidata(hObject,handles) 

% --- Executes on button press in pushOK2.
function pushOK2_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.pushOK2,'Visible','off','Value',0);
set(handles.tableParam,'Visible','off');
set(handles.textBinProcess,'Visible','off');
set(handles.listBinMeth,'Visible','off');
set(handles.textRangeGF,'Visible','off')
set(handles.panelRangeGF,'Visible','off')

set(handles.textDefParam,'Visible','off');
if strcmp(paramRunApp.genMethod,'KPLS')
    set(handles.panelKerFcn,'Visible','off'); 
    set(handles.panelParKF,'Visible','off'); 
    set(handles.listSelKernel,'Visible','off'); 
end 


%%%% read parameters 
    
%%%% get sel parameters (from table) 
datTab=get(handles.tableParam,'Data'); 
switch paramRunApp.genMethod
    case {'PARAFAC'}
        paramRunApp.numFactors = str2double(datTab{1,2});
        ss=['{',datTab{2,2},'}'];
        paramRunApp.freqIn2use = eval(ss);
        paramRunApp.fLinesInd2use = retFlines2use(paramRunApp);
        if isfield(paramRunApp,'artifactLabel')
            paramRunApp.remArtifact = datTab{3,2};
        end
%         if isfield(paramRunApp,'errorType')
%            if isfield(paramRunApp,'artifactLabel')
%                ss=datTab{4,2};
%            else
%                ss=datTab{3,2};
%            end
%             ss=['[',ss,']'];
%             paramRunApp.errorType2use = eval(ss);
%         end
        paramRunApp.centerData = datTab{end-3,2};
        %%% new 
        ss=['[',datTab{end-2,2},']'];
        paramRunApp.parafacOpt = eval(ss);
        ss=['[',datTab{end-1,2},']'];
        paramRunApp.parafacConst = eval(ss);
        paramRunApp.parafacPrctRemove = str2double(datTab{end,2});    
    case {'NPLS','PCA'}       
       paramRunApp.numFactors = str2double(datTab{1,2});  
       ss=['{',datTab{2,2},'}'];
       paramRunApp.freqIn2use = eval(ss); 
       paramRunApp.fLinesInd2use = retFlines2use(paramRunApp); 
       if isfield(paramRunApp,'artifactLabel')
           paramRunApp.remArtifact = datTab{3,2};
       end
%        if isfield(paramRunApp,'errorType')
%            if isfield(paramRunApp,'artifactLabel')
%                ss=datTab{4,2};
%            else
%                ss=datTab{3,2};
%            end
%            ss=['[',ss,']'];
%            paramRunApp.errorType2use = eval(ss);
%        end
       paramRunApp.centerData = datTab{end,2}; 
    case 'KPLS'       
       paramRunApp.numFactors = str2double(datTab{1,2});         
       ss=['{',datTab{2,2},'}'];
       paramRunApp.freqIn2use = eval(ss); 
       paramRunApp.fLinesInd2use = retFlines2use(paramRunApp); 
       if isfield(paramRunApp,'artifactLabel')
           paramRunApp.remArtifact = datTab{3,2};
       end
%        if isfield(paramRunApp,'errorType')
%            if isfield(paramRunApp,'artifactLabel')
%                ss=datTab{4,2};
%            else
%                ss=datTab{3,2};
%            end
%            ss=['[',ss,']'];
%            paramRunApp.errorType2use = eval(ss);
%        end
       paramRunApp.centerData = datTab{end,2};  
       %%%%% now read parameters values 
       str = get(handles.listSelKernel,'String');
       pos = get(handles.listSelKernel,'Value');
       switch  str{pos}
           case 'Linear'
               paramRunApp.kernelFcn='Linear';
               paramRunApp.kernelFcnParam(1:2)=NaN; 
           case 'Polynomial'
               paramRunApp.kernelFcn='Polynomial';               
               paramRunApp.kernelFcnParam(1)=str2double(get(handles.valKF1,'String'));
               paramRunApp.kernelFcnParam(2)=str2double(get(handles.valKF2,'String'));
           case 'Gaussian'
               paramRunApp.kernelFcn='Gaussian';               
               paramRunApp.kernelFcnParam(1)=str2double(get(handles.valKF1,'String'));
               paramRunApp.kernelFcnParam(2)=NaN; 
       end              
end 

%%%% get method for bins processing 
str = get(handles.listBinMeth,'String');
pos = get(handles.listBinMeth,'Value');
switch str{pos}
    case 'none'
        paramRunApp.binProcess = 'none'; 
        paramRunApp.binGF = [];
        if isfield(paramRunApp,'relSpect')
            paramRunApp=rmfield(paramRunApp,'relSpect'); 
        end 
    case 'GF power'
        paramRunApp.binProcess = 'GF'; 
        paramRunApp.binGF(1) = str2double(get(handles.valGF1,'String'));
        paramRunApp.binGF(2) = str2double(get(handles.valGF2,'String')); 
    case 'GF power + Average'
        paramRunApp.binProcess = 'GFAvg'; 
        paramRunApp.binGF(1) = str2double(get(handles.valGF1,'String'));
        paramRunApp.binGF(2) = str2double(get(handles.valGF2,'String'));
    case 'Average'
        paramRunApp.binProcess = 'Avg';
        paramRunApp.binGF = [];
        if isfield(paramRunApp,'relSpect')
            paramRunApp=rmfield(paramRunApp,'relSpect');
        end
    case 'Relative Average'
        paramRunApp.binProcess = 'RelAvg';
        paramRunApp.binGF = [];
        prompt = {'Enter begining of the relative band [Hz]:','Enter end of the relative band [Hz]:'};
        dlg_title = 'Input the range for realtive power';
        num_lines = 1;
        if isfield(paramRunApp,'relSpect')
            def = {num2str(paramRunApp.relSpect{1}),num2str(paramRunApp.relSpect{2})};
        else
            def = {num2str(paramRunApp.fLines(1)),num2str(paramRunApp.fLines(end))};
        end
        paramRunApp.relSpect = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(paramRunApp.relSpect) 
            hW=warndlg('Relative range not selected - none will be used','!! Warning !!')
            uiwait(hW)
             paramRunApp.binProcess = 'none';
        end 
    case 'Relative Spectra'
        paramRunApp.binProcess = 'RelSpect';
        paramRunApp.binGF = [];
        prompt = {'Enter begining of the relative band [Hz]:','Enter end of the relative band [Hz]:'};
        dlg_title = 'Input the range for realtive power';
        num_lines = 1;
        if isfield(paramRunApp,'relSpect')
            def = {num2str(paramRunApp.relSpect{1}),num2str(paramRunApp.relSpect{2})};
        else
            def = {num2str(paramRunApp.fLines(1)),num2str(paramRunApp.fLines(end))};
        end
        paramRunApp.relSpect = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(paramRunApp.relSpect) 
            hW=warndlg('Relative range not selected - none will be used','!! Warning !!')
            uiwait(hW)
             paramRunApp.binProcess = 'none';
        end 
end         

%%%% print right panel table parameters 
handles = printRightPanel(paramRunApp, handles); 

%%%% set visible new ok window
set(handles.pushOK3,'Visible','on','Value',0);
set(handles.checkSelL,'Visible','on','Value',0); 

strRFT = get(handles.fileTextR1,'String');
strRFT=strRFT(1:3); 
if isfield(paramRunApp,'origXlabels')
    if isfield(paramRunApp,'useSelfPairs')
        set(handles.rSelffPairs,'Visible','on','Value',paramRunApp.useSelfPairs);
        if paramRunApp.useSelfPairs
            strRFT(end+1)={['Self-pairs  : ','yes']};
        else
            strRFT(end+1)={['Self-pairs  : ','no']};
        end
    else 
        set(handles.rSelffPairs,'Visible','on','Value',0);
        strRFT(end+1)={['Self-pairs : ','no']};
    end 
    if isfield(paramRunApp,'useInter')
        set(handles.rInter,'Visible','on','Value',paramRunApp.useInter);
        if paramRunApp.useInter
            strRFT(end+1)={['Inter-hemis: ','yes']};
        else
            strRFT(end+1)={['Inter-hemis: ','no']};
        end
    else 
        set(handles.rInter,'Visible','on','Value',0);
        strRFT(end+1)={['Inter-hemis: ','no']};
    end
    strRFT(end+1)={'--------------------------------'};
end 
if isfield(paramRunApp,'plotFileName')
    set(handles.checkPlotRes,'Visible','on','Value',1);
    strRFT(end+1)={['Plot m-file: ',paramRunApp.plotFileName]}; 
else 
    set(handles.checkPlotRes,'Visible','on','Value',0);
    strRFT(end+1)={'Plot m-file: no'};
end
set(handles.fileTextR1,'String',strRFT);



guidata(hObject,handles) 


% --- Executes on button press in pushOK3.
function pushOK3_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.pushOK3,'Visible','off','Value',0);
set(handles.checkPlotRes,'Visible','off');
%set(handles.textAddParam,'Visible','off');
set(handles.checkSelL,'Visible','off','Value',0);
set(handles.tableAddParam,'Visible','off');
if isfield(paramRunApp,'origXlabels')
    paramRunApp.useSelfPairs=get(handles.rSelffPairs,'Value');
    paramRunApp.useInter=get(handles.rInter,'Value');
    set(handles.rSelffPairs,'Visible','off','Value',0);
    set(handles.rInter,'Visible','off','Value',0);
end 


%%% if no selection use all variables 
if ~isfield(paramRunApp,'var2use')
    paramRunApp.var2use = 1:length(paramRunApp.Xlabels);
    if isfield(paramRunApp,'origXlabels')
        paramRunApp.Xlabels2use = paramRunApp.origXlabels;
    end 
end 

handles = printRightPanel(paramRunApp,handles);

set(handles.pushRunApp,'Visible','on');
set(handles.pushSaveParam,'Visible','on');
set(handles.pushFinish,'Visible','on');
set(handles.pushGoBack,'Visible','on');

guidata(hObject,handles) 

% --- Executes on button press in checkSelL.
function checkSelL_Callback(hObject, eventdata, handles)
% hObject    handle to checkSelL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp


set(handles.pushOK3,'Enable','off');
set(handles.checkPlotRes,'Enable','off');
set(handles.checkSelL,'Enable','off','Visible','off');
if isfield(paramRunApp,'origXlabels')
    set(handles.rSelffPairs,'Enable','off');
    set(handles.rInter,'Enable','off');
end 

if isfield(paramRunApp,'origXlabels')
    param.Xlabels    = paramRunApp.origXlabels;
    %param.allXlabels = paramRunApp.Xlabels;
else
    param.Xlabels = paramRunApp.Xlabels;
end
if isfield(paramRunApp,'Xlabels2use')
    param.Xlabels2use = paramRunApp.Xlabels2use;
    param.var2use = paramRunApp.var2use;
elseif isfield(paramRunApp,'excludeLaplacian')
    vI=ones(1,length(param.Xlabels));
    vI(paramRunApp.excludeLaplacian)=0; 
    param.Xlabels2use = param.Xlabels(vI==1);
    param.var2use =  find(vI==1); 
end

save('tmpSelElect','param');
hS = plotSelElect;
uiwait(hS)
load('tmpSelElect','param');
delete('tmpSelElect.mat')

if isfield(param,'Xlabels2use')
    paramRunApp.Xlabels2use = param.Xlabels2use;
    paramRunApp.var2use = param.var2use;
end 
clear param 

strRFT = get(handles.fileTextR1,'String');

if isfield(paramRunApp,'Xlabels2use')
    if length(paramRunApp.Xlabels2use) == length(paramRunApp.Xlabels)
        set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
        nstr=strcat('Variables to use: all');
        strRFT(1)={nstr};
        strRFT(2)={' '};
        set(handles.fileTextR1,'Visible','on','String',strRFT);
    elseif isfield(paramRunApp,'origXlabels') && ...
            length(paramRunApp.Xlabels2use) == length(paramRunApp.origXlabels)
        set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
        nstr=strcat('Variables to use: all');
        strRFT(1)={nstr};
        strRFT(2)={' '};
        set(handles.fileTextR1,'Visible','on','String',strRFT);
    else
        nstr=strcat('Variables to use: ');
        strRFT(1)={nstr};
        pStr =[];
        for sI=1:length(paramRunApp.Xlabels2use)
            pStr=[pStr,paramRunApp.Xlabels2use{sI},','];
        end
        pStr=pStr(1:end-1);
        strRFT(2)={pStr};
        set(handles.fileTextR1,'Visible','on','String',strRFT);
        set(handles.checkSelL,'Enable','on','Visible','on','Value',1);
        
    end
else
    nstr=strcat('Variables to use: all');
    strRFT(1)={nstr};
    strRFT(2)={' '};
    set(handles.fileTextR1,'Visible','on','String',strRFT);
    set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
end

set(handles.pushOK3,'Enable','on');
set(handles.checkPlotRes,'Enable','on');
if isfield(paramRunApp,'origXlabels')
    set(handles.rSelffPairs,'Enable','on');
    set(handles.rInter,'Enable','on');
end 

guidata(hObject,handles)


% --- Executes on button press in rSelffPairs.
function rSelffPairs_Callback(hObject, eventdata, handles)
% hObject    handle to rSelffPairs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

strRFT = get(handles.fileTextR1,'String');
if get(handles.rSelffPairs,'Value')
   paramRunApp.useSelfPairs=true;
   strRFT(4)={['Self-pairs  : ','yes']};
else
    paramRunApp.useSelfPairs=false;
    strRFT(4)={['Self-pairs  : ','no']};
end
set(handles.fileTextR1,'String',strRFT);

guidata(hObject,handles)


% --- Executes on button press in rInter.
function rInter_Callback(hObject, eventdata, handles)
% hObject    handle to rInter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

strRFT = get(handles.fileTextR1,'String');
if get(handles.rInter,'Value')
   paramRunApp.useInter=true;
   strRFT(5)={['Inter-hemis: ','yes']};
else
    paramRunApp.useInter=false;
    strRFT(5)={['Inter-hemis: ','no']};
end
set(handles.fileTextR1,'String',strRFT);

guidata(hObject,handles)

% --- Executes on button press in checkPlotRes.
function checkPlotRes_Callback(hObject, eventdata, handles)
% hObject    handle to checkPlotRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp 

    
if get(handles.checkPlotRes,'Value')      
    set(handles.checkPlotRes,'Enable','off');
    set(handles.pushOK3,'Enable','off');
    
    [fileName, pathName] = uigetfile ({'./Customized-M-files/*.m'},'Open Results Plotting m-file');
    pathName=getRelPath(pathName); 
    
    if fileName
        %%% load parameters
        strF=strcat(pathName,fileName);
        %%%% define filter file, this also means filtering data .....
        paramRunApp.plotFileName = fileName;
        %paramRunApp.plotPathName = pathName;
        strRFT = get(handles.fileTextR1,'String');
        strRFT(end)={['Plot m-file: ',paramRunApp.plotFileName]};         
        set(handles.fileTextR1,'Visible','on','String',strRFT);
        
        set(handles.checkPlotRes,'Enable','on','Value',1);
        set(handles.pushOK3,'Enable','on');
    else
        set(handles.checkPlotRes,'Enable','on','Value',0);
        set(handles.pushOK3,'Enable','on');    
    end
else
    paramRunApp=rmfield(paramRunApp,'plotFileName');
    %paramRunApp=rmfield(paramRunApp,'plotPathName');
    strRFT = get(handles.fileTextR1,'String');
    strRFT(end)={'Plot m-file: no'};       
    set(handles.fileTextR1,'Visible','on','String',strRFT);  
end     


guidata(hObject,handles)

% --- Executes on button press in pushRunApp.
function pushRunApp_Callback(hObject, eventdata, handles)
% hObject    handle to pushRunApp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp
global hF 
global resPARAFAC 
global resPLS

set(handles.pushRunApp,'Enable','off');
set(handles.pushSaveParam,'Enable','off');
set(handles.pushFinish,'Enable','off');
set(handles.pushGoBack,'Enable','off');
set(handles.removeAtoms,'Enable','off'); 

% if ~isfield(paramRunApp,'var2use') %%% no selection of variables 
%     paramRunApp.var2use = 1:length(paramRunApp.Xlabels);
% end


%%% --- begin modification ---
% we want to ask to save after seeing results

% if strfind(paramRunApp.fileName,'data_GenerateSets_')
%     strFile=strcat('./Results/res',paramRunApp.genMethod,'_',paramRunApp.fileName(19:end));
% else
%     strFile=strcat('./Results/res',paramRunApp.genMethod);
% end
% 
% [fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ... 
%                                   'Save results as ...',strFile);
% pathName=getRelPath(pathName); 
%     
% if pathName
%     %hW=warndlg('Working ..... ');
%     if fName
%         paramRunApp.resultsName = strcat(pathName,fName);
%     else
%         paramRunApp.resultsName = [];
%     end
    
    switch paramRunApp.genMethod
        case 'PARAFAC'
            [hF,resPARAFAC] = runApp(paramRunApp);
            if isfield(paramRunApp,'reRunPARAFAC')
                paramRunApp=rmfield(paramRunApp,'reRunPARAFAC');
            end
            set(handles.removeAtoms,'Visible','on','String','Remove PARAFAC atoms and Re-run');
        case {'NPLS','KPLS'}
            [hF,resPLS] = runApp(paramRunApp);
            if isfield(paramRunApp,'reRunPLS')
                paramRunApp=rmfield(paramRunApp,'reRunPLS');
            end
            if strcmp(paramRunApp.genMethod,'NPLS')
                set(handles.removeAtoms,'Visible','on','String','Remove NPLS atoms and Re-run');
            elseif strcmp(paramRunApp.genMethod,'KPLS')
                set(handles.removeAtoms,'Visible','on','String','Remove KPLS atoms and Re-run');
            end
            set(handles.removeAtoms,'Visible','on');
        otherwise
            hF = runApp(paramRunApp);
    end
    %close(hW)
% end

%%% --- end modification ---
   
set(handles.pushRunApp,'Enable','on');
set(handles.pushSaveParam,'Enable','on');
set(handles.pushFinish,'Enable','on');
set(handles.pushGoBack,'Enable','on');
set(handles.removeAtoms,'Enable','on'); 

guidata(hObject,handles)

% --- Executes on button press in pushSaveParam.
function pushSaveParam_Callback(hObject, eventdata, handles)
% hObject    handle to pushSaveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp


[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ... 
                                  'Save parameters as ...',['./ParameterFiles/param_RunApp_',paramRunApp.genMethod,'.mat']);
pathName=getRelPath(pathName); 

if fName
    str=strcat(pathName,fName);
    paramRunApp.paramSaveFile=str; 
    save(str,'paramRunApp'); 
    %set(handles.pushSaveParam,'UserData',true);
end 
guidata(hObject,handles)

% --- Executes on button press in pushGoBack.
function pushGoBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushGoBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.pushRunApp,'Visible','off','Value',0);
set(handles.pushSaveParam,'Visible','off','Value',0);
set(handles.pushFinish,'Visible','off','Value',0);
set(handles.pushGoBack,'Visible','off','Value',0);
set(handles.removeAtoms,'Visible','off','Value',0);

%%% set kenrnel sel visible 
if strcmp(paramRunApp.genMethod,'KPLS')
    switch  paramRunApp.kernelFcn
        case 'Linear'
            set(handles.panelParKF,'Visible','off')
        case 'Polynomial'
            set(handles.panelParKF,'Title','k(x,y) =(<x,y>+param2)^param1','Visible','on')
            set(handles.txtPar1,'Visible','on');
            set(handles.txtPar2,'Visible','on');
            set(handles.valKF1,'Visible','on');
            set(handles.valKF2,'Visible','on');
        case 'Gaussian'
            set(handles.panelParKF,'Title','k(x,y) =exp((|x-y|^2)/param1)','Visible','on')
            set(handles.txtPar1,'Visible','on');
            set(handles.valKF1,'Visible','on');
            set(handles.txtPar2,'Visible','off');
            set(handles.valKF2,'Visible','off');
    end
end


set(handles.textBinProcess,'Visible','on');
%set(handles.listBinMeth,'Visible','on','String',{'none','Average','GF power','GF power + Average',});
set(handles.listBinMeth,'Visible','on','String',{'none','Relative Spectra','Average','Relative Average'});
switch paramRunApp.binProcess
    case 'none'
        val=1;
     case 'RelSpect'
        val=2;       
    case 'Avg'
        val=3;
    case 'RelAvg'
        val=4;
end
set(handles.listBinMeth,'Value',val); 

if ~isempty(paramRunApp.binGF)
    set(handles.panelRangeGF,'Visible','on'); 
    set(handles.textRangeGF,'Visible','on'); 
    %%% not sure why this visibility is not poping out automatically 
    set(handles.valGF1,'String',num2str(paramRunApp.binGF(1)),'Visible','on'); 
    set(handles.valGF2,'String',num2str(paramRunApp.binGF(2)),'Visible','on');
    set(handles.txtBgGF,'Visible','on'); 
    set(handles.txtEndGF,'Visible','on'); 
end 

[handles] = setExistingParamTable(handles); 

guidata(hObject,handles)

% --- Executes on button press in pushFinish.
function pushFinish_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hF
global paramRunApp  


set(handles.pushRunApp,'Visible','on');
set(handles.pushSaveParam,'Visible','on');

if isfield(paramRunApp,'paramSaveFile')
    save(paramRunApp.paramSaveFile,'paramRunApp');
    close(handles.figure1);
    if ~isempty(hF)
        for i=1:length(hF)
            close(findobj('Name',hF{i}));
        end
    end
    figs = findobj(0,'type','figure');
    if length(figs) > 1
        figs=sort(figs);
        close(figs(1:end-1))
    end
    
else
    hD=questdlg('Parameters not saved .... Continue anyway?', ...
        'Parameters not saved !','yes','no','no');
    switch hD
        case 'yes'
            close(handles.figure1);
            %close all 
            if ~isempty(hF)
                for i=1:length(hF)
                    close(findobj('Name',hF{i}));
                end
            end
            figs = findobj(0,'type','figure');
            if length(figs) > 1 
                figs=sort(figs); 
                close(figs(1:end-1))
            end 
        case 'no'
            %%% do nothing here, keep loop
    end
end


% --- Executes on button press in pushClass.
function pushClass_Callback(hObject, eventdata, handles)
% hObject    handle to pushClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushClass,'Value',1);
set(handles.pushReg,'Value',0);
set(handles.pushModel,'Value',0);
set(handles.listGenMethod,'Value',1);
if get(handles.checkMultiY,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'NPLS'});
elseif get(handles.checkMultiN,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'});
else 
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'})
end         

guidata(hObject,handles)


% --- Executes on button press in pushReg.
function pushReg_Callback(hObject, eventdata, handles)
% hObject    handle to pushReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushClass,'Value',0);
set(handles.pushReg,'Value',1);
set(handles.pushModel,'Value',0);
set(handles.listGenMethod,'Value',1);
if get(handles.checkMultiY,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'NPLS'});
elseif get(handles.checkMultiN,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'});
else 
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'})
end


guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of pushReg


% --- Executes on button press in pushModel.
function pushModel_Callback(hObject, eventdata, handles)
% hObject    handle to pushModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushClass,'Value',0);
set(handles.pushReg,'Value',0);
set(handles.pushModel,'Value',1);

set(handles.listGenMethod,'Value',1);
if get(handles.checkMultiY,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'PARAFAC'});
elseif get(handles.checkMultiN,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'PCA'});
else 
    set(handles.listGenMethod,'Visible','on','String',{'PCA'})
end
guidata(hObject,handles)


% --- Executes on button press in checkMultiY.
function checkMultiY_Callback(hObject, eventdata, handles)
% hObject    handle to checkMultiY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listGenMethod,'Value',1);
if get(handles.pushClass,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'NPLS'});        
elseif get(handles.pushReg,'Value')    
    set(handles.listGenMethod,'Visible','on','String',{'NPLS'});      
elseif get(handles.pushModel,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'PARAFAC'});
end

set(handles.textRunMulti,'Visible','on');
set(handles.checkMultiY,'Visible','on','Value',1);
set(handles.checkMultiN,'Visible','on','Value',0);

guidata(hObject,handles) 


% --- Executes on button press in checkMultiN.
function checkMultiN_Callback(hObject, eventdata, handles)
% hObject    handle to checkMultiN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listGenMethod,'Value',1);
if get(handles.pushClass,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'}); % ,'LDA'});        
elseif get(handles.pushReg,'Value')    
    set(handles.listGenMethod,'Visible','on','String',{'KPLS'});      
elseif get(handles.pushModel,'Value')
    set(handles.listGenMethod,'Visible','on','String',{'PCA'});
end
set(handles.textRunMulti,'Visible','on');
set(handles.checkMultiY,'Visible','on','Value',0);
set(handles.checkMultiN,'Visible','on','Value',1);

guidata(hObject,handles)


% --- Executes on selection change in listGenMethod.
function listGenMethod_Callback(hObject, eventdata, handles)
% hObject    handle to listGenMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listGenMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        listGenMethod
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function listGenMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listGenMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listSelKernel.
function listSelKernel_Callback(hObject, eventdata, handles)
% hObject    handle to listSelKernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp


str = get(handles.listSelKernel,'String');
pos = get(handles.listSelKernel,'Value');

%%% check if kernel can run
if ~strcmp(str{pos},'Linear')
    if ~isfield(paramRunApp,'kernelDiff')        
        load(paramRunApp.fileName,'header')
        trS=0;valS=0;tstS=0;
        for c=1:length(header.XtrainSize)
            trS=trS + header.XtrainSize{c}(1);
            valS=valS + header.XvalSize{c}(1);
        end
        for c=1:length(header.XtestSize)
            tstS=tstS + header.XtestSize{c}(1);            
        end
        paramRunApp.kernelDiff(1)=trS; 
        paramRunApp.kernelDiff(2)=valS; 
        paramRunApp.kernelDiff(3)=tstS; 
    end
    mxN = max(paramRunApp.kernelDiff); 
    if mxN > 1000
        wD=warndlg('Gram matrix is large (> 1000). This may lead to computational and storgae difficulties'); 
        uiwait(wD)        
    end 
end

switch  str{pos}
    case 'Linear'
        set(handles.panelParKF,'Visible','off')        
    case 'Polynomial'
        set(handles.panelParKF,'Title','k(x,y) =(<x,y>+param2)^param1','Visible','on')
        set(handles.txtPar1,'Visible','on'); 
        set(handles.txtPar2,'Visible','on');
        set(handles.valKF1,'Visible','on'); 
        set(handles.valKF2,'Visible','on');       
    case 'Gaussian'
        set(handles.panelParKF,'Title','k(x,y) =exp((|x-y|^2)/param1)','Visible','on')        
        set(handles.txtPar1,'Visible','on'); 
        set(handles.valKF1,'Visible','on');
        set(handles.txtPar2,'Visible','off'); 
        set(handles.valKF2,'Visible','off');
end 

guidata(hObject,handles) 


% --- Executes during object creation, after setting all properties.
function listSelKernel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSelKernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valKF1_Callback(hObject, eventdata, handles)
% hObject    handle to valKF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valKF1 as text
%        str2double(get(hObject,'String')) returns contents of valKF1 as a double


% --- Executes during object creation, after setting all properties.
function valKF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valKF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valKF2_Callback(hObject, eventdata, handles)
% hObject    handle to valKF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valKF2 as text
%        str2double(get(hObject,'String')) returns contents of valKF2 as a double


% --- Executes during object creation, after setting all properties.
function valKF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valKF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function valGF1_Callback(hObject, eventdata, handles)
% hObject    handle to valGF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valGF1 as text
%        str2double(get(hObject,'String')) returns contents of valGF1 as a double


% --- Executes during object creation, after setting all properties.
function valGF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valGF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valGF2_Callback(hObject, eventdata, handles)
% hObject    handle to valGF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valGF2 as text
%        str2double(get(hObject,'String')) returns contents of valGF2 as a double


% --- Executes during object creation, after setting all properties.
function valGF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valGF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listBinMeth.
function listBinMeth_Callback(hObject, eventdata, handles)
% hObject    handle to listBinMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp 

str = get(handles.listBinMeth,'String');
pos = get(handles.listBinMeth,'Value');
switch str{pos}
    case {'GF power','GF power + Average'}
        set(handles.textRangeGF,'Visible','on')
        set(handles.panelRangeGF,'Visible','on')
        set(handles.valGF1,'String',num2str(paramRunApp.binGF(1)),'Visible','on');
        set(handles.valGF2,'String',num2str(paramRunApp.binGF(2)),'Visible','on');
        set(handles.txtBgGF,'Visible','on');
        set(handles.txtEndGF,'Visible','on');
    otherwise
        set(handles.textRangeGF,'Visible','off')
        set(handles.panelRangeGF,'Visible','off')
end
guidata(hObject,handles) 


% --- Executes during object creation, after setting all properties.
function listBinMeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBinMeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = printfileText(handles, fileName, header)
strFT(1)={fileName};
strFT(2)={'--------------------------------'};
pStr=['number of classes: ',num2str(header.numClass)];
if isfield(header,'classLabel')
    pStr = [pStr, ' ['];  
    for i=1:length(header.classLabel)
        pStr = [pStr,num2str(header.classLabel(i)),','];
    end
    pStr(end)=']'; 
end
strFT(3)={pStr};
strFT(4)={'--------------------------------'};
pTrain='train  set: ';
pVal='valid. set: ';
pTest='test   set: ';
for cl=1:header.numClass
    if length(header.multiWay) > 1 
        if header.XtrainSize{cl}(1)
            pTrain=[pTrain,' class',num2str(cl),' (', ...
                num2str(header.XtrainSize{cl}(1)),'x{'];
            for m=1:length(header.multiWay)
                pTrain= [pTrain,num2str(header.multiWay(m)),'x'];                
            end
            pTrain(end:end+2)='});';
        else
            pTrain=[pTrain,' class',num2str(cl),' (0x0);']
        end
        if header.XvalSize{cl}(1)
            pVal=[pVal,' class',num2str(cl),' (', ...
                num2str(header.XvalSize{cl}(1)),'x{'];
            for m=1:length(header.multiWay)
                pVal= [pVal,num2str(header.multiWay(m)),'x'];
            end
            pVal(end:end+2)='});';
        else
            pVal=[pVal,' class',num2str(cl),' (0x0);'];
        end
    elseif  length(header.multiWay) == 1
        pTrain=[pTrain,' class',num2str(cl),' (', ...
            num2str(header.XtrainSize{cl}(1)),'x',num2str(header.XtrainSize{cl}(2)),') ;'];
        pVal=[pVal,' class',num2str(cl),' (', ...
            num2str(header.XvalSize{cl}(1)),'x',num2str(header.XvalSize{cl}(2)),') ;'];
    end
end

for cl=1:length(header.XtestSize)
    if length(header.XtestSize)==1
        pTest=[pTest,'allClasses'];
        if length(header.multiWay) > 1
            if header.XtestSize{cl}(1)
                pTest=[pTest,' (', ...
                    num2str(header.XtestSize{cl}(1)),'x{'];
                for m=1:length(header.multiWay)
                    pTest= [pTest,num2str(header.multiWay(m)),'x'];
                end
                pTest(end:end+2)='});';
            else
                pTest=[pTest,' class',num2str(cl),' (0x0);'];
            end
        elseif  length(header.multiWay) == 1
            pTest=[pTest,' (', ...
                num2str(header.XtestSize{cl}(1)),'x',num2str(header.XtestSize{cl}(2)),') ;'];
        end
    else
        %pTest=strcat(pTest,'class',num2str(cl),' (', ...
        %  num2str(header.XtestSize{cl}(1)),'x',num2str(header.XtestSize{cl}(2)),') ;');
        if length(header.multiWay) > 1
            if header.XtestSize{cl}(1)
                pTest=[pTest,' (', ...
                    num2str(header.XtestSize{cl}(1)),'x{'];
                for m=1:length(header.multiWay)
                    pTest= [pTest,num2str(header.multiWay(m)),'x'];
                end
                pTest(end:end+2)='});';
            else
                pTrain=[pTrain,' (0x0);'];
            end
        elseif  length(header.multiWay) == 1
            pTest=[pTest,' class',num2str(cl),' (', ...
                num2str(header.XtestSize{cl}(1)),'x',num2str(header.XtestSize{cl}(2)),') ;'];
            
        end
    end
end
pTrain=pTrain(1:end-1);
pVal=pVal(1:end-1);
pTest=pTest(1:end-1);
strFT(5)={pTrain};
strFT(6)={pVal};
strFT(7)={pTest};
set(handles.fileText,'Visible','on','String',strFT);


%%%%%%% here I genereate the intial menu !!!! 
function handles = fcn_setInitMenu(header,handles)

set(handles.loadFile,'Enable','on','Visible','off');
set(handles.loadParam,'Enable','on','Visible','off');
set(handles.topPanel,'Visible','on');


%%% method selection 
set(handles.textTaskType,'Visible','on');
if header.numClass == 1      
    if header.multiWay(1) > 1 
        set(handles.listGenMethod,'Visible','on','String',{'PARAFAC'});
        set(handles.textRunMulti,'Visible','on');
        set(handles.checkMultiY,'Visible','on','Value',1);
        set(handles.checkMultiN,'Visible','on');
    else
        set(handles.listGenMethod,'Visible','on','String',{'PCA'});
    end  
    set(handles.pushReg,'Visible','on');
    set(handles.pushModel,'Visible','on','Value',1);
else
    set(handles.pushClass,'Visible','on','Value',1);
    %set(handles.pushReg,'Visible','on');
    %set(handles.pushModel,'Visible','on');
    set(handles.textSelMethod,'Visible','on');
    set(handles.listGenMethod,'Value',1);    
    if header.multiWay(1) > 1 
        set(handles.listGenMethod,'Visible','on','String',{'NPLS'});
        set(handles.textRunMulti,'Visible','on');
        set(handles.checkMultiY,'Visible','on','Value',1);
        set(handles.checkMultiN,'Visible','on');
    else
        set(handles.listGenMethod,'Visible','on','String',{'KPLS'});
    end
    %set(handles.pushReg,'Visible','on','String','Regression (by merging all classes into one)');
    set(handles.pushModel,'Visible','on','String','Modeling (by merging all classes into one)');
end
%%%% 

set(handles.pushOK1,'Visible','on','Value',0);


function fLines2use = retFlines2use(param)
nfL=length(param.fLines);
nBands=length(param.freqIn2use);%%% define number of bands
fLines2use = []; 
for b=1:nBands
    fl = find(param.fLines >= param.freqIn2use{b}(1) & ...
        param.fLines <=  param.freqIn2use{b}(end));
    fLines2use = [fLines2use, fl];
end

function [handles] = setParamTable(handles)

global paramRunApp

switch paramRunApp.genMethod
    case 'PCA'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName={'Number of PCA factors'}; %,'Labels for classes'};
        if isfield(paramRunApp,'freqIn')
            rowName{end+1} = 'Frequencies to use';
        end
        if isfield(paramRunApp,'artifactLabel')
            rowName{end+1}='Remove artifact epochs';
        end
%         if isfield(paramRunApp,'errorType')
%             rowName{end+1}=['Remove error samples  (',paramRunApp.errorType,')'];
%         end
        rowName{end+1}='Center data ';
        paramRunApp.tableParamRowNames = rowName;
        datTab{1} = '2';
        if isfield(paramRunApp,'freqIn')
            strp=[];
            for c=1:length(paramRunApp.freqIn)
                strp=[strp,'[',num2str(paramRunApp.freqIn{c}(1)),' , ',num2str(paramRunApp.freqIn{c}(2)),'] '];
            end
            datTab{end + 1}= strp;
        end
        if isfield(paramRunApp,'artifactLabel')
            datTab{end+1}='yes';
        end
%         if isfield(paramRunApp,'errorType')
%             datTab{end + 1}= '[0 , 100]';
%         end
        datTab{end+1}='yes'; %%% default to center data 
    case 'PARAFAC'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName={'Number of PARAFAC factors'}; %,'Labels for classes'};
        if isfield(paramRunApp,'freqIn')
            rowName{end+1} = 'Frequencies to use';
        end
        if isfield(paramRunApp,'artifactLabel')
            rowName{end+1}='Remove artifact epochs';
        end
%         if isfield(paramRunApp,'errorType')
%             rowName{end+1}=['Remove error samples  (',paramRunApp.errorType,')'];
%         end
        rowName{end+1}='Center data by mode (e.g. 100,110 ... not center 000)';        
        datTab{1} = '6';
        if isfield(paramRunApp,'freqIn')
            strp=[];
            for c=1:length(paramRunApp.freqIn)
                % strp=[strp,'[',num2str(paramRunApp.freqIn{c}(1)),' , ',num2str(paramRunApp.freqIn{c}(2)),'] '];
                strp=[strp,'[',num2str(4),' , ',num2str(25),'] '];
            end
            datTab{end + 1}= strp;
        end
        if isfield(paramRunApp,'artifactLabel')
            datTab{end+1}='yes';
        end
%         if isfield(paramRunApp,'errorType')
%             datTab{end + 1}= '[0 , 100]';
%         end
        datTab{end+1}='100'; %%% default to center data 
        %%%% 
        %str=sprintf('Re-define additional parameters for %s',paramRunApp.genMethod);        
        rowName{end+1}='PARAFAC Options vector (opt(3) - plot)'; %,'Labels for classes'};
        rowName{end+1} = 'PARAFAC Constraints vector';
        rowName{end+1} = 'Percentile removed after 1st run (0 - no 2nd run)';
        paramRunApp.tableParamRowNames = rowName;
        datTab{end+1}='[0 0 0 0 0 100]';
%         strp=['[']; 
%         for i=1:(length(paramRunApp.multiWay)+1)
%             strp=[strp, '0 ']; 
%         end 
%         strp(end) = ']'; 
        strp='[2 2 3]';
        
        datTab{end + 1}= strp;
        datTab{end+1}='0';       
    case 'NPLS'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName={'Number of NPLS factors'}; %,'Labels for classes'};
        if isfield(paramRunApp,'freqIn')
            rowName{end+1} = 'Frequencies to use';
        end
        if isfield(paramRunApp,'artifactLabel')
            rowName{end+1}='Remove artifact epochs';
        end
%         if isfield(paramRunApp,'errorType')
%             rowName{end+1}=['Remove error samples  (',paramRunApp.errorType,')'];
%         end
        rowName{end+1}='Center data by mode (e.g. 100,110 ... not center 000)';
        paramRunApp.tableParamRowNames = rowName;
        %datTab{1} = '2';
        datTab{1} = '4';
        if isfield(paramRunApp,'freqIn')
            strp=[];
            for c=1:length(paramRunApp.freqIn)
                %strp=[strp,'[',num2str(paramRunApp.freqIn{c}(1)),' , ',num2str(paramRunApp.freqIn{c}(2)),'] '];
                strp=[strp,'[',num2str(5),' , ',num2str(25),'] '];
            end
            datTab{end + 1}= strp;
        end
        if isfield(paramRunApp,'artifactLabel')
            datTab{end+1}='yes';
        end
%         if isfield(paramRunApp,'errorType')
%             datTab{end + 1}= '[0 , 100]';
%         end
        datTab{end+1}='100'; %%% default to center data 
    case 'KPLS'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName={'Number of KPLS factors'}; 
        if isfield(paramRunApp,'freqIn')
            rowName{end+1} = 'Frequencies to use';
        end  
        if isfield(paramRunApp,'artifactLabel')
            rowName{end+1}='Remove artifact epochs';
        end
%         if isfield(paramRunApp,'errorType')
%             rowName{end+1}=['Remove error samples  (',paramRunApp.errorType,')'];
%         end
        rowName{end+1}='Center data ';
        paramRunApp.tableParamRowNames = rowName;
        datTab{1} = '2';
        if isfield(paramRunApp,'freqIn')
            strp=[];
            for c=1:length(paramRunApp.freqIn)
                strp=[strp,'[',num2str(paramRunApp.freqIn{c}(1)),' , ',num2str(paramRunApp.freqIn{c}(2)),'] '];
            end
            datTab{end + 1}= strp;
        end
        if isfield(paramRunApp,'artifactLabel')
            datTab{end+1}='yes';
        end
%         if isfield(paramRunApp,'errorType')
%             datTab{end + 1}= '[0 , 100]';
%         end
        datTab{end+1}='yes'; %%% default to center data 
        %%%%%% add sel kernel function param selection 
        set(handles.panelKerFcn,'Visible','on') 
        set(handles.listSelKernel,'Value',1);    
        set(handles.listSelKernel,'Visible','on','String',{'Linear','Polynomial','Gaussian'});        
end
%%%% show table
datTab=[rowName' , datTab'];
set(handles.tableParam,'Data',datTab, ...
    'Columnwidth',{325,300},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  ....
    'RowName',[],'Visible','on');

%%%% right text 1
strRFT = get(handles.fileTextR,'String');
lenCol=length(strRFT);
switch paramRunApp.genMethod
    case 'PARAFAC' %%% neee to avoid long strings !!!!
        en=size(datTab,1); 
        for c=1:en-3
            nstr=[datTab{c,1},': ',datTab{c,2}];
            strRFT(c+lenCol)={nstr};
        end
        nstr=['PARAFAC Opt.: ',datTab{en-2,2}];
        strRFT(en-2+lenCol)={nstr};
        nstr=['PARAFAC Opt.: ',datTab{en-1,2}];
        strRFT(en-1+lenCol)={nstr};
        nstr=['PARAFAC perc. remove: ',datTab{en,2}];
        strRFT(en+lenCol)={nstr};
        
    otherwise
        for c=1:length(datTab)
            nstr=[datTab{c,1},': ',datTab{c,2}];
            strRFT(c+lenCol)={nstr};
        end
end
if strcmp(paramRunApp.genMethod,'KPLS')
    nstr = ['Kernel function: ','Linear'];
    strRFT(end+1)={nstr};
end 

set(handles.fileTextR,'Visible','on','String',strRFT);

%%%% right text 2 
%strR1FT = get(handles.fileTextR1,'String');
pStr='Variables to use: all';
strR1FT(1)={pStr};
strR1FT(3)={'--------------------------------'};
set(handles.fileTextR1,'Visible','on','String',strR1FT);

set(handles.pushOK2,'Visible','on','Value',0);

function [handles] = setExistingParamTable(handles)

global paramRunApp

switch paramRunApp.genMethod
    case {'NPLS','PCA'}
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName = paramRunApp.tableParamRowNames;
        datTab{1}=num2str(paramRunApp.numFactors);
        strp=[];
        if isfield(paramRunApp,'freqIn2use')
            strp=[];
            for c=1:length(paramRunApp.freqIn2use)
                strp=[strp,'[',num2str(paramRunApp.freqIn2use{c}(1)),' , ',num2str(paramRunApp.freqIn2use{c}(2)),'] '];
            end
            datTab{2}= strp;
        end
        if isfield(paramRunApp,'remArtifact')
            datTab{3}=paramRunApp.remArtifact;
        end
%         if isfield(paramRunApp,'errorType')
%             strp=['[',num2str(paramRunApp.errorType2use(1)),' , ',num2str(paramRunApp.errorType2use(2)),']'];
%             datTab{4}=strp;
%         end
        datTab{end+1}=paramRunApp.centerData;
        
    case 'PARAFAC'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName = paramRunApp.tableParamRowNames;
        datTab{1}=num2str(paramRunApp.numFactors);
        strp=[];
        if isfield(paramRunApp,'freqIn2use')
            strp=[];
            for c=1:length(paramRunApp.freqIn2use)
                strp=[strp,'[',num2str(paramRunApp.freqIn2use{c}(1)),' , ',num2str(paramRunApp.freqIn2use{c}(2)),'] '];
            end
            datTab{2}= strp;
        end
        if isfield(paramRunApp,'remArtifact')
            datTab{3}=paramRunApp.remArtifact;
        end
%         if isfield(paramRunApp,'errorType')
%             strp=['[',num2str(paramRunApp.errorType2use(1)),' , ',num2str(paramRunApp.errorType2use(2)),']'];
%             datTab{4}=strp;
%         end
        datTab{end+1}=paramRunApp.centerData;
                
        strp=['[']; 
        for ii=1:length(paramRunApp.parafacOpt)
            strp=[strp, num2str(paramRunApp.parafacOpt(ii)),' ']; 
        end 
        strp(end) = ']'; 
        datTab{end + 1}= strp;        
        strp=['[']; 
        for ii=1:length(paramRunApp.parafacConst)
            strp=[strp, num2str(paramRunApp.parafacConst(ii)),' ']; 
        end 
        strp(end) = ']'; 
        datTab{end + 1}= strp;
        datTab{end+1}=num2str(paramRunApp.parafacPrctRemove);    
                
    case 'KPLS'
        str=sprintf('Re-define parameters for %s',paramRunApp.genMethod);
        set(handles.textDefParam,'Visible','on','String',str);
        rowName = paramRunApp.tableParamRowNames;
        datTab{1}=num2str(paramRunApp.numFactors);
        strp=[];
        if isfield(paramRunApp,'freqIn2use')
            strp=[];
            for c=1:length(paramRunApp.freqIn2use)
                strp=[strp,'[',num2str(paramRunApp.freqIn2use{c}(1)),' , ',num2str(paramRunApp.freqIn2use{c}(2)),'] '];
            end
            datTab{2}= strp;
        end
        if isfield(paramRunApp,'remArtifact')
            datTab{3}=paramRunApp.remArtifact;
        end
%         if isfield(paramRunApp,'errorType')
%             strp=['[',num2str(paramRunApp.errorType2use(1)),' , ',num2str(paramRunApp.errorType2use(2)),']'];
%             datTab{4}=strp;
%         end
        datTab{end+1}=paramRunApp.centerData;
        %%%%%% add sel kernel function param selection
        set(handles.panelKerFcn,'Visible','on')
        switch paramRunApp.kernelFcn
            case 'Linear'
                set(handles.listSelKernel,'Value',1);
            case 'Polynomial'
                set(handles.listSelKernel,'Value',2);
                set(handles.panelParKF,'Visible','on');
                set(handles.txtPar1,'Visible','on');
                set(handles.txtPar2,'Visible','on');
                set(handles.valKF1,'Visible','on','String',num2str(paramRunApp.kernelFcnParam(1)));
                set(handles.valKF2,'Visible','on','String',num2str(paramRunApp.kernelFcnParam(2)));
            case 'Gaussian'
                set(handles.listSelKernel,'Value',3);
                set(handles.panelParKF,'Visible','on');
                set(handles.txtPar1,'Visible','on');
                set(handles.txtPar2,'Visible','off');
                set(handles.valKF1,'Visible','on','String',num2str(paramRunApp.kernelFcnParam(1)));
                set(handles.valKF2,'Visible','off');
        end
        set(handles.listSelKernel,'Visible','on','String',{'Linear','Polynomial','Gaussian'});
end
%%%% show table 
datTab=[rowName' , datTab']; 
 set(handles.tableParam,'Data',datTab, ... 
    'Columnwidth',{325,300},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  .... 
    'RowName',[],'Visible','on'); 

set(handles.pushOK2,'Visible','on','Value',0);

function handles = printRightPanel(param,handles)

pStr=['Selected method: ', param.genMethod];
strRFT(1)={pStr};
strRFT(2)={'--------------------------------'};
indT=1; 
if isfield(param,'tableParamRowNames')
    switch param.genMethod
        case {'PCA','PARAFAC','NPLS','KPLS'}
            if isfield(param,'numFactors')
                nstr = [param.tableParamRowNames{indT},': ',num2str(param.numFactors)];
                strRFT(end+1) = {nstr};
                indT=indT + 1;
            end
            if isfield(param,'freqIn2use')
                nstr = [param.tableParamRowNames{indT},': '];
                indT=indT + 1;
                for i=1:length(param.freqIn2use)
                    nstr = [nstr,'[',num2str(param.freqIn2use{i}(1)),',' ...
                        num2str(param.freqIn2use{i}(2)),']'];
                end
                strRFT(end+1) = {nstr};
            end
            if isfield(param,'artifactLabel')
                nstr = [param.tableParamRowNames{indT},': ',param.remArtifact];
                indT=indT + 1;
                strRFT(end+1)= {nstr};
            end
%             if isfield(param,'errorType')
%                 nstr = [param.tableParamRowNames{indT},': '];
%                 indT=indT + 1;
%                 switch param.errorType
%                     case 'timeEpochVariance'
%                         nstr = [nstr,'[',num2str(param.errorType2use(1)),',' ...
%                             num2str(param.errorType2use(2)),']'];
%                 end
%                 strRFT(end+1)= {nstr};
%             end
            if isfield(param,'centerData')
                nstr = [param.tableParamRowNames{indT},': ',param.centerData];
                indT=indT + 1;
                strRFT(end+1) = {nstr};
            end
            %%% additional KPLS
            if strcmp(param.genMethod,'KPLS')
                nstr = ['Kernel function: ',param.kernelFcn];
                switch param.kernelFcn
                    case 'Polynomial'
                        nstr = [nstr,' (',num2str(param.kernelFcnParam(1)),' , ',num2str(param.kernelFcnParam(2)),')'];
                    case 'Gaussian'
                        nstr = [nstr,' (',num2str(param.kernelFcnParam(1)),')'];
                end
                strRFT(end+1) = {nstr};
            end
            %%% additional PARAFAC
            if isfield(param,'parafacOpt')
                nstr = 'PARAFAC Opt.: [';
                for i=1:length(param.parafacOpt)
                    nstr = [nstr,num2str(param.parafacOpt(i)),' '];
                end
                nstr(end)=']';
                strRFT(end+1) = {nstr};
                nstr = 'PARAFAC Const.: [';
                for i=1:length(param.parafacConst)
                    nstr = [nstr,num2str(param.parafacConst(i)),' '];
                end
                nstr(end)=']';
                strRFT(end+1) = {nstr};
                strRFT(end+1) = {['PARAFAC perc. remove: ',num2str(param.parafacPrctRemove)]};
            end
    end
end
if isfield(param,'binProcess')
    nstr = ['Bins process.: ',param.binProcess];
    %if strncmp(param.binProcess,'GF',2)
    if ~isempty(param.binGF)
        nstr=[nstr,' [',num2str(param.binGF(1)),',',num2str(param.binGF(2)),']']; 
    end
    if strcmp(param.binProcess,'RelSpect') || strcmp(param.binProcess,'RelAvg')
        nstr=[nstr,' [',param.relSpect{1},',',param.relSpect{2},']']; 
    end 
    strRFT(end+1)={nstr};
    
end

set(handles.fileTextR,'Visible','on','String',strRFT);


function [handles] = setRemoveAtomsParamTable(handles)

global paramRunApp

switch paramRunApp.genMethod
    case {'NPLS','KPLS'}
        str=sprintf('Define which atoms to keep and in which order to re-run %s',paramRunApp.genMethod);
        set(handles.textDefParam1,'Visible','on','String',str);
        rowName =  {['Which atoms to keep and in which order (e.g. [3, 1, 5], max ',num2str(paramRunApp.numFactors),'):']};
        % 'Keep the residual part of the first PARAFAC run', ...
        % 'Number of PARAFAC factors', ...
        % 'PARAFAC Options vector (opt(3) - plot)', ...
        % 'PARAFAC Constraints vector', ...
        % 'Percentile removed after 1st run (0 - no 2nd run)' ...
        % 'Center data:'};
        if isfield(paramRunApp,'reRunPLS')
            strp=[];
            strp=['['];
%             for ii=1:length(paramRunApp.reRunPLS.atomsRemove)
%                 strp=[strp, num2str(paramRunApp.reRunPLS.atomsRemove(ii)),', '];
%             end
            for ii=1:length(paramRunApp.reRunPLS.atomsKeep)
                strp=[strp, num2str(paramRunApp.reRunPLS.atomsKeep(ii)),', '];
            end
            strp=strp(1:end-1);
            strp(end) = ']';
            datTab{1}=strp;
        else
            datTab = [];
            strp=['[1]'];
            datTab{1}= strp;
        end
    case 'PARAFAC'
        str=sprintf('Define which atoms to remove and re-run %s',paramRunApp.genMethod);
        set(handles.textDefParam1,'Visible','on','String',str);
        if paramRunApp. parafacPrctRemove > 0
            rowName = {['Define which atoms to remove (e.g. [1, 3, 5], but max ',num2str(paramRunApp.numFactors),'):'], ...
                'Which PARAFAC run to use?  (1 or 2)', ...
                'Keep the residual part of the first PARAFAC run', ...
                'Number of PARAFAC factors', ...
                'PARAFAC Options vector (opt(3) - plot)', ...
                'PARAFAC Constraints vector', ...
                'Percentile removed after 1st run (0 - no 2nd run)' ...
                'Center data:'};
        else
            rowName =  {['Define which atoms to remove (e.g. [1, 3, 5], but max ',num2str(paramRunApp.numFactors),'):'], ...
                'Keep the residual part of the first PARAFAC run', ...
                'Number of PARAFAC factors', ...
                'PARAFAC Options vector (opt(3) - plot)', ...
                'PARAFAC Constraints vector', ...
                'Percentile removed after 1st run (0 - no 2nd run)' ...
                'Center data:'};
        end
        if isfield(paramRunApp,'reRunPARAFAC')
            strp=[];
            strp=['['];
            for ii=1:length(paramRunApp.reRunPARAFAC.atomsRemove)
                strp=[strp, num2str(paramRunApp.reRunPARAFAC.atomsRemove(ii)),', '];
            end
            strp=strp(1:end-1);
            strp(end) = ']';
            datTab{1}=strp;
            
            if paramRunApp.parafacPrctRemove > 0
                datTab{end+1}= '1'; %%% the first run
            end
            datTab{end+1}=paramRunApp.reRunPARAFAC.keepResiduals;
            datTab{end+1}=num2str(paramRunApp.reRunPARAFAC.numFactors);
            strp=[];
            strp=['['];
            for ii=1:length(paramRunApp.reRunPARAFAC.parafacOpt)
                strp=[strp, num2str(paramRunApp.reRunPARAFAC.parafacOpt(ii)),' '];
            end
            strp(end) = ']';
            datTab{end + 1}= strp;
            strp=['['];
            for ii=1:length(paramRunApp.reRunPARAFAC.parafacConst)
                strp=[strp, num2str(paramRunApp.reRunPARAFAC.parafacConst(ii)),' '];
            end
            strp(end) = ']';
            datTab{end + 1}= strp;
            datTab{end+1}=num2str(paramRunApp.reRunPARAFAC.parafacPrctRemove);
            datTab{end+1}=paramRunApp.reRunPARAFAC.centerData;
        else
            datTab = [];
            strp=['[1]'];
            datTab{1}= strp;
            if paramRunApp.parafacPrctRemove > 0
                datTab{end+1}= '1'; %%% the first run
            end
            datTab{end+1}='yes';
            datTab{end+1}=num2str(paramRunApp.numFactors-length(eval(strp)));
            strp=[];
            strp=['['];
            for ii=1:length(paramRunApp.parafacOpt)
                strp=[strp, num2str(paramRunApp.parafacOpt(ii)),' '];
            end
            strp(end) = ']';
            datTab{end + 1}= strp;
            strp=['['];
            for ii=1:length(paramRunApp.parafacConst)
                strp=[strp, num2str(paramRunApp.parafacConst(ii)),' '];
            end
            strp(end) = ']';
            datTab{end + 1}= strp;
            datTab{end+1}=num2str(paramRunApp.parafacPrctRemove);
            datTab{end+1}='no';
        end
end

%%%% show table 
datTab=[rowName' , datTab']; 
set(handles.tableParamRemove,'Data',datTab, ... 
    'Columnwidth',{325,300},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  .... 
    'RowName',[],'Visible','on'); 


% --- Executes on button press in removeAtoms.
function removeAtoms_Callback(hObject, eventdata, handles)
% hObject    handle to removeAtoms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

set(handles.pushRunApp,'Visible','off','Value',0);
set(handles.pushSaveParam,'Visible','off','Value',0);
set(handles.pushFinish,'Visible','off','Value',0);
set(handles.pushGoBack,'Visible','off','Value',0);
set(handles.removeAtoms,'Visible','off','Value',0);

switch paramRunApp.genMethod
    case {'NPLS','KPLS'}
        set(handles.reRunPLS,'Visible','on','Value',0);
    case 'PARAFAC'
        set(handles.reRunParafac,'Visible','on','Value',0);
end
if isfield(paramRunApp,'reRunPARAFAC') && isfield(paramRunApp.reRunPARAFAC,'projectType')
    switch paramRunApp.reRunPARAFAC.projectType
        case 'spatial'
            set(handles.rbSpatial,'Visible','on','Value',1);
            set(handles.rbAll,'Visible','on','Value',0);
        case 'allmodes'
            set(handles.rbSpatial,'Visible','on','Value',0);
            set(handles.rbAll,'Visible','on','Value',1);
    end
else
    set(handles.rbSpatial,'Visible','on','Value',0);
    set(handles.rbAll,'Visible','on','Value',1);
end
set(handles.cancelReRun,'Visible','on','Value',0);
[handles] = setRemoveAtomsParamTable(handles); 
 
guidata(hObject,handles) 

% --- Executes on button press in reRunPLS.
function reRunPLS_Callback(hObject, eventdata, handles)
% hObject    handle to reRunPLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp
global resPLS 


datTab=get(handles.tableParamRemove,'Data'); 


if get(handles.rbSpatial,'Value')
    paramRunApp.reRunPLS.projectType   = 'spatial'; 
else get(handles.rbAll,'Value')
    paramRunApp.reRunPLS.projectType   = 'allmodes'; 
end



runS = true;

switch paramRunApp.genMethod
    case {'NPLS','KPLS'}        
        ss=datTab{1,2};
        %paramRunApp.reRunPLS.atomsRemove   = eval(ss);   
        paramRunApp.reRunPLS.atomsKeep   = eval(ss); 
end 

%%% --- begin modifications ---
% save after plots

if runS
    %if strcmp(paramRunApp.genMethod,'PARAFAC')
%     if strfind(paramRunApp.fileName,'data_GenerateSets_')
%         strFile=strcat('./Results/removedAtoms_res',paramRunApp.genMethod,'_',paramRunApp.fileName(19:end));
%     else
%         strFile=strcat('./Results/removedAtoms_res',paramRunApp.genMethod);
%     end
%     [fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
%         'Save results as ...',strFile);
%     pathName=getRelPath(pathName);
%     
%     if pathName
%         %hW=warndlg('Working ..... ');
%         if fName
%             paramRunApp.reRunPLS.resultsName = strcat(pathName,fName);
%         else
%             paramRunApp.reRunPLS.resultsName = [];
%         end
        [hF,res1]=reRunPLS(resPLS,paramRunApp);
        
%     end
    %end
else
    set(handles.reRunPLS,'Value',0);
end

%%% --- end modifications ---


guidata(hObject,handles) 

% --- Executes on button press in reRunParafac.
function reRunParafac_Callback(hObject, eventdata, handles)
% hObject    handle to reRunParafac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%% get sel parameters (from table) 
global paramRunApp
global resPARAFAC 

if get(handles.rbSpatial,'Value')
    paramRunApp.reRunPARAFAC.projectType   = 'spatial'; 
else get(handles.rbAll,'Value')
    paramRunApp.reRunPARAFAC.projectType   = 'allmodes'; 
end

datTab=get(handles.tableParamRemove,'Data'); 

runS = true;


switch paramRunApp.genMethod
    case {'PARAFAC'}   
        ss=datTab{1,2};
        paramRunApp.reRunPARAFAC.atomsRemove   = eval(ss);               
        if paramRunApp. parafacPrctRemove > 0 
           paramRunApp.reRunPARAFAC.whichRun     = str2double(datTab{2,2});
           if ~(paramRunApp.reRunPARAFAC.whichRun==1 || paramRunApp.reRunPARAFAC.whichRun==2)
               paramRunApp.reRunPARAFAC.whichRun = 1; 
               datTab{2,2}=num2str(paramRunApp.reRunPARAFAC.whichRun); 
               set(handles.tableParamRemove,'Data',datTab);
               hW=warndlg('PARAFAC run can be 1 or 2 only. The value was adjusted to run 1.', 'Adjusted PARAFAC run'); 
               uiwait(hW)  
               runS = false; 
           end 
           paramRunApp.reRunPARAFAC.keepResiduals = datTab{3,2};
           paramRunApp.reRunPARAFAC.numFactors    = str2double(datTab{4,2});
           ss=['[',datTab{5,2},']'];
           paramRunApp.reRunPARAFAC.parafacOpt = eval(ss);
           ss=['[',datTab{6,2},']'];
           paramRunApp.reRunPARAFAC.parafacConst = eval(ss);
           paramRunApp.reRunPARAFAC.parafacPrctRemove = str2double(datTab{7,2});  
           paramRunApp.reRunPARAFAC.centerData= datTab{8,2};
        else            
           paramRunApp.reRunPARAFAC.keepResiduals = datTab{2,2};
           paramRunApp.reRunPARAFAC.numFactors    = str2double(datTab{3,2});
           ss=['[',datTab{4,2},']'];
           paramRunApp.reRunPARAFAC.parafacOpt = eval(ss);
           ss=['[',datTab{5,2},']'];
           paramRunApp.reRunPARAFAC.parafacConst = eval(ss);
           paramRunApp.reRunPARAFAC.parafacPrctRemove = str2double(datTab{6,2});  
           paramRunApp.reRunPARAFAC.centerData= datTab{7,2};
        end 
            
            
        if strcmp(paramRunApp.reRunPARAFAC.keepResiduals,'no')
            d=paramRunApp.numFactors - length(paramRunApp.reRunPARAFAC.atomsRemove);
            if (d < paramRunApp.reRunPARAFAC.numFactors)
                paramRunApp.reRunPARAFAC.numFactors = d; 
                datTab{3,2}=num2str(d); 
                set(handles.tableParamRemove,'Data',datTab); 
                hW=warndlg(['Number of PARAFAC factors was adjusted to ', datTab{3,2}],'Adjusted number of factors'); 
                uiwait(hW)  
                runS = false; 
            end
        end     
end 

%%% --- begin modifications ---
% saving after ploting

if runS
%     if strcmp(paramRunApp.genMethod,'PARAFAC')
%         if strfind(paramRunApp.fileName,'data_GenerateSets_')
%             strFile=strcat('./Results/removedAtoms_res',paramRunApp.genMethod,'_',paramRunApp.fileName(19:end));
%         else
%             strFile=strcat('./Results/removedAtoms_res',paramRunApp.genMethod);
%         end
%         [fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
%             'Save results as ...',strFile);
%         pathName=getRelPath(pathName);
%         
%         if pathName
%             %hW=warndlg('Working ..... ');
%             if fName
%                 paramRunApp.reRunPARAFAC.resultsName = strcat(pathName,fName);
%             else
%                 paramRunApp.reRunPARAFAC.resultsName = [];
%             end
            
            [hF,res1]=reRunPARAFAC(resPARAFAC,paramRunApp);
            
%         end
%     end
else
    set(handles.reRunParafac,'Value',0); 
end 

%%% --- end modifications ---


guidata(hObject,handles) 



% --- Executes on button press in cancelReRun.
function cancelReRun_Callback(hObject, eventdata, handles)
% hObject    handle to cancelReRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushRunApp,'Visible','on','Value',0);
set(handles.pushSaveParam,'Visible','on','Value',0);
set(handles.pushFinish,'Visible','on','Value',0);
set(handles.pushGoBack,'Visible','on','Value',0);
set(handles.removeAtoms,'Visible','on','Value',0);

set(handles.rbSpatial,'Visible','off','Value',0);
set(handles.rbAll,'Visible','off','Value',0);
set(handles.reRunParafac,'Visible','off','Value',0);
set(handles.reRunPLS,'Visible','off','Value',0);
set(handles.cancelReRun,'Visible','off','Value',0);
set(handles.tableParamRemove,'Visible','off');
set(handles.textDefParam1,'Visible','off');

guidata(hObject,handles) 


% --- Executes on button press in pushLoadRes.
function pushLoadRes_Callback(hObject, eventdata, handles)
% hObject    handle to pushLoadRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp
global resPARAFAC

set(handles.loadFile,'Enable','off'); 
set(handles.loadParam,'Enable','off'); 
set(handles.pushLoadRes,'Enable','off');

% ---- begin modification ----
% added buton for plotting results
set(handles.pushPlotRes, 'Enable', 'off');
% ---- end modification ----

[fileName, pathName] = uigetfile ({'./Results/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if fileName
    %%% load parameters
    strF=strcat(pathName,fileName);
    warning off
    s=load(strF,'param','res');
    warning on
    
    if strcmp(s.param.genMethod,'PARAFAC')
        
        if ~isfield(s,'param') && ~isfield(s,'res')
            hE=msgbox([fileName,' is not a correct results''s file'],'Error - not results''s file','error');
            uiwait(hE);
            set(handles.loadFile,'Enable','on');
            set(handles.loadParam,'Enable','on');
            set(handles.pushLoadRes,'Enable','on');
            
            % ---- begin modification ----
            % added buton for plotting results
            set(handles.pushPlotRes, 'Enable', 'on');
            % ---- end modification ----
        else
            paramRunApp=s.param;
            resPARAFAC =s.res;
            set(handles.loadParam,'Visible','off');
            %set(handles.loadFile,'Visible','off');
            
            %%%% reset parameters to run new file
            hNames=fieldnames(handles);
            %%%%% resetting values
            %%%% clear some properties
            for i=1:length(hNames)
                if ~((strcmp(hNames{i},'figure1')) | (strcmp(hNames{i},'File')) | ...
                        (strcmp(hNames{i},'Open')) | (strcmp(hNames{i},'output')))
                    hTmp=strcat('handles.',hNames{i});
                    if isprop(eval(hTmp),'Visible')
                        set(eval(hTmp),'Visible','off')
                    end
                    if isprop(eval(hTmp),'Value')
                        set(eval(hTmp),'Value',0)
                    end
                    if isprop(eval(hTmp),'UserData')
                        set(eval(hTmp),'UserData',[])
                    end
                end
            end
            
            %%%% set file print
            %%%% load header
            strF=strcat(paramRunApp.pathName,paramRunApp.fileName);
            warning off
            if isunix || ismac %%% change all \ to / 
                strF(strfind(strF,'\'))='/'; 
            end 
            load(strF,'header')
            warning on
            handles = printfileText(handles, paramRunApp.fileName, header);
            %%%%  menu
            set(handles.pushRunApp,'Visible','on');
            set(handles.pushSaveParam,'Visible','on');
            set(handles.pushFinish,'Visible','on');
            set(handles.pushGoBack,'Visible','on');
            set(handles.topPanel,'Visible','on');
            set(handles.removeAtoms,'Visible','on','Value',0);
            %%%%% print right text panel
            %%%% fcn right panel print
            handles = printRightPanel(paramRunApp, handles);
            
            if isfield(paramRunApp,'Xlabels2use') && length(paramRunApp.Xlabels2use) ~= length(paramRunApp.Xlabels)
                strR1FT(1) = {'Variables to use: '};
                nstr=[];
                for i=1:length(paramRunApp.Xlabels2use)
                    nstr = [nstr,paramRunApp.Xlabels2use{i},','];
                end
                strR1FT(2)={nstr(1:end-1)};
            else
                strR1FT(1) ={'Variables to use: all'};
            end
            strR1FT(3)={'--------------------------------'};
            if isfield(paramRunApp,'plotFileName')
                strR1FT(4)={paramRunApp.plotFileName};
            end
            set(handles.fileTextR1,'Visible','on','String',strR1FT);
        end
    else
        hE=msgbox([fileName,' At the moment works for PARAFAC only'],'Error - not PARAFAC','error');
        uiwait(hE);
        set(handles.loadFile,'Enable','on');
        set(handles.loadParam,'Enable','on');
        set(handles.pushLoadRes,'Enable','on');
        
        % ---- begin modification ----
        % added buton for plotting results
        set(handles.pushPlotRes, 'Enable', 'on');
        % ---- end modification ----
    end
    
else
    set(handles.loadFile,'Enable','on');
    set(handles.loadParam,'Enable','on');
    set(handles.pushLoadRes,'Enable','on');
    
    % ---- begin modification ----
    % added buton for plotting results
    set(handles.pushPlotRes, 'Enable', 'on');
    % ---- end modification ----
end

guidata(hObject,handles)


% --- Executes on button press in rbSpatial.
function rbSpatial_Callback(hObject, eventdata, handles)
% hObject    handle to rbSpatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp


if get(handles.rbSpatial,'Value')
    set(handles.rbSpatial,'Visible','on','Value',1);
    set(handles.rbAll,'Visible','on','Value',0);
else
    set(handles.rbSpatial,'Visible','on','Value',0);
    set(handles.rbAll,'Visible','on','Value',1);
end
guidata(hObject,handles)



% --- Executes on button press in rbAll.
function rbAll_Callback(hObject, eventdata, handles)
% hObject    handle to rbAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramRunApp

if get(handles.rbAll,'Value')
    set(handles.rbSpatial,'Visible','on','Value',0);
    set(handles.rbAll,'Visible','on','Value',1);
else
    set(handles.rbSpatial,'Visible','on','Value',1);
    set(handles.rbAll,'Visible','on','Value',0);
end
guidata(hObject,handles)





% ---- begin modification ----
% added button for plotting PARAFAC results

% --- Executes on button press in pushPlotRes.
function pushPlotRes_Callback(hObject, eventdata, handles)
% hObject    handle to pushPlotRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.loadFile,'Enable','off'); 
set(handles.loadParam,'Enable','off'); 
set(handles.pushLoadRes,'Enable','off');
set(handles.pushPlotRes, 'Enable', 'off');

[fileName, pathName] = uigetfile ({'./Results/*.mat'},'Open File');
pathName=getRelPath(pathName);

if fileName
    %%% load parameters and data
    strF=strcat(pathName,fileName);
    warning off
    s=load(strF);
    warning on
    
    if ~isfield(s,'param')
        hE=msgbox([fileName,' is not a correct results''s file'],'Error - not results''s file','error');
        uiwait(hE);
        
        set(handles.loadFile,'Enable','on');
        set(handles.loadParam,'Enable','on');
        set(handles.pushLoadRes,'Enable','on');
        set(handles.pushPlotRes, 'Enable', 'on');
    else
        
        if ~strcmp(s.param.genMethod, 'PARAFAC')
            hE=msgbox([fileName,' Not sure if it works for other than PARAFAC'],'Error - not PARAFAC','error');
            uiwait(hE);
            
            set(handles.loadFile,'Enable','on');
            set(handles.loadParam,'Enable','on');
            set(handles.pushLoadRes,'Enable','on');
            set(handles.pushPlotRes, 'Enable', 'on');
        else
            
            if ~isfield(s,'res1')
                
                if ~isfield(s,'res')
                    hE=msgbox([fileName,' is not a correct results''s file'],'Error - not results''s file','error');
                    uiwait(hE);
                    
                    set(handles.loadFile,'Enable','on');
                    set(handles.loadParam,'Enable','on');
                    set(handles.pushLoadRes,'Enable','on');
                    set(handles.pushPlotRes, 'Enable', 'on');
                else
                    fN=strcat(s.param.pathName,s.param.fileName);
                    
                    [hE]=plotControl({'parafac'}, s.param, s.res, fN);
                    uiwait(hE)
                    
                    set(handles.loadFile,'Enable','on');
                    set(handles.loadParam,'Enable','on');
                    set(handles.pushLoadRes,'Enable','on');
                    set(handles.pushPlotRes, 'Enable', 'on');
                end
                
            else
                fN=strcat(s.param.pathName,s.param.fileName);
                
                s.param.numFactors = s.param.reRunPARAFAC.numFactors;
                
                [hE]=plotControl({'parafac'}, s.param, s.res1, fN);
                uiwait(hE)
                
                set(handles.loadFile,'Enable','on');
                set(handles.loadParam,'Enable','on');
                set(handles.pushLoadRes,'Enable','on');
                set(handles.pushPlotRes, 'Enable', 'on');
            end
            
        end
        
    end
    
else
    set(handles.loadFile,'Enable','on');
    set(handles.loadParam,'Enable','on');
    set(handles.pushLoadRes,'Enable','on');
    set(handles.pushPlotRes, 'Enable', 'on');
    
end










