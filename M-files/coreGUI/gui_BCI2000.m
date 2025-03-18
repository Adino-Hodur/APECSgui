function varargout = gui_BCI2000(varargin)
% GUI_BCI2000 MATLAB code for gui_BCI2000.fig
%      GUI_BCI2000, by itself, creates a new GUI_BCI2000 or raises the existing
%      singleton*.
%
%      H = GUI_BCI2000 returns the handle to a new GUI_BCI2000 or the handle to
%      the existing singleton*.
%
%      GUI_BCI2000('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_BCI2000.M with the given input arguments.
%
%      GUI_BCI2000('Property','Value',...) creates a new GUI_BCI2000 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_BCI2000_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_BCI2000_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_BCI2000

% Last Modified by GUIDE v2.5 12-May-2012 20:11:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_BCI2000_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_BCI2000_OutputFcn, ...
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


% --- Executes just before gui_BCI2000 is made visible.
function gui_BCI2000_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_BCI2000 (see VARARGIN)
clear global
global paramBCI

% Choose default command line output for gui_BCI2000
handles.output = hObject;

set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.4 0.5 0.4 0.4]); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_BCI2000 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_BCI2000_OutputFcn(hObject, eventdata, handles) 
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
global paramBCI

set(handles.loadFile,'Enable','off');
    
