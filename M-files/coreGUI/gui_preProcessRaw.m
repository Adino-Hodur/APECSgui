function varargout = gui_preProcessRaw(varargin)
% GUI_PREPROCESSRAW MATLAB code for gui_preProcessRaw.fig
%      GUI_PREPROCESSRAW, by itself, creates a new GUI_PREPROCESSRAW or raises the existing
%      singleton*.
%
%      H = GUI_PREPROCESSRAW returns the handle to a new GUI_PREPROCESSRAW or the handle to
%      the existing singleton*.
%
%      GUI_PREPROCESSRAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PREPROCESSRAW.M with the given input arguments.
%
%      GUI_PREPROCESSRAW('Property','Value',...) creates a new GUI_PREPROCESSRAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_preProcessRaw_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_preProcessRaw_OpeningFcn via varargin.
%
% See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_preProcessRaw

% Last Modified by GUIDE v2.5 05-Jun-2018 13:56:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_preProcessRaw_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_preProcessRaw_OutputFcn, ...
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


% --- Executes just before gui_preProcessRaw is made visible.
function gui_preProcessRaw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_preProcessRaw (see VARARGIN)

clear global
global paramPreProcess

set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.2 0.2 0.65 0.6]); 

%set(handles.figure1,'Position',[0.2 0.2 0.4 0.3]); 

% Choose default command line output for gui_preProcessRaw
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_preProcessRaw wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_preProcessRaw_OutputFcn(hObject, eventdata, handles) 
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

global paramPreProcess

