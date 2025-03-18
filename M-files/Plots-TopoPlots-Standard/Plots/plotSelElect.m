function varargout = plotSelElect(varargin)
% PLOTSELELECT MATLAB code for plotSelElect.fig
%      PLOTSELELECT, by itself, creates a new PLOTSELELECT or raises the existing
%      singleton*.
%
%      H = PLOTSELELECT returns the handle to a new PLOTSELELECT or the handle to
%      the existing singleton*.
%
%      PLOTSELELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSELELECT.M with the given input arguments.
%
%      PLOTSELELECT('Property','Value',...) creates a new PLOTSELELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotSelElect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotSelElect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotSelElect

% Last Modified by GUIDE v2.5 08-Apr-2013 21:08:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotSelElect_OpeningFcn, ...
                   'gui_OutputFcn',  @plotSelElect_OutputFcn, ...
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


% --- Executes just before plotSelElect is made visible.
function plotSelElect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotSelElect (see VARARGIN)

% if exist('paramElect','var')
%     clear paramElect
%     global paramElect
% else
    global paramElect
%end

%set(0,'Units','normalized'); 
%set(handles.figure1,'Position',[0.3 0.15 0.6 0.7]);  

% Choose default command line output for plotSelElect

load('tmpSelElect')

paramElect.Xlabels = param.Xlabels; 
if isfield(param,'Xlabels2use')
    paramElect.Xlabels2use = param.Xlabels2use; 
elseif isfield(paramElect,'Xlabels2use') %%% clean up global 
    paramElect=rmfield(paramElect,'Xlabels2use'); 
    paramElect=rmfield(paramElect,'indIn2use'); 
end 

%%% check if old or new lableing 
isOld=sum(strcmp(paramElect.Xlabels,'T3')) + sum(strcmp(paramElect.Xlabels,'T4')) + ... 
      sum(strcmp(paramElect.Xlabels,'T5')) + sum(strcmp(paramElect.Xlabels,'T6'));
if isOld 
    paramElect.electSet = {'Fp1','Fpz','Fp2', ...
        'AF3','AF4', ...
        'F7','F5','F3','F1','Fz','F2','F4','F6','F8' ...
        'FT7','FC5','FC3','FC1','FCz','FC2','FC4','FC6','FT8' ...
        'T3','C5','C3','C1','Cz','C2','C4','C6','T4' ...
        'TP7','CP5','CP3','CP1','CPz','CP2','CP4','CP6','TP8' ...
        'T5','P5','P3','P1','Pz','P2','P4','P6','T6' ...
        'PO7','PO5','PO3','PO1','POz','PO2','PO4','PO6','PO8' ...
        'CB1','O1','Oz','O2','CB2' ...
        'P9','P10','Iz','AF7','AFz','AF8'};
else
    paramElect.electSet = {'Fp1','Fpz','Fp2', ...
        'AF3','AF4', ...
        'F7','F5','F3','F1','Fz','F2','F4','F6','F8' ...
        'FT7','FC5','FC3','FC1','FCz','FC2','FC4','FC6','FT8' ...
        'T7','C5','C3','C1','Cz','C2','C4','C6','T8' ...
        'TP7','CP5','CP3','CP1','CPz','CP2','CP4','CP6','TP8' ...
        'P7','P5','P3','P1','Pz','P2','P4','P6','P8' ...
        'PO7','PO5','PO3','PO1','POz','PO2','PO4','PO6','PO8' ...
        'CB1','O1','Oz','O2','CB2' ...
        'P9','P10','Iz','AF7','AFz','AF8'};
