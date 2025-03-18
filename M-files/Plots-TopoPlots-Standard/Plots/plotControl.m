function varargout = plotControl(varargin)
% PLOTCONTROL MATLAB code for plotControl.fig
%      PLOTCONTROL, by itself, creates a new PLOTCONTROL or raises the existing
%      singleton*.
%
%      H = PLOTCONTROL returns the handle to a new PLOTCONTROL or the handle to
%      the existing singleton*.
%
%      PLOTCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTCONTROL.M with the given input arguments.
%
%      PLOTCONTROL('Property','Value',...) creates a new PLOTCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotControl

% Last Modified by GUIDE v2.5 18-Jul-2016 16:51:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotControl_OpeningFcn, ...
                   'gui_OutputFcn',  @plotControl_OutputFcn, ...
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


% --- Executes just before plotControl is made visible.
function plotControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotControl (see VARARGIN)

% --- Peter -- modification made:
% switched from global variable to field of handles structure

handles.typePlot = varargin{1}; 

switch handles.typePlot{1}(1:end)
    case 'parafac'
        set(handles.pltPredictions,'Visible','off');
    case 'nkpls'
        set(handles.pltAtoms,'Visible','off');
        set(handles.pltTopoMap,'Visible','off');
        set(handles.pltCoreConsist,'Visible','off');
    case {'npls','pca'}
        set(handles.pltCoreConsist,'Visible','off');
end

% ---- begin modification ----
% store additional variables needed for plotting
handles.prm = varargin{2};
handles.rs = varargin{3};
handles.fn = varargin{4};
% ---- end modification ----

% Choose default command line output for plotControl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushPlot.
function pushPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%% set control plot to zero first 
controlPlot=zeros(1,10); 

switch handles.typePlot{1}(1:end)
    case 'pca'        
        controlPlot(2)=get(handles.pltAtoms,'Value');
        controlPlot(3)=get(handles.pltPSDAll,'Value');
        controlPlot(4)=get(handles.pltPSDSel,'Value');
        controlPlot(5)=get(handles.pltTopoMap,'Value'); 
        %%%% smoothing param
        controlPlot(10)=str2double(get(handles.smPar,'String')); 
    case 'parafac' 
        controlPlot(1)=get(handles.pltCoreConsist,'Value');
        controlPlot(2)=get(handles.pltAtoms,'Value');
        controlPlot(3)=get(handles.pltPSDAll,'Value');
        controlPlot(4)=get(handles.pltPSDSel,'Value');
        controlPlot(5)=get(handles.pltTopoMap,'Value'); 
        %%%% smoothing param
        controlPlot(10)=str2double(get(handles.smPar,'String')); 
    case 'nkpls'    
        controlPlot(1)=get(handles.pltPredictions,'Value');
        controlPlot(3)=get(handles.pltPSDAll,'Value');
        controlPlot(4)=get(handles.pltPSDSel,'Value');        
        %%%% smoothing param
        controlPlot(10)=str2double(get(handles.smPar,'String'));
    otherwise
        controlPlot(1)=get(handles.pltPredictions,'Value');
        controlPlot(2)=get(handles.pltAtoms,'Value');
        controlPlot(3)=get(handles.pltPSDAll,'Value');
        controlPlot(4)=get(handles.pltPSDSel,'Value');
        controlPlot(5)=get(handles.pltTopoMap,'Value');
        %%%% smoothing param
        controlPlot(10)=str2double(get(handles.smPar,'String')); 
end

% ---- begin modification -----

global hFp
hFp=[];

handles.prm.smoothFac = controlPlot(10);

if controlPlot(1)
    switch handles.prm.genMethod
        case{'NPLS','KPLS'}
            phF = plotNPLS(handles.rs,handles.prm);
        case {'PARAFAC'} 
            phF = plotCoreConsist(handles.rs);
    end
    hFp =[hFp phF];
end
if controlPlot(2)
    switch handles.prm.genMethod
        case{'NPLS','KPLS'}
            phF = plotAtomsNPLS(handles.rs,handles.prm);
        case {'PARAFAC'}
            phF = plotAtomsPARAFAC(handles.rs,handles.prm);
        case {'PCA'}
            phF = plotAtomsPCA(handles.rs,handles.prm);
    end
    hFp =[hFp phF];
end
if controlPlot(3)
    phF = plot_sepSpectra(handles.fn,handles.prm);
    hFp =[hFp phF];
end
if controlPlot(4)
    phF = plot_sepSpectraCent(handles.rs,handles.prm);
    hFp =[hFp phF];
end
if controlPlot(5)
    switch handles.prm.genMethod
        case {'PARAFAC'}
            phF = plot_topoMap(handles.rs,handles.prm,0);
            hFp =[hFp phF];
            if handles.prm.parafacPrctRemove ~= 0
                phF = plot_topoMap(handles.rs,handles.prm,1);
                hFp =[hFp phF];
            end 
        otherwise
            phF = plot_topoMap(handles.rs,handles.prm,0);
            hFp =[hFp phF];
    end
end

% handles.hF = hF;
% % Update handles structure
% guidata(hObject, handles);

% ---- end modification ----
   

% close(handles.figure1)

% --- Executes on button press in pltAtoms.
function pltAtoms_Callback(hObject, eventdata, handles)
% hObject    handle to pltAtoms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltAtoms


% --- Executes on button press in pltPSDAll.
function pltPSDAll_Callback(hObject, eventdata, handles)
% hObject    handle to pltPSDAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltPSDAll


% --- Executes on button press in pltPSDSel.
function pltPSDSel_Callback(hObject, eventdata, handles)
% hObject    handle to pltPSDSel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltPSDSel


% --- Executes on button press in pltTopoMap.
function pltTopoMap_Callback(hObject, eventdata, handles)
% hObject    handle to pltTopoMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltTopoMap


% --- Executes on button press in pltPredictions.
function pltPredictions_Callback(hObject, eventdata, handles)
% hObject    handle to pltPredictions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltPredictions



function smPar_Callback(hObject, eventdata, handles)
% hObject    handle to smPar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smPar as text
%        str2double(get(hObject,'String')) returns contents of smPar as a double


% --- Executes during object creation, after setting all properties.
function smPar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smPar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pltCoreConsist.
function pltCoreConsist_Callback(hObject, eventdata, handles)
% hObject    handle to pltCoreConsist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pltCoreConsist