set(handles.corrFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');

set(handles.loadFile,'Enable','off');
set(handles.loadParam,'Enable','off');
    
[fileName, pathName] = uigetfile ({'./Data/RawData/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if isfield(paramPreProcess,'fileIndx') && sum(strcmp(paramPreProcess.fileName,fileName)) && sum(strcmp(paramPreProcess.pathName,pathName))
    hE=errordlg('This file is alrady in .... Error!!','Error - file alrady in');
    uiwait(hE);
    toDo = 3;
elseif fileName
    %%% load header file
    strF=strcat(pathName,fileName);
    load(strF,'header')
    if ~exist('header','var')
        hE=errordlg('Header no present in the file ...','Error - header missing');
        uiwait(hE);
        toDo = 1;
    else
        if isfield(paramPreProcess,'fileIndx')
            paramPreProcess.fileIndx = paramPreProcess.fileIndx + 1;
        else
            paramPreProcess.fileIndx = 1;
        end
        paramPreProcess.fileName{paramPreProcess.fileIndx} = fileName;
        paramPreProcess.pathName{paramPreProcess.fileIndx} = pathName;
        paramPreProcess.fileHeader{paramPreProcess.fileIndx} = header;
        toDo = 2;
    end
elseif  isfield(paramPreProcess,'fileIndx')    
    toDo = 3; 
else     
    toDo = 1; 
end

switch toDo 
    case 1 
      set(handles.loadFile,'Enable','on') 
      set(handles.loadParam,'Enable','on'); 
    case 2 
      set(handles.loadFile,'Visible','off')    
      set(handles.loadParam,'Visible','off'); 
      set(handles.lenEpoch,'Visible','on','String',[]); 
      set(handles.topPanel,'Visible','on'); 
      set(handles.textEpoch,'Visible','on'); 
      set(handles.textJoinSeg,'Visible','on'); 
      set(handles.checkboxJoinSeg,'Visible','on'); 
      strFT=[{fileName}; {'--------------------------------'}];
      if isfield(header,'sampleFreq')
          str=['Sampling frequency: ',num2str(header.sampleFreq)]; 
          if isfield(header,'sampleFreqUnit')
              str=[str,' [',header.sampleFreqUnit,']']; 
          else
              paramPreProcess.fileHeader{paramPreProcess.fileIndx}.sampleFreqUnit='Hz'; 
              str=[str,' [Hz]'];
          end
          strFT=[strFT; {str}];
          strFT=[strFT; {'--------------------------------'}];
      end
      set(handles.fileText,'String',strFT,'Visible','on');
      if isfield(header,'sampleFreq')
          set(handles.samplB,'Visible','on','Value',0);
          set(handles.msecB,'Visible','on','Value',0);
          set(handles.secB,'Visible','on','Value',0);
          set(handles.minB,'Visible','on','Value',0);
      else
          set(handles.samplB,'Visible','on','Value',0);
      end
    case 3 
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.pushFinishSelection,'Visible','on');
        set(handles.repFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.delFile,'Visible','on');        
end 

guidata(hObject,handles) 


% --- Executes on button press in loadParam.
function loadParam_Callback(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramPreProcess

set(handles.loadFile,'Enable','off'); 
set(handles.loadParam,'Enable','off'); 

[fileName, pathName] = uigetfile ({'./ParameterFiles/*.mat'},'Open File'); 

pathName=getRelPath(pathName);  

if fileName
    %%% load parameters    
    strF=strcat(pathName,fileName);
    warning off 
    s=load(strF,'paramPreProcess');
    warning on 
        
    if ~isfield(s,'paramPreProcess')         
        hE=msgbox([fileName,' is not a correct parameter''s file'],'Error - not parameter''s file','error');
        uiwait(hE);
        set(handles.loadFile,'Enable','on'); 
        set(handles.loadParam,'Enable','on');          
    else
        paramPreProcess=s.paramPreProcess;                       
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
        
        %%%% open print window for sumarry 
        handles = printParameters(paramPreProcess,handles); 
        
        set(handles.loadParam,'Visible','off');
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.repFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
    end
else 
    set(handles.loadFile,'Visible','on','Enable','on');
    set(handles.loadParam,'Visible','on','Enable','on');
end

guidata(hObject,handles)

% --- Executes on button press in samplB.
function samplB_Callback(hObject, eventdata, handles)
% hObject    handle to samplB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');   
else
    iE=paramPreProcess.fileIndx;
end 

%set(handles.samplB,'Value',0);
set(handles.msecB,'Value',0);
set(handles.secB,'Value',0);
set(handles.minB,'Value',0);

lenV=str2double(get(handles.lenEpoch,'String')); 
if ~(isempty(lenV) || isnan(lenV))
    if isfloat(lenV) && lenV > 0
        paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
        paramPreProcess.fileHeader{iE}.lenEpochUnit = 'samples';
        paramPreProcess.fileHeader{iE}.joinSeg=get(handles.checkboxJoinSeg,'Value');   
        set(handles.textJoinSeg,'Visible','off'); 
        set(handles.checkboxJoinSeg,'Visible','off'); 
        
        strFT=get(handles.fileText,'String');
        if paramPreProcess.fileHeader{iE}.joinSeg
            str=['join disc. seg.: true'];
        else
            str=['join disc. seg.: false'];
        end
        strFT=[strFT; {str}];
        strFT=[strFT; {'--------------------------------'}];
        str=['Epoch length: ',get(handles.lenEpoch,'String'),' [samples]'];
        strFT=[strFT; {str}];
        set(handles.fileText,'String',strFT);
        
        set(handles.lenEpoch,'String','');
        set(handles.lenEpoch,'Visible','off');
        set(handles.lenOverlap,'Visible','on');
        set(handles.textEpoch,'String','Define overlap:');
        
        set(handles.msecB,'Visible','off');
        set(handles.secB,'Visible','off');
        set(handles.minB,'Visible','off');
        set(handles.samplB,'Value',1,'Enable','off');
        
        
        
    else
        set(handles.samplB,'Value',0);
    end
end

guidata(hObject,handles)

% --- Executes on button press in msecB.
function msecB_Callback(hObject, eventdata, handles)
% hObject    handle to msecB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
    iE=paramPreProcess.fileIndx;
end

set(handles.samplB,'Value',0);
%set(handles.msecB,'Value',0);
set(handles.secB,'Value',0);
set(handles.minB,'Value',0);

lenV=str2double(get(handles.lenEpoch,'String')); 
if ~(isempty(lenV) || isnan(lenV))
    if isfloat(lenV) && lenV > 0
        paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
        paramPreProcess.fileHeader{iE}.lenEpochUnit = 'msec';
        paramPreProcess.fileHeader{iE}.joinSeg=get(handles.checkboxJoinSeg,'Value');   
        set(handles.textJoinSeg,'Visible','off'); 
        set(handles.checkboxJoinSeg,'Visible','off'); 
        
        strFT=get(handles.fileText,'String');
        if paramPreProcess.fileHeader{iE}.joinSeg
            str=['join disc. seg.: true'];
        else
            str=['join disc. seg.: false'];
        end
        strFT=[strFT; {str}];
        strFT=[strFT; {'--------------------------------'}];
        str=['Epoch length   : ',get(handles.lenEpoch,'String'),' [msec]'];
        strFT=[strFT; {str}];
        set(handles.fileText,'String',strFT);
        
        set(handles.lenEpoch,'String','');
        set(handles.lenEpoch,'Visible','off');
        set(handles.lenOverlap,'Visible','on');
        set(handles.textEpoch,'String','Define overlap:');
        set(handles.msecB,'Value',0);
        set(handles.samplB,'Visible','off');
        

    else
        set(handles.msecB,'Value',0);
    end
end

lenV=str2double(get(handles.lenOverlap,'String'));
if ~(isempty(lenV) || isnan(lenV))
    if checkCorrOver(lenV,'msec',paramPreProcess.fileHeader{iE})
        if isfloat(lenV) && lenV >= 0
            paramPreProcess.fileHeader{iE}.lenOverlap     = lenV;
            paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'msec';
            
            strFT=get(handles.fileText,'String');
            str=['Overlap length: ',get(handles.lenOverlap,'String'),' [msec]'];
            strFT=[strFT; {str}];
            set(handles.fileText,'String',strFT);
            %%%% set handles
            handles = handles_set2(handles,paramPreProcess,iE);
            
        else
            set(handles.msecB,'Value',0);
        end
    else
        hE=errordlg('Overalp can''t be greater than epoch length');
        uiwait(hE);
        set(handles.msecB,'Value',0);
        set(handles.lenOverlap,'String',[]);
    end
end

guidata(hObject,handles) 

% --- Executes on button press in secB.
function secB_Callback(hObject, eventdata, handles)
% hObject    handle to secB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
    iE=paramPreProcess.fileIndx;
end

set(handles.samplB,'Value',0);
set(handles.msecB,'Value',0);
%set(handles.secB,'Value',0);
set(handles.minB,'Value',0);

lenV=str2double(get(handles.lenEpoch,'String'));
if ~(isempty(lenV) || isnan(lenV))
    if isfloat(lenV) && lenV > 0
        paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
        paramPreProcess.fileHeader{iE}.lenEpochUnit = 'sec';
        paramPreProcess.fileHeader{iE}.joinSeg=get(handles.checkboxJoinSeg,'Value');   
        set(handles.textJoinSeg,'Visible','off'); 
        set(handles.checkboxJoinSeg,'Visible','off');
        
        strFT=get(handles.fileText,'String');
        if paramPreProcess.fileHeader{iE}.joinSeg
            str=['join disc. seg.: true'];
        else
            str=['join disc. seg.: false'];
        end
        strFT=[strFT; {str}];
        strFT=[strFT; {'--------------------------------'}];
        str=['Epoch length   : ',get(handles.lenEpoch,'String'),' [sec]'];
        strFT=[strFT; {str}];
        set(handles.fileText,'String',strFT);
        
        set(handles.lenEpoch,'String','');
        set(handles.lenEpoch,'Visible','off');
        set(handles.lenOverlap,'Visible','on');
        set(handles.textEpoch,'String','Define overlap:');
        set(handles.secB,'Value',0);
        set(handles.samplB,'Visible','off');
        
        %set(handles.minB,'Visible','off');
    else
        set(handles.secB,'Value',0);
    end
end

lenV=str2double(get(handles.lenOverlap,'String')); 
if ~(isempty(lenV) || isnan(lenV))   
    if checkCorrOver(lenV,'sec',paramPreProcess.fileHeader{iE})
        if isfloat(lenV) && lenV >= 0
            paramPreProcess.fileHeader{iE}.lenOverlap     = lenV;
            paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'sec';
            
            strFT=get(handles.fileText,'String');
            str=['Overlap length: ',get(handles.lenOverlap,'String'),' [sec]'];
            strFT=[strFT; {str}];
            set(handles.fileText,'String',strFT);
            %%%%% set handles
            handles = handles_set2(handles,paramPreProcess,iE);
        else
            set(handles.secB,'Value',0);
        end
    else
        hE=errordlg('Overalp can''t be greater than epoch length');
        uiwait(hE);
        set(handles.secB,'Value',0);
        set(handles.lenOverlap,'String',[]);
    end
end

guidata(hObject,handles)

% --- Executes on button press in minB.
function minB_Callback(hObject, eventdata, handles)
% hObject    handle to minB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
    iE=paramPreProcess.fileIndx;
end
set(handles.samplB,'Value',0);
set(handles.msecB,'Value',0);
set(handles.secB,'Value',0);
%set(handles.minB,'Value',0);

lenV=str2double(get(handles.lenEpoch,'String')); 
if ~(isempty(lenV) || isnan(lenV))
    if isfloat(lenV) && lenV > 0
        paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
        paramPreProcess.fileHeader{iE}.lenEpochUnit = 'min';
        paramPreProcess.fileHeader{iE}.joinSeg=get(handles.checkboxJoinSeg,'Value');   
        set(handles.textJoinSeg,'Visible','off'); 
        set(handles.checkboxJoinSeg,'Visible','off'); 
        
        strFT=get(handles.fileText,'String');
        if paramPreProcess.fileHeader{iE}.joinSeg
            str=['join disc. seg.: true'];
        else
            str=['join disc. seg.: false'];
        end
        strFT=[strFT; {str}];
        strFT=[strFT; {'--------------------------------'}];
        str=['Epoch length   : ',get(handles.lenEpoch,'String'),' [min]'];
        strFT=[strFT; {str}];
        set(handles.fileText,'String',strFT);
        
        set(handles.lenEpoch,'String','');
        set(handles.lenEpoch,'Visible','off');
        set(handles.lenOverlap,'Visible','on');
        set(handles.textEpoch,'String','Define overlap:');
        set(handles.minB,'Value',0);
        set(handles.samplB,'Visible','off');
    else
        set(handles.minB,'Value',0);
    end
end

lenV=str2double(get(handles.lenOverlap,'String'));
if ~(isempty(lenV) || isnan(lenV))
    if checkCorrOver(lenV,'min',paramPreProcess.fileHeader{iE})
        if isfloat(lenV) && lenV >= 0
            paramPreProcess.fileHeader{iE}.lenOverlap     = lenV;
            paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'min';
            
            strFT=get(handles.fileText,'String');
            str=['Overlap length: ',get(handles.lenOverlap,'String'),' [min]'];
            strFT=[strFT; {str}];
            set(handles.fileText,'String',strFT);
            %%%% set handles
            handles = handles_set2(handles,paramPreProcess,iE);
        else
            set(handles.minB,'Value',0);
        end
    else
        hE=errordlg('Overalp can''t be greater than epoch length');
        uiwait(hE);
        set(handles.minB,'Value',0);
        set(handles.lenOverlap,'String',[]);
    end
end


guidata(hObject,handles)


function lenEpoch_Callback(hObject, eventdata, handles)
% hObject    handle to lenEpoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles)    

% --- Executes during object creation, after setting all properties.
function lenEpoch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lenEpoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lenOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to lenOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

% if get(handles.corrFile,'UserData')
%    iE=get(handles.corrFile,'UserData'); 
% else
%     iE=paramPreProcess.fileIndx;
% end
% 
% lenV=str2double(get(handles.lenOverlap,'String'));
% %if lenV < paramPreProcess.fileHeader{iE}.lenEpoch
%     if  get(handles.samplB,'Value') && isfloat(lenV) && lenV >= 0
%         
%         paramPreProcess.fileHeader{iE}.lenOverlap     = lenV;
%         paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'samples';
%         
%         strFT=get(handles.fileText,'String');
%         str=['Overlap length: ',get(handles.lenOverlap,'String'),' [samples]'];
%         strFT=[strFT; {str}];
%         set(handles.fileText,'String',strFT);
%         
%         set(handles.lenOverlap,'Visible','off','String',[]);
%         set(handles.samplB,'Visible','off','Enable','on');
%         set(handles.msecB,'Visible','off');
%         set(handles.secB,'Visible','off');
%         set(handles.minB,'Visible','off');
%         set(handles.textEpoch,'Visible','off');
%         
%         
%         set(handles.checkRes,'Visible','on');
%         set(handles.checkFilt,'Visible','on');
%         set(handles.pushOK1,'Visible','on');
%         
%         %%%% right text
%         if isfield(paramPreProcess.fileHeader{iE},'sampleFreq')
%             strRFT(1)={'Re-sampling: no'};
%         elseif isfield(paramPreProcess.fileHeader{iE},'decimationFactor')
%             strRFT(1)={'Decimation: no'};
%         end
%         strRFT(2)={'--------------------------------'};
%         strRFT(3)={'Filtering: no'};
%         strRFT(4)={'--------------------------------'};
%         set(handles.fileTextR,'Visible','on','String',strRFT);
%     end
% %else
%   %  hE=errordlg('Overalp can''t be greater than epoch length');
%   %  uiwait(hE);
%   %  set(handles.samplB,'Enable','off','Value',1);
%   %  set(handles.lenOverlap,'String',[]);
% %end

guidata(hObject,handles)   

% --- Executes on button press in pushOK1.
function pushOK1_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
    iE=paramPreProcess.fileIndx;
end

set(handles.checkRes,'Visible','off','Value',0); 
set(handles.checkNotchFilt,'Visible','off','Value',0); 
set(handles.checkFilt,'Visible','off','Value',0); 
set(handles.pushOK1,'Visible','off','Value',0);

%set(handles.checkSelL,'Visible','on'); 
%set(handles.checkRef,'Visible','on');
%set(handles.checkCompY,'visible','on'); 
set(handles.pushOK2,'Visible','on');


strRFT = get(handles.fileTextR,'String');
if isfield(paramPreProcess.fileHeader{iE},'Xlabels2use') && ... 
        (length(paramPreProcess.fileHeader{iE}.Xlabels2use) ~= length(paramPreProcess.fileHeader{iE}.Xlabels))
    strRFT = get(handles.fileTextR,'String');
    strRFT(7)={'Variables to use: '};
    pStr = [];
    %ppStr=paramPreProcess.fileHeader{iE}.Xlabels
    for sI=1:length(paramPreProcess.fileHeader{iE}.Xlabels2use)
        pStr=[pStr,regexprep(paramPreProcess.fileHeader{iE}.Xlabels2use{sI},'[^\w'']',''),','];
    end
    pStr=pStr(1:end-1);
    strRFT(8)={pStr};
    set(handles.checkSelL,'Visible','on','Value',1); 
else
    strRFT(7)={'Variables to use: all'};
    set(handles.checkSelL,'Visible','on','Value',0); 
end
strRFT(9)={'--------------------------------'};
if isfield(paramPreProcess.fileHeader{iE},'eventsProcessFile')
    nstr=['Processing events: yes (', paramPreProcess.fileHeader{iE}.eventsProcessFile,')'];
    strRFT(10)={nstr}; 
    set(handles.checkCompY,'Visible','on','Value',1);
else
    strRFT(10)={'Processing events: no'};
    set(handles.checkCompY,'Visible','on','Value',0);
end
strRFT(11)={'--------------------------------'};
if isfield(paramPreProcess.fileHeader{iE},'refType')
    if isfield(paramPreProcess.fileHeader{iE},'refType');
        if regexpi(paramPreProcess.fileHeader{iE}.refType,'Laplacian')
            pz=regexpi(paramPreProcess.fileHeader{iE}.fnHeadModel,filesep);
            if isempty(pz)
                fN=paramPreProcess.fileHeader{iE}.fnHeadModel;
            else
                fN=paramPreProcess.fileHeader{iE}.fnHeadModel(pz(end)+1:end);
            end
            nstr=['Re-referencing: ',paramPreProcess.fileHeader{iE}.refType,' (',fN,')'];
            set(handles.checkRef,'Visible','on','Value',1);
        elseif strcmpi(paramPreProcess.fileHeader{iE}.refType,'none')
            nstr='Re-referencing: no';
            set(handles.checkRef,'Visible','on','Value',0);
        else
            nstr=['Re-referencing: ',paramPreProcess.fileHeader{iE}.refType];
            set(handles.checkRef,'Visible','on','Value',1);
        end
        
    end
    strRFT(12)={nstr};
else
    strRFT(12)={'Re-referencing: no'};
    set(handles.checkRef,'Visible','on','Value',0);
end
   
set(handles.fileTextR,'Visible','on','String',strRFT);

guidata(hObject,handles)  

% --- Executes on button press in pushOK2.
function pushOK2_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
   iE=paramPreProcess.fileIndx;
end

%%%%% take off visibility 
set(handles.pushOK2,'Visible','off','Value',0);
set(handles.checkCompY,'Visible','off','Value',0);
set(handles.checkSelL,'Visible','off','Value',0);
set(handles.checkRef,'Visible','off','Value',0);

%%%% visibilty on 
set(handles.corrValues,'Visible','on');
set(handles.pushDone,'Visible','on');

guidata(hObject,handles) 


% --- Executes during object creation, after setting all properties.
function lenOverlap_CreateFcn(hObject, ~, handles)
% hObject    handle to lenOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushDone.
function pushDone_Callback(hObject, eventdata, handles)
% hObject    handle to pushDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess 

set(handles.pushDone,'Visible','off','Value',0);
set(handles.corrValues,'Visible','off','Value',0);

set(handles.topPanel,'Visible','off');
set(handles.fileText,'Visible','off');
set(handles.textEpoch,'Visible','off');
set(handles.fileTextR,'Visible','off','String',[]);

handles = printParameters(paramPreProcess,handles);

set(handles.loadFile,'Visible','on','Enable','on');
set(handles.pushFinishSelection,'Visible','on'); 
set(handles.repFile,'Visible','on');
set(handles.corrFile,'Visible','on','UserData',[]); 
set(handles.delFile,'Visible','on'); 

guidata(hObject,handles)   

% --- Executes on button press in checkRes.
function checkRes_Callback(hObject, eventdata, handles)
% hObject    handle to checkRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess 

if get(handles.corrFile,'UserData')
    iE=get(handles.corrFile,'UserData');
else
    iE=paramPreProcess.fileIndx;
end

if get(handles.checkRes,'Value')
    set(handles.checkRes,'Enable','off');
    set(handles.checkFilt,'Enable','off');
    set(handles.checkNotchFilt,'Enable','off');
    set(handles.pushOK1,'Enable','off');
    
    set(handles.textRes,'Visible','on');
    set(handles.newSF,'Visible','on');
    if isfield(paramPreProcess.fileHeader{iE},'sampleFreq')
        str = ['New sampling freq. in ','[',paramPreProcess.fileHeader{iE}.sampleFreqUnit,']:'];
    else
        str = ['Decimation factor (integer):'];
    end
    set(handles.textRes,'String',str)
    disp(get(handles.corrFile,'UserData'))
else
    strRFT = get(handles.fileTextR,'String');
    if isfield(paramPreProcess.fileHeader{iE},'new_sampleFreq')
        paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'new_sampleFreq');
        %paramPreProcess.fileHeader{iE}.new_sampleFreq = paramPreProcess.fileHeader{iE}.sampleFreq;
        nstr='Re-sampling: no';
    elseif isfield(paramPreProcess.fileHeader{iE},'decimationFactor')
        paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'decimationFactor');
        nstr='Decimation: no';
    else
        nstr='Decimation: no';
    end
    strRFT(1)={nstr};
    set(handles.fileTextR,'Visible','on','String',strRFT);
    