[fileName, pathName] = uigetfile ({'./Results/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if fileName    
    %%% load header file
    strF=strcat(pathName,fileName);
    warning off 
    load(strF)
    warning on 
    if strcmp(param.genMethod,'KPLS') && strcmp(param.kernelFcn,'Linear')
        Method='linPLS';
    else 
        Method=param.genMethod;
    end
    switch Method
        case{'NPLS','linPLS'}
            if ~exist('res','var')
                hE=errordlg('''res'' structure not present in the file ...','Error - header missing');
                uiwait(hE);
                set(handles.loadFile,'Enable','on');
            else                
                paramBCI             = res;
                %%% for controling saving                 
                paramBCI.saveOKbci = false;
                paramBCI.saveOKxls = false;
                
                paramBCI.fileName    = fileName;
                paramBCI.pathName    = pathName;
                paramBCI.Method      = param.genMethod;
                paramBCI.featureAll  = param.fLines;
                paramBCI.featureIn   = param.fLines(param.fLinesInd2use);
                paramBCI.varUsed     = param.var2use; 
                if isfield(param,'Xlabels2use')                    
                    paramBCI.varLabels = param.Xlabels2use;
                end
                if isfield(param,'numFactors')
                    paramBCI.numFactors = param.numFactors;
                end
                if strcmp(paramBCI.Method,'KPLS')
                    paramBCI.kernelFcn=param.kernelFcn; 
                end 
                                
                handles = printfileText(handles,paramBCI);
                set(handles.loadFile,'Visible','off')
                set(handles.pushOK1,'Visible','on')
                set(handles.radBCI2000,'Visible','on','Value',1)
                set(handles.radXLS,'Visible','on','Value',1)
                set(handles.topPanel,'Visible','on')                
            end
        otherwise
            if strcmp(Method,'KPLS')
                hE=errordlg(['Error !!! ... nonlinear ', Method, ' method was selected. ' ...
                    'Only weights for linear KPLS can be saved.'],'Wrong method');
            else
                hE=errordlg(['Error !!! ... ', Method, ' method was selected. ' ...
                    'Weights for this model can''t be saved.'],'Wrong method');
            end
            uiwait(hE);
            set(handles.loadFile,'Enable','on')
    end      
else 
   set(handles.loadFile,'Enable','on')
end

guidata(hObject,handles) 



% --- Executes on button press in pushOK.
function pushOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramBCI

set(handles.pushOK,'Enable','off');
set(handles.setFacSave,'Enable','off');
set(handles.radLab,'Enable','off');
set(handles.radBin,'Enable','off');

paramBCI.numFac2Save=str2double(get(handles.setFacSave,'String'));
if paramBCI.numFac2Save > size(paramBCI.Xfactors{1},2)
    hE=errordlg(['Error: Model with max. number of ', num2str(size(paramBCI.Xfactors{1},2)), ... 
                 ' factors can be extracted']);
    uiwait(hE)    
    set(handles.setFacSave,'Enable','on','String',num2str(size(paramBCI.Xfactors{1},2)));    
    set(handles.pushOK,'Enable','on','Value',0);
    set(handles.radLab,'Enable','on');
    set(handles.radBin,'Enable','on');
    guidata(hObject,handles) 
else    
    set(handles.setFacSave,'Enable','off');    
    set(handles.pushOK,'Enable','off','Value',0);
    set(handles.radLab,'Enable','off');
    set(handles.radBin,'Enable','off');
    
    if ~get(handles.radBCI2000,'Value')
        paramBCI.saveOKbci = true; 
    end 
    if ~get(handles.radXLS,'Value')
        paramBCI.saveOKxls = true;
    end
                   
    if get(handles.radBCI2000,'Value') && (paramBCI.saveOKbci == false)         
        [fName, pathName] = uiputfile( {'*.txt','Text File'}, ...
            'Save BCI2000 weights parameters as ...',['./Weights_BCI2000_xls/BCI2000_weights_', ...
            paramBCI.fileName(1:end-4),'_',num2str(paramBCI.numFac2Save),'factorsModel.txt']);
                                 
        if pathName
            pathName=getRelPath(pathName);
            
            if get(handles.radBin,'Value')
                typeOut = 'bin';
            end
            if get(handles.radLab,'Value')
                typeOut = 'labelHz';
            end
                        
            fH = getWeights4BCI2000([pathName,fName],typeOut,paramBCI);
            if ~fH
                paramBCI.saveOKbci = true; 
            else 
                paramBCI.saveOKbci = false; 
            end 
        else
            paramBCI.saveOKbci = false; 
        end
    end 
    
    if get(handles.radXLS,'Value') && (paramBCI.saveOKxls == false)  
        [fName, pathName] = uiputfile( {'*.xls','Excel File'}, ...
            'Save weights parameters as excel file...',['./Weights_BCI2000_xls/weights_', ...
            paramBCI.fileName(1:end-4),'_',num2str(paramBCI.numFac2Save),'factorsModel.xls']);
        
        if pathName
            pathName=getRelPath(pathName);
            
            fH = saveWeights2xls([pathName,fName],paramBCI);            
            if ~fH                
                paramBCI.saveOKxls = true; 
            else
                paramBCI.saveOKxls = false;
            end 
        else
            paramBCI.saveOKbci = false; 
        end        
    end

    
    if (paramBCI.saveOKbci == true)  && (paramBCI.saveOKbci == true)
        close(handles.figure1);
    else 
        set(handles.pushOK,'Enable','on');
        set(handles.setFacSave,'Enable','on');
        set(handles.radLab,'Enable','on');
        set(handles.radBin,'Enable','on');
        guidata(hObject,handles) 
    end 
    
end
 

 



function setFacSave_Callback(hObject, eventdata, handles)
% hObject    handle to setFacSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setFacSave as text
%        str2double(get(hObject,'String')) returns contents of setFacSave as a double


% --- Executes during object creation, after setting all properties.
function setFacSave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setFacSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject,handles) 

% --- Executes on button press in radBin.
function radBin_Callback(hObject, eventdata, handles)
% hObject    handle to radBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radLab,'Value')
    set(handles.radLab,'Value',0);
end 
guidata(hObject,handles) 



% --- Executes on button press in radLab.
function radLab_Callback(hObject, eventdata, handles)
% hObject    handle to radLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radBin,'Value')
    set(handles.radBin,'Value',0);
end
guidata(hObject,handles) 


% --- Executes on button press in radBCI2000.
function radBCI2000_Callback(hObject, eventdata, handles)
% hObject    handle to radBCI2000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in radXLS.
function radXLS_Callback(hObject, eventdata, handles)
% hObject    handle to radXLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushOK1.
function pushOK1_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramBCI

if get(handles.radBCI2000,'Value') || get(handles.radXLS,'Value')
    set(handles.pushOK1,'Visible','off')
    set(handles.radBCI2000,'Visible','off')
    set(handles.radXLS,'Visible','off')
    
    set(handles.pushOK,'Visible','on')
    set(handles.topPanel,'Visible','on')
    set(handles.textFacSave,'Visible','on')
    set(handles.setFacSave,'Visible','on','String',num2str(paramBCI.numFactors))
    if get(handles.radBCI2000,'Value')
        set(handles.textBCI2000,'Visible','on');
        set(handles.radLab,'Visible','on','Value',0);
        set(handles.radBin,'Visible','on','Value',1);
    end
    
else
    hE=errordlg('None saving weights file selected .... nothing to do!!!') 
    uiwait(hE)
end
guidata(hObject,handles) 


function handles = printfileText(handles, param)
%strFT(1)={'Results of: '};
strFT(1)={['file name: ' param.fileName]};
strFT(2)={['method used: ' param.Method]};
if isfield(param,'kernelFcn')
    strFT(end+1)={['kernel function: ' param.kernelFcn]};
end
if isfield(param,'numFactors')
    strFT(end+1)={['total number of factors: ' num2str(param.numFactors)]};
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
