function varargout = gui_2EDF(varargin)
% GUI_2EDF MATLAB code for gui_2EDF.fig
%      GUI_2EDF, by itself, creates a new GUI_2EDF or raises the existing
%      singleton*.
%
%      H = GUI_2EDF returns the handle to a new GUI_2EDF or the handle to
%      the existing singleton*.
%
%      GUI_2EDF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_2EDF.M with the given input arguments.
%
%      GUI_2EDF('Property','Value',...) creates a new GUI_2EDF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_2EDF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_2EDF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_2EDF

% Last Modified by GUIDE v2.5 04-Nov-2012 01:47:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_2EDF_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_2EDF_OutputFcn, ...
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


% --- Executes just before gui_2EDF is made visible.
function gui_2EDF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_2EDF (see VARARGIN)
clear global
global paramEDF

% Choose default command line output for gui_2EDF
handles.output = hObject;


set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.4 0.5 0.4 0.4]); 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_2EDF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_2EDF_OutputFcn(hObject, eventdata, handles) 
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
global paramEDF

set(handles.loadFile,'Enable','off');
    
[fileName, pathName] = uigetfile ({'./Results/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if fileName    
    %%% load header file
    strF=strcat(pathName,fileName);
    warning off 
    load(strF,'param')
    warning on 
    paramEDF.fileName    = fileName;
    paramEDF.pathName    = pathName;
    paramEDF.Method      = param.genMethod;
    paramEDF.varUsed     = param.var2use; 
    paramEDF.freqIn2use  = param.freqIn2use;  
    if isfield(param,'Xlabels2use')
        paramEDF.varLabels = param.Xlabels2use;
    end
    if isfield(param,'numFactors')
        if isfield(param,'reRunPARAFAC')
            paramEDF.numFactors = param.reRunPARAFAC.numFactors;
        else
            paramEDF.numFactors = param.numFactors;
        end
    end
    if strcmp(paramEDF.Method,'KPLS')
        paramEDF.kernelFcn=param.kernelFcn;
    end
    set(handles.loadFile,'Visible','off')
    handles = printfileText(handles,paramEDF);
    
    switch paramEDF.Method
        case {'PARAFAC'}
            set(handles.panelFac,'Visible','on')
            %%% do table here
            numVar = paramEDF.numFactors;
            for i=1:numVar
                tabLab{i}=num2str(i);
                tabValues(i) = true;
            end
            set(handles.okTab1,'Visible','on') 
            set(handles.allFac,'Visible','on')
            set(handles.desFac,'Visible','on')
            set(handles.canTab,'Visible','on')
            set(handles.tabFac,'parent',handles.panelFac,'Data',tabValues, ...
                'RowName',{'on/off'},'ColumnFormat', {'logical'}, ...
                'ColumnName',tabLab, ...
                'ColumnEditable',true(1,numVar),'Visible','on');
        case {'NPLS'}
            set(handles.editNumNPLS,'Visible','on','String',[])
            set(handles.textNumNPLS,'Visible','on',... 
                 'String',['Define order of NPLS. (max. order ',num2str(paramEDF.numFactors),')'])
    end
else 
   set(handles.loadFile,'Enable','on')
end

guidata(hObject,handles) 



% --- Executes on button press in pushEpochData.
function pushEpochData_Callback(hObject, eventdata, handles)
% hObject    handle to pushEpochData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF

set(handles.pushEpochData,'Enable','off');
    
[fileNameE, pathNameE] = uigetfile ({'./Data/EpochedData/*.mat'},'Open File','MultiSelect','on'); 
pathNameE=getRelPath(pathNameE); 

if ~iscell(fileNameE)
    if fileNameE
        fileNameE=cellstr(fileNameE);
    end
end

if iscell(fileNameE)
    %%% load header file
    strF=strcat(pathNameE,fileNameE{1});
    warning off
    load(strF,'header')
    warning on
    for f=1:length(fileNameE)
        paramEDF.fileNameE{f}  = fileNameE{f};
    end
    paramEDF.pathNameE       = pathNameE;
    paramEDF.sampleFreq      = header.sampleFreq;
    paramEDF.sampleFreqUnit  = header.sampleFreqUnit;
    set(handles.pushEpochData,'Visible','off')
    set(handles.sep2,'Visible','on')
    handles = printfileTextE(handles,paramEDF);
    set(handles.pushFeatureData,'Visible','on')
else
    set(handles.pushEpochData,'Enable','on')
end

guidata(hObject,handles) 

% --- Executes on button press in pushFeatureData.
function pushFeatureData_Callback(hObject, eventdata, handles)
% hObject    handle to pushFeatureData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF

set(handles.pushFeatureData,'Enable','off');
    
[fileNameF, pathNameF] = uigetfile ({'./Data/FeaturesData/*.mat'},'Open File'); 
pathNameF=getRelPath(pathNameF); 

if fileNameF    
    %%% load header file
    strF=strcat(pathNameF,fileNameF);
    warning off 
    load(strF,'header')
    warning on 
    paramEDF.fileNameF       = fileNameF;
    paramEDF.pathNameF       = pathNameF;
    paramEDF.featureType     = header.featureType;
    paramEDF.psdMethod       = header.psdMethod;
   
    set(handles.pushFeatureData,'Visible','off')
    set(handles.sep3,'Visible','on')
    handles = printfileTextF(handles,paramEDF);   
    set(handles.pushSave,'Visible','on')
else 
   set(handles.pushFeatureData,'Enable','on')
end

guidata(hObject,handles)

% --- Executes on button press in pushSave.
function pushSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF

switchS = false; 
if length(paramEDF.fileNameE)==1
    [paramEDF.fNameS, paramEDF.pathNameS] = uiputfile( {'*.edf','EDF File'}, ...
        'Define name for EDF file',['./EDF/',paramEDF.fileNameE{1}(1:end-4),'.edf']);
    paramEDF.pathNameS=getRelPath(paramEDF.pathNameS);
    if paramEDF.fNameS
        switchS = true; 
        paramEDF.fNameS=cellstr(paramEDF.fNameS); 
    end 
else 
    paramEDF.fNameS=paramEDF.fileNameE;
    paramEDF.pathNameS='./EDF/';
    switchS = true; 
end

if switchS % paramEDF.fNameS
    if ~paramEDF.pathNameS
        paramEDF.pathNameS='./EDF/';
    end
    res2edf(paramEDF); 
    set(handles.pushSave,'Visible','off')
    stP=['File was saved to ',paramEDF.pathNameS,paramEDF.fNameS{1}]; 
    for f=2:length(paramEDF.fNameS)
        stP=[stP,', ',paramEDF.fNameS{f}]; 
    end 
    set(handles.textSave,'Visible','on','String',cellstr(stP));
    hM=msgbox('Great !!! File(s) were generated and saved.','File saved');
    uiwait(hM);
    close(handles.figure1);
end
        
 

% --- Executes on button press in okTab1.
function okTab1_Callback(hObject, eventdata, handles)
% hObject    handle to okTab1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF 

set(handles.panelFac,'Visible','off')


datV = get(handles.tabFac,'Data'); 
fac  = [1:paramEDF.numFactors]; 
fac  = fac(datV); 
if length(fac) ~= paramEDF.numFactors;
    paramEDF.fac2use = fac;
end

handles = printfileText(handles,paramEDF);  
    
set(handles.sep1,'Visible','on')
set(handles.pushEpochData,'Visible','on')
guidata(hObject,handles)


% --- Executes on button press in allFac.
function allFac_Callback(hObject, eventdata, handles)
% hObject    handle to allFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF

numVar = paramEDF.numFactors;
for i=1:numVar
    tabLab{i}=num2str(i);
    tabValues(i) = true;
end
set(handles.tabFac,'parent',handles.panelFac,'Data',tabValues, ...
    'RowName',{'on/off'},'ColumnFormat', {'logical'}, ...
    'ColumnName',tabLab, ...
    'ColumnEditable',true(1,numVar),'Visible','on');

guidata(hObject,handles)

    
   
% --- Executes on button press in desFac.
function desFac_Callback(hObject, eventdata, handles)
% hObject    handle to desFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF

numVar = paramEDF.numFactors;
for i=1:numVar
    tabLab{i}=num2str(i);
    tabValues(i) = false;
end
set(handles.tabFac,'parent',handles.panelFac,'Data',tabValues, ...
    'RowName',{'on/off'},'ColumnFormat', {'logical'}, ...
    'ColumnName',tabLab, ...
    'ColumnEditable',true(1,numVar),'Visible','on');

guidata(hObject,handles)


% --- Executes on button press in canTab.
function canTab_Callback(hObject, eventdata, handles)
% hObject    handle to canTab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramEDF 

set(handles.panelFac,'Visible','off')

handles = printfileText(handles,paramEDF);  
    
set(handles.sep1,'Visible','on')
set(handles.pushEpochData,'Visible','on')
guidata(hObject,handles)



function handles = printfileText(handles, param)
strFT(1)={'Results'};
strFT(2)={'------------'};
strFT(3)={['file name: ' param.fileName]};
strFT(4)={['method used: ' param.Method]};
if isfield(param,'kernelFcn')
    strFT(end+1)={['kernel function: ' param.kernelFcn]};
end
if isfield(param,'numFactors')
    strFT(end+1)={['total number of factors: ' num2str(param.numFactors)]};
end 
if isfield(param,'numNPLS2use')
    strFT(end+1)={['factors to use (up to): ' num2str(param.numNPLS2use)]};
end
strP='factors to use: ';
if isfield(param,'fac2use')
    for i=1:length(param.fac2use)
        strP = [strP,num2str(param.fac2use(i)),', '];
    end 
    strFT{end+1}=strP(1:end-2);
elseif ~isfield(param,'numNPLS2use') 
    strFT(end+1)={[strP,'all']};
end 
if isfield(param,'varLabels')
    ppStr=param.varLabels;
    pStr='used variables: ';
    for sI=1:length(ppStr)
        pStr=[pStr,ppStr{sI},','];
    end
    strFT{end+1}=pStr(1:end-1);    
end

set(handles.fileText,'Visible','on','String',strFT);


function handles = printfileTextE(handles, param)
strFT(1)={'Data file'};
strFT(2)={'------------'};

strP=['file name: ' param.fileNameE{1}];
for f=2:length(param.fileNameE)
    strP =[strP,', ' param.fileNameE{f}];
end
strFT{3}=strP;

strFT(4)={['sample freq.: ' num2str(param.sampleFreq) param.sampleFreqUnit]};


set(handles.fileTextE,'Visible','on','String',strFT);


function handles = printfileTextF(handles, param)
strFT(1)={'Feature file'};
strFT(2)={'------------'};
strFT(3)={['file name: ' param.fileNameF]};
strFT(4)={['features type: ' param.featureType]};

set(handles.fileTextF,'Visible','on','String',strFT);



function editNumNPLS_Callback(hObject, eventdata, handles)
% hObject    handle to editNumNPLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumNPLS as text
%        str2double(get(hObject,'String')) returns contents of editNumNPLS as a double
global paramEDF

nsf=str2double(get(handles.editNumNPLS,'String'));
if isfloat(nsf) && nsf > 0 && nsf <= paramEDF.numFactors
    paramEDF.numNPLS2use = nsf; 
    set(handles.editNumNPLS,'Visible','off','String',[]);
    set(handles.textNumNPLS,'Visible','off','String',[]);
    set(handles.sep1,'Visible','on')
    set(handles.pushEpochData,'Visible','on'); 
    handles = printfileText(handles,paramEDF);
end


guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function editNumNPLS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumNPLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