end

guidata(hObject,handles)  


function newSF_Callback(hObject, eventdata, handles)
% hObject    handle to newSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newSF as text
%        str2double(get(hObject,'String')) returns contents of newSF as a double
global paramPreProcess 

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData'); 
   % set(handles.corrFile,'UserData',[]);
else
    iE=paramPreProcess.fileIndx;
end
    
nsf=str2double(get(handles.newSF,'String'));
if isfloat(nsf) && nsf > 0
    strRFT = get(handles.fileTextR,'String');
    if isfield(paramPreProcess.fileHeader{iE},'sampleFreq')
        paramPreProcess.fileHeader{iE}.new_sampleFreq = nsf;
        nstr=['New sampling frequency: ',num2str(paramPreProcess.fileHeader{iE}.new_sampleFreq), ...
            ' [',paramPreProcess.fileHeader{iE}.sampleFreqUnit,']'];
    else
        paramPreProcess.fileHeader{iE}.decimationFactor = nsf;
        nstr=['Decimation factor: ',num2str(paramPreProcess.fileHeader{iE}.decimationFactor)];
    end
    strRFT(1)={nstr};
    set(handles.fileTextR,'Visible','on','String',strRFT);    
    set(handles.checkRes,'Enable','on','Value',1);
    set(handles.checkFilt,'Enable','on');
    set(handles.checkNotchFilt,'Enable','on');
    set(handles.pushOK1,'Enable','on');
    set(handles.textRes,'Visible','off');
    set(handles.newSF,'Visible','off','String',[]);