end
 

 for i=1:length(paramElect.Xlabels)
     j=find(strcmpi(regexprep(paramElect.Xlabels{i},'[^\w'']',''),paramElect.electSet)==1); 
     if j 
         paramElect.indIn(i)=j ; 
     else 
         hW=warndlg(['Electrode ', paramElect.Xlabels{i},' not in set'],'Electrode missing'); 
         uiwait(hW)
     end 
 end 
 
 for i=1:length(paramElect.Xlabels)
     strH = ['handles.r',num2str(paramElect.indIn(i))]; 
     eStr=['set(',strH,',''Visible'',''on'',''Value'',0);'];
     eval(eStr); 
 end 
 
 
 if isfield(paramElect,'Xlabels2use'); 
     for i=1:length(paramElect.Xlabels2use)
         j=find(strcmpi(regexprep(paramElect.Xlabels2use{i},'[^\w'']',''),paramElect.electSet)==1); 
         paramElect.indIn2use(i)=j; 
         strH = ['handles.r',num2str(j)]; 
         eStr=['set(',strH,',''Value'',1);'];
         eval(eStr);
     end 
 else 
     for i=1:length(paramElect.Xlabels)
         strH = ['handles.r',num2str(paramElect.indIn(i))]; 
         eStr=['set(',strH,',''Value'',1);'];
         eval(eStr);
     end 
 end 
   
 handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotSelElect wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = plotSelElect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selOK.
function selOK_Callback(hObject, eventdata, handles)
% hObject    handle to selOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramElect

for i=1:length(paramElect.indIn)
    strH = ['handles.r',num2str(paramElect.indIn(i))];
    eStr=['value(i) = get(',strH,',''Value'');'];
    eval(eStr);
end
if sum(value) == 0
    hW = warndlg('At least one electrode must be selected !!!','Electrode not selected'); 
    uiwait(hW); 
else
    paramElect.indIn2use   = paramElect.indIn(value==1); 
    paramElect.Xlabels2use = paramElect.electSet(paramElect.indIn2use);
    
    param.Xlabels = paramElect.Xlabels; 
%   param.Xlabels2use = paramElect.Xlabels2use;
    
    if length(paramElect.Xlabels)==length(paramElect.Xlabels2use)
        param.Xlabels2use = param.Xlabels;
        param.var2use = 1:length(param.Xlabels);
    else
        indL=1; 
        for i=1:length(param.Xlabels) 
            j=find(strcmpi(regexprep(param.Xlabels{i},'[^\w'']',''),paramElect.Xlabels2use)==1);
            if j 
                param.Xlabels2use{indL}=param.Xlabels{i}; 
                indL =indL + 1; 
            end 
        end 
        for i=1:length(param.Xlabels2use)
            param.var2use(i) = find(strcmpi(param.Xlabels2use{i},param.Xlabels)==1); 
        end 
    end 
    save('tmpSelElect','param'); 
    close(handles.figure1) 
end



% --- Executes on button press in selAll.
function selAll_Callback(hObject, eventdata, handles)
% hObject    handle to selAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramElect

for i=1:length(paramElect.indIn)
    strH = ['handles.r',num2str(paramElect.indIn(i))];
    eStr=['set(',strH,',''Value'',1);'];
    eval(eStr);
end
set(handles.selAll,'Value',0);
guidata(hObject, handles);

% --- Executes on button press in dselAll.
function dselAll_Callback(hObject, eventdata, handles)
% hObject    handle to dselAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dselAll
global paramElect

for i=1:length(paramElect.indIn)
    strH = ['handles.r',num2str(paramElect.indIn(i))];
    eStr=['set(',strH,',''Value'',0);'];
    eval(eStr);
end
set(handles.dselAll,'Value',0);
guidata(hObject, handles);



% --- Executes on button press in desDiag.
function desDiag_Callback(hObject, eventdata, handles)
% hObject    handle to desDiag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramElect

lenL=length(paramElect.indIn);
newL=ones(1,lenL);
for k=1:lenL
    tI   = regexpi(paramElect.Xlabels{k},'\d');
    if isempty(tI)
        newL(k)=0;
    end
end
indIn= paramElect.indIn(newL==0);  

