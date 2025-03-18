function varargout = APECSgui(varargin)
% APECSGUI MATLAB code for APECSgui.fig
%      APECSGUI, by itself, creates a new APECSGUI or raises the existing
%      singleton*.
%
%      H = APECSGUI returns the handle to a new APECSGUI or the handle to
%      the existing singleton*.
%
%      APECSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APECSGUI.M with the given input arguments.
%
%      APECSGUI('Property','Value',...) creates a new APECSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before APECSgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to APECSgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help APECSgui

% Last Modified by GUIDE v2.5 25-Oct-2012 20:21:21

% Begin initialization code - DO NOT EDIT

%%%% add path 
clc
addpath(genpath(pwd))


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @APECSgui_OpeningFcn, ...
                   'gui_OutputFcn',  @APECSgui_OutputFcn, ...
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


% --- Executes just before APECSgui is made visible.
function APECSgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to APECSgui (see VARARGIN)

%clear mainFig
%global mainFig

%mainFig.runGenSet     = handles.runGenSet; 
%mainFig.runPreProcess = handles.runPreProcess; 
%%%% move window a bit 
set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.15 0.3 0.6 0.6]); 

%set(0,'units','pixels') 
%scrRes = get( 0, 'ScreenSize' ); 
%set(handles.figure1,'units','pixels','Position',[0.1*scrRes(3) 0.1*scrRes(4) 0.7*scrRes(3) 0.8*scrRes(4)]); 

% pos=get(handles.figure1,'Position');
% pos(1)=100; 
% pos(2)=150;
% set(handles.figure1,'Position',pos);
% 


pacdel = imread('./M-files/Pictures/italy.jpg');
axis off          % Remove axis ticks and numbers
ha = axes('units','normalized','position',[0 0 1 1]);
imagesc(pacdel)
set(ha,'handlevisibility','off', 'visible','off')

% Choose default command line output for APECSgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes APECSgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = APECSgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runPreProcess.
function runPreProcess_Callback(hObject, eventdata, handles)
% hObject    handle to runPreProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.runPreProcess,'Value',0); 
%set(handles.runGenSet,'Enable','off'); 

gui_preProcessRaw;


guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of runPreProcess


% --- Executes on button press in runGenFeatures.
function runGenFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to runGenFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global mainFig 

set(handles.runGenFeatures,'Value',0); 

gui_genFeatures;

guidata(hObject,handles)



% --- Executes on button press in runGenSet.
function runGenSet_Callback(hObject, eventdata, handles)
% hObject    handle to runGenSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global mainFig 

set(handles.runGenSet,'Value',0); 

gui_genSets;

guidata(hObject,handles)



% --- Executes on button press in runApp.
function runApp_Callback(hObject, eventdata, handles)
% hObject    handle to runApp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global mainFig 

set(handles.runApp,'Value',0); 

gui_runApp;

guidata(hObject,handles)


% --------------------------------------------------------------------
function popTools_Callback(hObject, eventdata, handles)
% hObject    handle to popTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pop2EDF_Callback(hObject, eventdata, handles)
% hObject    handle to pop2EDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_2EDF;

guidata(hObject,handles)

% --------------------------------------------------------------------
function popSaveWeights_Callback(hObject, eventdata, handles)
% hObject    handle to popSaveWeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_BCI2000;

guidata(hObject,handles)