end


guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function newSF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkFilt.
function checkFilt_Callback(hObject, eventdata, handles)
% hObject    handle to checkFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
    iE=paramPreProcess.fileIndx;
end

if get(handles.checkFilt,'Value')
    set(handles.checkFilt,'Enable','off');
    set(handles.checkNotchFilt,'Enable','off');
    set(handles.checkRes,'Enable','off');
    set(handles.pushOK1,'Enable','off');
        
    [fileName, pathName] = uigetfile ({'./Filters/*.mat'},'Open a Filter File');    
    pathName=getRelPath(pathName);  
    
    if fileName
        %%% load parameters
        strF=strcat(pathName,fileName);
        load(strF)
        if exist('dM','var') && exist('fM','var')
            %%%% define filter file, this also means filtering data .....
            paramPreProcess.fileHeader{iE}.filterFile=strF;
            strRFT = get(handles.fileTextR,'String');
            if strcmp(dM.Response,'Bandstop')
                nstr=['Filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass1),'-',num2str(dM.Fpass2), ... 
                    '//',fM.FilterStructure,'//', '(',paramPreProcess.fileHeader{iE}.filterFile,')'];
            else
                nstr=['Filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass), ...
                    '//',fM.FilterStructure,'//', '(',paramPreProcess.fileHeader{iE}.filterFile,')'];
            end
            strRFT(3)={nstr};
            set(handles.fileTextR,'Visible','on','String',strRFT);            
            set(handles.checkFilt,'Enable','on','Value',1);
            set(handles.checkNotchFilt,'Enable','on');
            set(handles.checkRes,'Enable','on');
            set(handles.pushOK1,'Enable','on');
        else
            hE=errordlg('Filter does not contain compulsory structures f and d'); 
            uiwait(hE); 
            set(handles.checkFilt,'Enable','on','Value',0);
            set(handles.checkNotchFilt,'Enable','on');
            set(handles.checkRes,'Enable','on');
            set(handles.pushOK1,'Enable','on');
        end 
    else
        set(handles.checkFilt,'Enable','on','Value',0);
        set(handles.checkNotchFilt,'Enable','on');
        set(handles.checkRes,'Enable','on');
        set(handles.pushOK1,'Enable','on');       
    end
else
    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'filterFile');
    strRFT = get(handles.fileTextR,'String');
    strRFT(3)={'Filtering: no'};
    set(handles.fileTextR,'Visible','on','String',strRFT);
end     

guidata(hObject,handles) 

% --- Executes on button press in checkCompY.
function checkCompY_Callback(hObject, eventdata, handles)
% hObject    handle to checkCompY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
    iE=paramPreProcess.fileIndx;
end

if get(handles.checkCompY,'Value')
    set(handles.checkCompY,'Enable','off');
    set(handles.checkSelL,'Enable','off');
    set(handles.checkRef,'Enable','off'); 
    set(handles.pushOK2,'Enable','off');
        
    [fileName, pathName] = uigetfile ({'./Customized-M-files/*.m'},'Open a Events Processing File');
    pathName=getRelPath(pathName); 
    
    if fileName
        %%% load parameters
        strF=strcat(pathName,fileName);
        %%%% define filter file, this also means filtering data .....
        paramPreProcess.fileHeader{iE}.eventsPathName=pathName;
        paramPreProcess.fileHeader{iE}.eventsProcessFile=fileName;
        %paramPreProcess.fileHeader{iE}.eventsProcessFile=fileName;
        strRFT = get(handles.fileTextR,'String');
        nstr=['Processing events: yes (', fileName,')'];
        strRFT(10)={nstr};
        set(handles.fileTextR,'Visible','on','String',strRFT);
        
        set(handles.checkCompY,'Enable','on','Value',1);
        set(handles.checkSelL,'Enable','on');
        set(handles.pushOK2,'Enable','on');
        set(handles.checkRef,'Enable','on');
    else
        set(handles.checkCompY,'Enable','on','Value',0);
        set(handles.checkSelL,'Enable','on');
        set(handles.pushOK2,'Enable','on');
        set(handles.checkRef,'Enable','on');
    end