for i=1:length(indIn)
    strH = ['handles.r',num2str(indIn(i))];
    eStr=['set(',strH,',''Value'',0);'];
    eval(eStr);
end

set(handles.desDiag,'Value',0);
guidata(hObject, handles);


% --- Executes on button press in selDiag.
function selDiag_Callback(hObject, eventdata, handles)
% hObject    handle to selDiag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramElect

lenL=length(paramElect.indIn);
newL=ones(1,lenL);
for k=1:lenL
    tI   = regexpi(paramElect.Xlabels{k},'\d');
    if ~isempty(tI)
        newL(k)=0;
    end
end
indIn= paramElect.indIn(newL==1);  
for i=1:length(indIn)
    strH = ['handles.r',num2str(indIn(i))];
    eStr=['set(',strH,',''Value'',1);'];
    eval(eStr);
end

indIn= paramElect.indIn(newL==0);  
for i=1:length(indIn)
    strH = ['handles.r',num2str(indIn(i))];
    eStr=['set(',strH,',''Value'',0);'];
    eval(eStr);
end

set(handles.selDiag,'Value',0);
guidata(hObject, handles);


% --- Executes on button press in selLeft.
function selLeft_Callback(hObject, eventdata, handles)
% hObject    handle to selLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramElect

lenL=length(paramElect.indIn);
newL=ones(1,lenL);
for k=1:lenL
    tI   = regexpi(paramElect.Xlabels{k},'\d');
    if isempty(tI)
        newL(k)=0;
    else 
        if ~rem(str2double(paramElect.Xlabels{k}(tI(end))),2)
            newL(k)=0;
        end 
    end
end
indIn= paramElect.indIn(newL==0);  

for i=1:length(paramElect.indIn)
    strH = ['handles.r',num2str(paramElect.indIn(i))];
    eStr=['set(',strH,',''Value'',1);'];
    eval(eStr);
end

for i=1:length(indIn)
    strH = ['handles.r',num2str(indIn(i))];
    eStr=['set(',strH,',''Value'',0);'];
    eval(eStr);
end

set(handles.selLeft,'Value',0); 
guidata(hObject, handles);


% --- Executes on button press in selRight.
function selRight_Callback(hObject, eventdata, handles)
% hObject    handle to selRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramElect

lenL=length(paramElect.indIn);
newL=ones(1,lenL);
for k=1:lenL
    tI   = regexpi(paramElect.Xlabels{k},'\d');
    if isempty(tI)
        newL(k)=0;
    else 
        if rem(str2double(paramElect.Xlabels{k}(tI(end))),2)
            newL(k)=0;
        end 
    end
end
indIn= paramElect.indIn(newL==0);  

for i=1:length(paramElect.indIn)
    strH = ['handles.r',num2str(paramElect.indIn(i))];
    eStr=['set(',strH,',''Value'',1);'];
    eval(eStr);
end

for i=1:length(indIn)
    strH = ['handles.r',num2str(indIn(i))];
    eStr=['set(',strH,',''Value'',0);'];
    eval(eStr);
end

set(handles.selRight,'Value',0);
guidata(hObject, handles);

% --- Executes on button press in selCan.
function selCan_Callback(hObject, eventdata, handles)
% hObject    handle to selCan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)