else
    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'eventsProcessFile');
    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'eventsPathName');
    strRFT = get(handles.fileTextR,'String');
    strRFT(10)={'Processing events: no'};
    set(handles.fileTextR,'Visible','on','String',strRFT);
end     

guidata(hObject,handles) 


% --- Executes on button press in checkSelL.
function checkSelL_Callback(hObject, eventdata, handles)
% hObject    handle to checkSelL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess


if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
    iE=paramPreProcess.fileIndx;
end

%if get(handles.checkSelL,'Value')
    set(handles.checkSelL,'Enable','off','Visible','off');
    set(handles.pushOK2,'Enable','off');
    set(handles.checkCompY,'Enable','off');
    set(handles.checkRef,'Enable','off');
    
    
    param.Xlabels = paramPreProcess.fileHeader{iE}.Xlabels;
    if isfield(paramPreProcess.fileHeader{iE},'Xlabels2use')
        param.Xlabels2use = paramPreProcess.fileHeader{iE}.Xlabels2use;
    end 
    
    save('tmpSelElect','param');
    hS = plotSelElect;
    uiwait(hS)
    load('tmpSelElect','param');
    delete('tmpSelElect.mat')
    if isfield(param,'Xlabels2use')
        paramPreProcess.fileHeader{iE}.Xlabels2use = param.Xlabels2use;
    end
    clear param
    
    if isfield(paramPreProcess.fileHeader{iE},'Xlabels2use')
        if length(paramPreProcess.fileHeader{iE}.Xlabels2use) == length(paramPreProcess.fileHeader{iE}.Xlabels)
            strRFT = get(handles.fileTextR,'String');
            strRFT(7)={'Variables to use: all'};
            strRFT(8)={' '};
            set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
        else
            strRFT = get(handles.fileTextR,'String');
            strRFT(7)={'Variables to use: '};
            pStr = [];
            %ppStr=paramPreProcess.fileHeader{iE}.Xlabels
            for sI=1:length(paramPreProcess.fileHeader{iE}.Xlabels2use)
                pStr=[pStr,regexprep(paramPreProcess.fileHeader{iE}.Xlabels2use{sI},'[^\w'']',''),','];
            end
            pStr=pStr(1:end-1);
            strRFT(8)={pStr};
            set(handles.checkSelL,'Enable','on','Visible','on','Value',1);
        end
    else
        strRFT = get(handles.fileTextR,'String');
        strRFT(7)={'Variables to use: all'};
        strRFT(8)={' '};
        set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
    end
   
   set(handles.fileTextR,'Visible','on','String',strRFT); 
   %set(handles.checkSelL,'Enable','off','Visible','on');
   set(handles.pushOK2,'Enable','on');
   set(handles.checkCompY,'Enable','on');
   set(handles.checkRef,'Enable','on');
% else
%     strRFT = get(handles.fileTextR,'String');
%     strRFT(5)={'Used variables: all'};
%     strRFT(7)={' '};
%     set(handles.fileTextR,'Visible','on','String',strRFT);
% end


guidata(hObject,handles)  


% --- Executes on button press in checkRef.
function checkRef_Callback(hObject, eventdata, handles)
% hObject    handle to checkRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
    iE=get(handles.corrFile,'UserData');
else
    iE=paramPreProcess.fileIndx;
end

strRFT=get(handles.fileTextR,'String');

if get(handles.checkRef,'Value')
    set(handles.pushOK2,'Enable','off');
    set(handles.checkCompY,'Enable','off');
    set(handles.checkSelL,'Enable','off');
    set(handles.checkRef,'Enable','off');
    str={'Average Reference','Average Reference & GF','A1A2-2' ...
        'Laplacian-Sph','Laplacian-Geo'};
    [sPos,iOK] = listdlg('PromptString','Select a type of re-referencing:',...
        'SelectionMode','single','ListString',str);
    if iOK
        paramPreProcess.fileHeader{iE}.refType= str{sPos};
        if regexpi(str{sPos},'Laplacian')
            [fileName, pathName] = uigetfile ({'./M-files/ssltool/data/*.mat'},'Load Head Model for Laplacian');
            pathName=getRelPath(pathName);
            if fileName
                strRFT{12}=['Re-referencing: ',paramPreProcess.fileHeader{iE}.refType,' (',fileName,')'];
                paramPreProcess.fileHeader{iE}.refType= str{sPos};
                paramPreProcess.fileHeader{iE}.fnHeadModel = [pathName,fileName];
            else
                set(handles.checkRef,'Value',0)
                paramPreProcess.fileHeader{iE}.refType = 'none';
                strRFT{12}='Re-referencing: no';
            end
        else
            strRFT{12}=['Re-referencing: ',paramPreProcess.fileHeader{iE}.refType];
        end
    else
        set(handles.checkRef,'Value',0)
        paramPreProcess.fileHeader{iE}.refType = 'none';
        strRFT{12}='Re-referencing: no';
    end
    set(handles.fileTextR,'Visible','on','String',strRFT);
    
    set(handles.pushOK2,'Enable','on');
    set(handles.checkCompY,'Enable','on');
    set(handles.checkSelL,'Enable','on');
    set(handles.checkRef,'Enable','on');
else
    paramPreProcess.fileHeader{iE}.refType= 'none';
    if isfield(paramPreProcess.fileHeader{iE},'fnHeadModel')
        paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'fnHeadModel');
    end 
    strRFT{12}='Re-referencing: no';
    set(handles.fileTextR,'Visible','on','String',strRFT);
end

guidata(hObject,handles)


% --- Executes on button press in corrValues.
function corrValues_Callback(hObject, eventdata, handles)
% hObject    handle to corrValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');    
else
    iE=paramPreProcess.fileIndx;
end

%%%%% remove  old values 
paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'lenEpoch');
paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'lenEpochUnit');
paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'lenOverlap');
paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'lenOverlapUnit');
%if isfield(paramPreProcess.fileHeader{iE},'new_sampleFreq')
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'new_sampleFreq');
%end
%if isfield(paramPreProcess.fileHeader{iE},'decimationFactor')
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'decimationFactor');
%end
%if isfield(paramPreProcess.fileHeader{iE},'filterFile')
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'filterFile');
%end
%if isfield(paramPreProcess.fileHeader{iE},'eventsProcessFile')
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'eventsProcessFile');
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'eventsPathName');
%end
%if isfield(paramPreProcess.fileHeader{iE},'refType')
%    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'refType');
%end

strFT =[{paramPreProcess.fileName{iE}}; {'--------------------------------'}];
%strRFT=[{};{}]; 
if isfield(paramPreProcess.fileHeader{iE},'sampleFreq')
    str=['Sampling frequency: ',num2str(paramPreProcess.fileHeader{iE}.sampleFreq), ... 
       ' [',paramPreProcess.fileHeader{iE}.sampleFreqUnit,']'];       
    strFT=[strFT; {str}];
    strFT=[strFT; {'--------------------------------'}];
end

set(handles.fileText,'String',strFT,'Visible','on');
set(handles.fileTextR,'Visible','off','String',[]);
set(handles.textJoinSeg,'Visible','on'); 
set(handles.checkboxJoinSeg,'Visible','on','Value',0); 
%set(handles.fileTextR,'String',strRFT,'Visible','on');
if  isfield(paramPreProcess.fileHeader{iE},'sampleFreq')
    set(handles.samplB,'Visible','on','Value',0);
    set(handles.msecB,'Visible','on','Value',0);
    set(handles.secB,'Visible','on','Value',0);
    set(handles.minB,'Visible','on','Value',0);
else
    set(handles.samplB,'Visible','on','Value',0);
end
set(handles.lenEpoch,'Visible','on','String',[]); 
set(handles.textEpoch,'Visible','on','String','Define epoch''s length');
set(handles.corrValues,'Visible','off'); 
set(handles.pushDone,'Visible','off'); 
 
guidata(hObject,handles) 


% --- Executes on button press in delFile.
function delFile_Callback(hObject, eventdata, handles)
% hObject    handle to delFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNumAll, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','multiple', 'ListString',paramPreProcess.fileName, ...
    'Name', 'Correct file');      
if ok_click
    if paramPreProcess.fileIndx    == 1 %%% the first and the only one
        paramPreProcess.fileIndx    = 0;
        paramPreProcess.fileName    = [];
        paramPreProcess.pathName    = [];
        paramPreProcess=rmfield(paramPreProcess,'fileHeader');
        if ~isempty(findobj('Tag','print param'))
            close(findobj('Tag','print param'));
        end
        if isfield(handles,'listboxSum')
            set(handles.listboxSum,'Visible','off');
        end
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.loadParam,'Visible','on','Enable','on');
    else
        paramPreProcess.fileIndx  = paramPreProcess.fileIndx  - length(listNumAll);
        paramPreProcess.fileName(listNumAll) = [];
        paramPreProcess.pathName(listNumAll) = [];
        paramPreProcess.fileHeader(listNumAll) = [];
        set(handles.loadFile,'Visible','on','Enable','on');
        handles = printParameters(paramPreProcess, handles);
    end
    if paramPreProcess.fileIndx > 0
        set(handles.loadFile,'Visible','on');
        set(handles.repFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
    end    
else
    set(handles.loadFile,'Visible','on');
    set(handles.repFile,'Visible','on');
    set(handles.delFile,'Visible','on');
    set(handles.corrFile,'Visible','on');
    set(handles.pushFinishSelection,'Visible','on');
end
guidata(hObject,handles)


% --- Executes on button press in repFile.
function repFile_Callback(hObject, eventdata, handles)
% hObject    handle to repFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select file which parameteres to replicate', ...
    'SelectionMode','single', 'ListString',paramPreProcess.fileName, ...
    'Name', 'Select file to replicate');

if ok_click
    [fileName, pathName, filtInd] = uigetfile ({'./Data/RawData/*.mat'},'Open File','MultiSelect', 'on');
    pathName=getRelPath(pathName); 
    
    if filtInd
        fileIn = false;strFileIn = [];
        if iscell(fileName)
            lenFile = length(fileName);
            fileInd = ones(lenFile,1);
            for i=1:lenFile
                if sum(strcmp(paramPreProcess.fileName,fileName{i})) && sum(strcmp(paramPreProcess.pathName,pathName))
                    fileIn = true;
                    strFileIn = [strFileIn, ',', fileName{i}];
                    fileInd(i)=0;
                end
            end
        else
            lenFile = 1; fileInd = 1;
            if sum(strcmp(paramPreProcess.fileName,fileName)) && sum(strcmp(paramPreProcess.pathName,pathName))
                fileIn = true;
                strFileIn = [strFileIn, ',', fileName];
                fileInd = 0;
            end
        end
        if fileIn
            strFileIn = ['These file(s) are alrady in: ',strFileIn(2:end), '.... will not be added !!!'];
            hE=errordlg(strFileIn,'Warning - file(s) alrady in');
            uiwait(hE);
        end
        for i=1:lenFile
            if fileInd(i) == 1
                if iscell(fileName)
                    fName=fileName{i};
                else
                    fName=fileName;
                end
                strF=strcat(pathName,fName);
                load(strF,'header')
                if ~exist('header','var')
                    strH = ['Header not present in the', fileName{i},' file ... will not be included'];
                    hE=errordlg(strH,'Error - header missing');
                    uiwait(hE);
                else
                    iE = paramPreProcess.fileIndx + 1;
                    paramPreProcess.fileIndx = iE;
                    paramPreProcess.fileHeader{iE} = header;
                    paramPreProcess.fileName{iE} = fName;
                    paramPreProcess.pathName{iE} = pathName;
                    %%%% copy other parameters
                    fNnew = fieldnames(paramPreProcess.fileHeader{iE});
                    fNold = fieldnames(paramPreProcess.fileHeader{listNum});
                    for fNi = 1:length(fNold)
                        if ~strcmp(fNold{fNi},fNnew)
                            str =['paramPreProcess.fileHeader{iE}.',fNold{fNi},'=paramPreProcess.fileHeader{listNum}.',fNold{fNi},';'];
                            eval(str)
                        end
                    end                    
                end
            end
        end
    end
end

handles = printParameters(paramPreProcess, handles);

set(handles.loadFile,'Visible','on');
set(handles.repFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


guidata(hObject,handles) 


% --- Executes on button press in corrFile.
function corrFile_Callback(hObject, eventdata, handles)
% hObject    handle to corrFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

set(handles.loadFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','single', 'ListString',paramPreProcess.fileName, ...
    'Name', 'Correct file');

if ok_click
    set(handles.corrFile,'UserData',listNum); %%% correction true     
    set(handles.loadFile,'Visible','off')
    set(handles.loadParam,'Visible','off');
    set(handles.lenEpoch,'Visible','on','String',[]);
    set(handles.topPanel,'Visible','on');
    set(handles.textEpoch,'Visible','on','String','Define epoch''s length');
    strFT=[{paramPreProcess.fileName{listNum}}; {'--------------------------------'}];
    if isfield(paramPreProcess.fileHeader{listNum},'sampleFreq')
        str=['Sampling frequency: ',num2str(paramPreProcess.fileHeader{listNum}.sampleFreq)];
        strFT=[strFT; {str}];
        strFT=[strFT; {'--------------------------------'}];
    end
    set(handles.fileText,'String',strFT,'Visible','on');
    set(handles.samplB,'Visible','on','Value',0);
    set(handles.msecB,'Visible','on','Value',0);
    set(handles.secB,'Visible','on','Value',0);
    set(handles.minB,'Visible','on','Value',0);
    set(handles.textJoinSeg,'Visible','on'); 
    set(handles.checkboxJoinSeg,'Visible','on','Value',0); 
    
    %%%% remove values 
    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'lenEpoch');
    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'lenEpochUnit');
    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'lenOverlap');
    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'lenOverlapUnit');
    %if isfield(paramPreProcess.fileHeader{listNum},'new_sampleFreq')
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'new_sampleFreq');
    %end 
    %if isfield(paramPreProcess.fileHeader{listNum},'decimationFactor') 
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'decimationFactor');
    %end  
    %if isfield(paramPreProcess.fileHeader{listNum},'eventsProcessFile')
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'eventsProcessFile');
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'eventsPathName');
    %end
    %if isfield(paramPreProcess.fileHeader{listNum},'filterFile')
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'filterFile');
    % end
    %if isfield(paramPreProcess.fileHeader{listNum},'refType')
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'refType');
    %end