% --- Executes on button press in r1.
function r1_Callback(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r1


% --- Executes on button press in r2.
function r2_Callback(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r2


% --- Executes on button press in r3.
function r3_Callback(hObject, eventdata, handles)
% hObject    handle to r3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r3


% --- Executes on button press in r4.
function r4_Callback(hObject, eventdata, handles)
% hObject    handle to r4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r4

% --- Executes on button press in r5.
function r5_Callback(hObject, eventdata, handles)
% hObject    handle to r5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r5

% --- Executes on button press in r6.
function r6_Callback(hObject, eventdata, handles)
% hObject    handle to r6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r6


% --- Executes on button press in r7.
function r7_Callback(hObject, eventdata, handles)
% hObject    handle to r7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r7


% --- Executes on button press in r8.
function r8_Callback(hObject, eventdata, handles)
% hObject    handle to r8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r8

% --- Executes on button press in r9.
function r9_Callback(hObject, eventdata, handles)
% hObject    handle to r9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r9


% --- Executes on button press in r10.
function r10_Callback(hObject, eventdata, handles)
% hObject    handle to r10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r10

% --- Executes on button press in r11.
function r11_Callback(hObject, eventdata, handles)
% hObject    handle to r11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r11

% --- Executes on button press in r13.
function r12_Callback(hObject, eventdata, handles)
% hObject    handle to r12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r12



% --- Executes on button press in r13.
function r13_Callback(hObject, eventdata, handles)
% hObject    handle to r13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r13


% --- Executes on button press in r14.
function r14_Callback(hObject, eventdata, handles)
% hObject    handle to r14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r14


% --- Executes on button press in r15.
function r15_Callback(hObject, eventdata, handles)
% hObject    handle to r15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r15


% --- Executes on button press in r16.
function r16_Callback(hObject, eventdata, handles)
% hObject    handle to r16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r16


% --- Executes on button press in r17.
function r17_Callback(hObject, eventdata, handles)
% hObject    handle to r17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r17


% --- Executes on button press in r18.
function r18_Callback(hObject, eventdata, handles)
% hObject    handle to r18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r18


% --- Executes on button press in r19.
function r19_Callback(hObject, eventdata, handles)
% hObject    handle to r19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r19


% --- Executes on button press in r20.
function r20_Callback(hObject, eventdata, handles)
% hObject    handle to r20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r20


% --- Executes on button press in r21.
function r21_Callback(hObject, eventdata, handles)
% hObject    handle to r21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r21


% --- Executes on button press in r22.
function r22_Callback(hObject, eventdata, handles)
% hObject    handle to r22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r22


% --- Executes on button press in r23.
function r23_Callback(hObject, eventdata, handles)
% hObject    handle to r23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r23


% --- Executes on button press in r24.
function r24_Callback(hObject, eventdata, handles)
% hObject    handle to r24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r24


% --- Executes on button press in r25.
function r25_Callback(hObject, eventdata, handles)
% hObject    handle to r25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r25


% --- Executes on button press in r26.
function r26_Callback(hObject, eventdata, handles)
% hObject    handle to r26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r26


% --- Executes on button press in r27.
function r27_Callback(hObject, eventdata, handles)
% hObject    handle to r27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r27


% --- Executes on button press in r28.
function r28_Callback(hObject, eventdata, handles)
% hObject    handle to r28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r28


% --- Executes on button press in r29.
function r29_Callback(hObject, eventdata, handles)
% hObject    handle to r29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r29


% --- Executes on button press in r30.
function r30_Callback(hObject, eventdata, handles)
% hObject    handle to r30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r30


% --- Executes on button press in r31.
function r31_Callback(hObject, eventdata, handles)
% hObject    handle to r31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r31


% --- Executes on button press in r32.
function r32_Callback(hObject, eventdata, handles)
% hObject    handle to r32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r32


% --- Executes on button press in r33.
function r33_Callback(hObject, eventdata, handles)
% hObject    handle to r33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r33


% --- Executes on button press in r34.
function r34_Callback(hObject, eventdata, handles)
% hObject    handle to r34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r34


% --- Executes on button press in r35.
function r35_Callback(hObject, eventdata, handles)
% hObject    handle to r35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r35


% --- Executes on button press in r36.
function r36_Callback(hObject, eventdata, handles)
% hObject    handle to r36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r36


% --- Executes on button press in r37.
function r37_Callback(hObject, eventdata, handles)
% hObject    handle to r37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r37


% --- Executes on button press in r38.
function r38_Callback(hObject, eventdata, handles)
% hObject    handle to r38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r38


% --- Executes on button press in r39.
function r39_Callback(hObject, eventdata, handles)
% hObject    handle to r39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r39


% --- Executes on button press in r40.
function r40_Callback(hObject, eventdata, handles)
% hObject    handle to r40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r40


% --- Executes on button press in r41.
function r41_Callback(hObject, eventdata, handles)
% hObject    handle to r41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r41

% --- Executes on button press in r42.
function r42_Callback(hObject, eventdata, handles)
% hObject    handle to r42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r42

% --- Executes on button press in r43.
function r43_Callback(hObject, eventdata, handles)
% hObject    handle to r43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r43


% --- Executes on button press in r44.
function r44_Callback(hObject, eventdata, handles)
% hObject    handle to r44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r44


% --- Executes on button press in r45.
function r45_Callback(hObject, eventdata, handles)
% hObject    handle to r45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r45


% --- Executes on button press in r46.
function r46_Callback(hObject, eventdata, handles)
% hObject    handle to r46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r46


% --- Executes on button press in r47.
function r47_Callback(hObject, eventdata, handles)
% hObject    handle to r47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r47


% --- Executes on button press in r48.
function r48_Callback(hObject, eventdata, handles)
% hObject    handle to r48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r48


% --- Executes on button press in r49.
function r49_Callback(hObject, eventdata, handles)
% hObject    handle to r49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r49


% --- Executes on button press in r50.
function r50_Callback(hObject, eventdata, handles)
% hObject    handle to r50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r50


% --- Executes on button press in r51.
function r51_Callback(hObject, eventdata, handles)
% hObject    handle to r51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r51


% --- Executes on button press in r52.
function r52_Callback(hObject, eventdata, handles)
% hObject    handle to r52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r52


% --- Executes on button press in r53.
function r53_Callback(hObject, eventdata, handles)
% hObject    handle to r53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r53


% --- Executes on button press in r54.
function r54_Callback(hObject, eventdata, handles)
% hObject    handle to r54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r54


% --- Executes on button press in r55.
function r55_Callback(hObject, eventdata, handles)
% hObject    handle to r55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r55


% --- Executes on button press in r56.
function r56_Callback(hObject, eventdata, handles)
% hObject    handle to r56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r56


% --- Executes on button press in r57.
function r57_Callback(hObject, eventdata, handles)
% hObject    handle to r57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r57


% --- Executes on button press in r58.
function r58_Callback(hObject, eventdata, handles)
% hObject    handle to r58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r58


% --- Executes on button press in r59.
function r59_Callback(hObject, eventdata, handles)
% hObject    handle to r59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r59


% --- Executes on button press in r60.
function r60_Callback(hObject, eventdata, handles)
% hObject    handle to r60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r60

% --- Executes on button press in r61.
function r61_Callback(hObject, eventdata, handles)
% hObject    handle to r61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r61


% --- Executes on button press in r62.
function r62_Callback(hObject, eventdata, handles)
% hObject    handle to r62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r62

% --- Executes on button press in r63.
function r63_Callback(hObject, eventdata, handles)
% hObject    handle to r63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r63

% --- Executes on button press in r64.
function r64_Callback(hObject, eventdata, handles)
% hObject    handle to r64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r64


% --- Executes on button press in r65.
function r65_Callback(hObject, eventdata, handles)
% hObject    handle to r65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r65


% --- Executes on button press in r66.
function r66_Callback(hObject, eventdata, handles)
% hObject    handle to r66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r66


% --- Executes on button press in r67.
function r67_Callback(hObject, eventdata, handles)
% hObject    handle to r67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r67


% --- Executes on button press in r68.
function r68_Callback(hObject, eventdata, handles)
% hObject    handle to r68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r68


% --- Executes on button press in r69.
function r69_Callback(hObject, eventdata, handles)
% hObject    handle to r69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r69

% --- Executes on button press in r70.
function r70_Callback(hObject, eventdata, handles)
% hObject    handle to r70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r70