else
    set(handles.loadFile,'Visible','on');
    set(handles.delFile,'Visible','on');
    set(handles.corrFile,'Visible','on');
    set(handles.repFile,'Visible','on');
    set(handles.pushFinishSelection,'Visible','on');
    
end    
guidata(hObject,handles)


% --- Executes on button press in pushFinishSelection.
function pushFinishSelection_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinishSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loadFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');

set(handles.pushGenSet,'Visible','on');
set(handles.pushSaveParam,'Visible','on');
set(handles.pushFinish,'Visible','on');
set(handles.pushGoBack,'Visible','on');

guidata(hObject,handles)

% --- Executes on button press in pushGoBack.
function pushGoBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushGoBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushGenSet,'Visible','off');
set(handles.pushSaveParam,'Visible','off');
set(handles.pushFinish,'Visible','off');
set(handles.pushGoBack,'Visible','off');

set(handles.loadFile,'Visible','on');
set(handles.repFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


guidata(hObject,handles)

% --- Executes on button press in pushFinish.
function pushFinish_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

set(handles.pushGenSet,'Visible','on');
set(handles.pushSaveParam,'Visible','on');

%pSave= get(handles.pushSaveParam,'UserData') ; 
%if pSave

if isfield(paramPreProcess,'paramSaveFile')
    save(paramPreProcess.paramSaveFile,'paramPreProcess');
    close(handles.figure1);    
else
    hD=questdlg('Parameters not saved .... Continue anyway?', ...
        'Parameters not saved !','yes','no','no');
    switch hD
        case 'yes'
            close(handles.figure1);
        case 'no'
            %%% do nothing here, keep loop
    end
end

% --- Executes on button press in pushSaveParam.
function pushSaveParam_Callback(hObject, eventdata, handles)
% hObject    handle to pushSaveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ... 
                                  'Save parameters as ...','./ParameterFiles/param_PreProcess.mat');                              
pathName=getRelPath(pathName);

if fName
    str=strcat(pathName,fName);
    paramPreProcess.paramSaveFile=str; 
    handles = printParameters(paramPreProcess,handles);   
    save(str,'paramPreProcess'); 
    %set(handles.pushSaveParam,'UserData',true);
end 
guidata(hObject,handles)


% --- Executes on button press in pushGenSet.
function pushGenSet_Callback(hObject, eventdata, handles)
% hObject    handle to pushGenSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramPreProcess

set(handles.pushGenSet,'Enable','off');
set(handles.pushSaveParam,'Enable','off');
set(handles.pushFinish,'Enable','off');
set(handles.pushGoBack,'Enable','off');

pathName = uigetdir('./Data/EpochedData','Select folder where to save epoched data ...');
pathName=getRelPath(pathName); 

if pathName 
    %hW=warndlg('Working ..... ');
    paramPreProcess.pathEpochedData = pathName;  
    preProcessData(paramPreProcess); 
    %close(hW) 
else 
    
end 

   
set(handles.pushGenSet,'Enable','on');
set(handles.pushSaveParam,'Enable','on');
set(handles.pushFinish,'Enable','on');
set(handles.pushGoBack,'Enable','on');

guidata(hObject,handles)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = printParameters(param,handles)     

if param.fileIndx > 0
    if isfield(param,'paramSaveFile')        
        strLB={['Parameters Summary (save to: ',param.paramSaveFile,'):']};
    else
        strLB={'Parameters Summary (save to: ???):'};
    end
    for i=1:param.fileIndx
        pStr=strcat(int2str(i),')');
        strLB=[strLB;pStr;param.fileName{i}];
        if isfield(param.fileHeader{i},'sampleFreq');
            pStr=['sampling freq: ',int2str(param.fileHeader{i}.sampleFreq), ...
                ' [',param.fileHeader{i}.sampleFreqUnit,']'];
            strLB=[strLB;pStr];
        end
        if param.fileHeader{i}.joinSeg
            pStr=['join disc. seg.: true'];
        else
            pStr=['join disc. seg.: false'];
        end
        strLB=[strLB;pStr];
        pStr=['epoch length: ',num2str(param.fileHeader{i}.lenEpoch), ...
            ' [',param.fileHeader{i}.lenEpochUnit,']'];
        strLB=[strLB;pStr];
        pStr=['overlap: ',num2str(param.fileHeader{i}.lenOverlap), ...
            ' [',param.fileHeader{i}.lenOverlapUnit,']'];
        strLB=[strLB;pStr];        
        if isfield(param.fileHeader{i},'new_sampleFreq');
            pStr=['new sampling freq: ',int2str(param.fileHeader{i}.new_sampleFreq), ...
                ' [',param.fileHeader{i}.sampleFreqUnit,']'];
            strLB=[strLB;pStr];
        elseif isfield(param.fileHeader{i},'decimationFactor')
            pStr=['decimation factor: ',int2str(param.fileHeader{i}.decimationFactor)];
            strLB=[strLB;pStr];
        end
        if isfield(param.fileHeader{i},'filterFile');
            load(param.fileHeader{i}.filterFile,'dM','fM')
            if strcmp(dM.Response,'Bandstop')
                nstr=['filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass1),'-',num2str(dM.Fpass2), ... 
                    '//',fM.FilterStructure,'//', '(',param.fileHeader{i}.filterFile,')'];
            else
                nstr=['filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass), ...
                    '//',fM.FilterStructure,'//', '(',param.fileHeader{i}.filterFile,')'];
            end
            strLB=[strLB;nstr];
        else 
            strLB=[strLB ; 'filtering: no'];
        end 
        if isfield(param.fileHeader{i},'notchFilter');
            pStr=['notch filtering: ',num2str(param.fileHeader{i}.notchFilter),' [Hz]'];
            strLB=[strLB;pStr];
        else
            strLB=[strLB ; 'notch filtering: no'];
        end
        if isfield(param.fileHeader{i},'Xlabels2use')            
            if length(param.fileHeader{i}.Xlabels2use) < length(param.fileHeader{i}.Xlabels)
                pStr='variables to use: ';
                for sI=1:length(param.fileHeader{i}.Xlabels2use)
                    pStr=[pStr,regexprep(param.fileHeader{i}.Xlabels2use{sI},'[^\w'']',''),','];
                end
                pStr=pStr(1:end-1);
            else
                pStr='variables to use: all';
            end
            strLB=[strLB;pStr];
        else            
            strLB=[strLB ; 'used variables: all'];
        end 
        if isfield(param.fileHeader{i},'eventsProcessFile');
            pStr=['processing events: yes (',param.fileHeader{i}.eventsPathName,param.fileHeader{i}.eventsProcessFile,')'];
            strLB=[strLB;pStr];
        else
            pStr=strcat('processing events: no');
            strLB=[strLB;pStr];
        end
        %%% re-referncing type
        if isfield(param.fileHeader{i},'refType');
            if regexpi(param.fileHeader{i}.refType,'Laplacian')
                strLB=[strLB; ['re-referencing: ',param.fileHeader{i}.refType, ... 
                          ' (',param.fileHeader{i}.fnHeadModel,')']];
            else
                strLB=[strLB; ['re-referencing: ',param.fileHeader{i}.refType]];
            end
            
        end
    end
%    set(listB,'String',strLB)
end
if ~isfield(handles,'listboxSum')
    handles.listboxSum=uicontrol('Parent',handles.figure1,'Style','listbox', ... 
        'Units','normalized', ...
        'Position',[0.65 0.01 0.4 0.98], ... 
        'Selected','off','SelectionHighlight','off');
end 
set(handles.listboxSum,'Value',1);
set(handles.listboxSum,'String',strLB)
set(handles.listboxSum,'Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = handles_set1(handles)
%%% nothing here ..... can be added laters 

function handles = handles_set2(handles,param,iE)

set(handles.lenOverlap,'Visible','off','String',[]);
set(handles.samplB,'Visible','off','Enable','on');
set(handles.msecB,'Visible','off');
set(handles.secB,'Visible','off');
set(handles.minB,'Visible','off');
set(handles.textEpoch,'Visible','off');



%set(handles.checkRes,'Visible','on');
%set(handles.checkFilt,'Visible','on');
set(handles.checkNotchFilt,'Visible','on');
set(handles.pushOK1,'Visible','on'); 

%%%% right text
if isfield(param.fileHeader{iE},'sampleFreq')
    if isfield(param.fileHeader{iE},'new_sampleFreq')
        nstr=['New sampling frequency: ',num2str(param.fileHeader{iE}.new_sampleFreq), ...
            ' [',param.fileHeader{iE}.sampleFreqUnit,']'];
        strRFT(1)={nstr};
        set(handles.checkRes,'Visible','on','Value',1);
    else
        strRFT(1)={'Re-sampling: no'};
        set(handles.checkRes,'Visible','on','Value',0);
    end
    %if isfield(paramPreProcess.fileHeader{listNum},'decimationFactor')
    %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'decimationFactor');
    %end
else 
    if isfield(param.fileHeader{iE},'decimationFactor')
        param.fileHeader{iE}.decimationFactor = nsf;
        nstr=['Decimation factor: ',num2str(param.fileHeader{iE}.decimationFactor)];
        strRFT(1)={nstr};
        set(handles.checkRes,'Visible','on','Value',1);
    else
        strRFT(1)={'Decimation: no'};
        set(handles.checkRes,'Visible','on','Value',0);
    end
end
strRFT(2)={'--------------------------------'};
if isfield(param.fileHeader{iE},'filterFile')
    load(param.fileHeader{iE}.filterFile,'dM','fM')
    if strcmp(dM.Response,'Bandstop')
        nstr=['filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass1),'-',num2str(dM.Fpass2), ...
            '//',fM.FilterStructure,'//', '(',param.fileHeader{iE}.filterFile,')'];
    else
        nstr=['filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass), ...
            '//',fM.FilterStructure,'//', '(',param.fileHeader{iE}.filterFile,')'];
    end
    strRFT(3)={nstr};
    set(handles.checkFilt,'Visible','on','Value',1);
else
    strRFT(3)={'Filtering: no'};
    set(handles.checkFilt,'Visible','on','Value',0);
end
strRFT(4)={'--------------------------------'};
if isfield(param.fileHeader{iE},'notchFilter'); 
    nstr=['Notch Filter: ',num2str(param.fileHeader{iE}.notchFilter),' [Hz]'];
    strRFT(5)={nstr};
    set(handles.checkNotchFilt,'Visible','on','Value',1);
else
    strRFT(5)={'Notch Filter: no'};
    set(handles.checkFilt,'Visible','on','Value',0);
end
strRFT(6)={'--------------------------------'};

set(handles.fileTextR,'Visible','on','String',strRFT);

function outC = checkCorrOver(lenO,unitV,param)

switch unitV
    case 'msec'
        switch param.lenEpochUnit
            case 'msec'
                lenE=param.lenEpoch;
            case 'sec'
                lenE=param.lenEpoch*1000;
            case 'min'
                lenE=param.lenEpoch*60*1000;
        end
    case 'sec'
        switch param.lenEpochUnit
            case 'msec'
                lenE=param.lenEpoch/1000;
            case 'sec'
                lenE=param.lenEpoch;
            case 'min'
                lenE=param.lenEpoch*60;
        end
    case 'min'
        switch param.lenEpochUnit
            case 'msec'
                lenE=(param.lenEpoch/1000)*60;
            case 'sec'
                lenE=param.lenEpoch/60;
            case 'min'
                lenE=param.lenEpoch;
        end
end

if lenO > lenE
    outC = false;
else
    outC = true;
end
        


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'listboxSum')
    set(handles.listboxSum,'Position',[0.65 0.01 0.4 0.98]); 
   %  handles = printParameters(paramGenFeatures,handles,true) ; 
end
guidata(hObject,handles)


% --- Executes on button press in checkNotchFilt.
function checkNotchFilt_Callback(hObject, eventdata, handles)
% hObject    handle to checkNotchFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
    iE=paramPreProcess.fileIndx;
end

if get(handles.checkNotchFilt,'Value')
    set(handles.checkNotchFilt,'Enable','off'); % ,'Value',0);
     set(handles.checkFilt,'Enable','off');
    set(handles.checkRes,'Enable','off');
    set(handles.pushOK1,'Enable','off');
 
    set(handles.textNotch,'Visible','on');
    set(handles.editNotch,'Visible','on'); 
    
    
else
    paramPreProcess.fileHeader{iE}=rmfield(paramPreProcess.fileHeader{iE},'notchFilter');
    strRFT = get(handles.fileTextR,'String');
    strRFT(5)={'Notch Filtering: no'};
    set(handles.checkNotchFilt,'Enable','on','Value',0);
    set(handles.fileTextR,'Visible','on','String',strRFT);  
end     





function editNotch_Callback(hObject, eventdata, handles)
% hObject    handle to editNotch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess 

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData'); 
   % set(handles.corrFile,'UserData',[]);
else
    iE=paramPreProcess.fileIndx;
end
    
nsf=str2double(get(handles.editNotch,'String'));
if isfloat(nsf) && nsf > 0
    paramPreProcess.fileHeader{iE}.notchFilter = nsf;
    strRFT = get(handles.fileTextR,'String');
    strRFT{5}=['Notch Filtering: ',get(handles.editNotch,'String'),'[Hz]'];
    set(handles.fileTextR,'Visible','on','String',strRFT);  
    set(handles.checkRes,'Enable','on');
    set(handles.checkFilt,'Enable','on');
    set(handles.checkNotchFilt,'Enable','on','Value',1);
    set(handles.pushOK1,'Enable','on');
    set(handles.textNotch,'Visible','off');
    set(handles.editNotch,'Visible','off','String',[]);  
end


guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function editNotch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNotch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxJoinSeg.
function checkboxJoinSeg_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxJoinSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramPreProcess

guidata(hObject,handles) 

