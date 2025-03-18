function varargout = gui_genFeatures(varargin)
% GUI_GENFEATURES MATLAB code for gui_genFeatures.fig
%      GUI_GENFEATURES, by itself, creates a new GUI_GENFEATURES or raises the existing
%      singleton*.
%
%      H = GUI_GENFEATURES returns the handle to a new GUI_GENFEATURES or the handle to
%      the existing singleton*.
%
%      GUI_GENFEATURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GENFEATURES.M with the given input arguments.
%
%      GUI_GENFEATURES('Property','Value',...) creates a new GUI_GENFEATURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_genFeatures_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_genFeatures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_genFeatures

% Last Modified by GUIDE v2.5 15-Mar-2017 10:02:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_genFeatures_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_genFeatures_OutputFcn, ...
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


% --- Executes just before gui_genFeatures is made visible.
function gui_genFeatures_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_genFeatures (see VARARGIN)

clear global
%global paramGenFeatures

set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.25 0.25 0.6 0.6]); 

% pacdel = imread('./M-files/fire_features.jpg');
% axis off          % Remove axis ticks and numbers
% ha = axes('units','normalized','position',[0 0 1 1]);
% imagesc(pacdel)
% set(ha,'handlevisibility','off', 'visible','off')

% Choose default command line output for gui_genFeatures
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_genFeatures wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_genFeatures_OutputFcn(hObject, eventdata, handles) 
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
global paramGenFeatures

set(handles.corrFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');

set(handles.loadFile,'Enable','off');
set(handles.loadParam,'Enable','off');

[fileName, pathName] = uigetfile ({'./Data/EpochedData/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 



if isfield(paramGenFeatures,'fileIndx') && sum(strcmp(paramGenFeatures.fileName,fileName)) && sum(strcmp(paramGenFeatures.pathName,pathName))
    hE=warndlg('This file is already in .... !!','Warning - file alrady in');
    uiwait(hE);
    toDo = 3;
elseif fileName
    %%% load header file
    strF=strcat(pathName,fileName);
    load(strF,'header')
    if ~exist('header','var')
        hE=errordlg('Header is not present in the file ...','Error - header missing');
        uiwait(hE);
        toDo = 1;
    else
        if isfield(paramGenFeatures,'fileIndx')
            paramGenFeatures.fileIndx = paramGenFeatures.fileIndx + 1;
        else
            paramGenFeatures.fileIndx = 1;
        end
        paramGenFeatures.fileName{paramGenFeatures.fileIndx} = fileName;
        paramGenFeatures.pathName{paramGenFeatures.fileIndx} = pathName;
        paramGenFeatures.fileHeader{paramGenFeatures.fileIndx} = header;
        toDo = 2;
    end
elseif  isfield(paramGenFeatures,'fileIndx')    
    toDo = 3; 
else     
    toDo = 1; 
end

switch toDo 
    case 1 
      set(handles.loadFile,'Enable','on') 
      set(handles.loadParam,'Enable','on'); 
    case 2 
      handles = printParameters(paramGenFeatures,handles);     
      set(handles.loadFile,'Visible','off')    
      set(handles.loadParam,'Visible','off'); 
      
      set(handles.textFile,'Visible','on','String',fileName)
      set(handles.butPSD,'Visible','on','Value',0); 
      set(handles.butCoherence,'Visible','on','Value',0); 
      set(handles.butWT,'Visible','on','Value',0); 
      set(handles.butNP,'Visible','on','Value',0); 
      set(handles.butIRASA,'Visible','on','Value',0); 
      set(handles.textMethod,'Visible','on','String','Select type of features to compute:'); 
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
global paramGenFeatures

set(handles.loadFile,'Enable','off'); 
set(handles.loadParam,'Enable','off'); 

[fileName, pathName] = uigetfile ({'./ParameterFiles/*.mat'},'Open File'); 
pathName=getRelPath(pathName);  

if fileName
    %%% load parameters    
    strF=strcat(pathName,fileName);
    warning off 
    s=load(strF,'paramGenFeatures');
    warning on 
        
    if ~isfield(s,'paramGenFeatures')       
        hE=msgbox([fileName,' is not a correct parameter''s file'],'Error - not parameter''s file','error');
        uiwait(hE);
        set(handles.loadFile,'Enable','on'); 
        set(handles.loadParam,'Enable','on');          
    else
        paramGenFeatures=s.paramGenFeatures;            
        %handles = printParameters(paramGenFeatures, handles);        
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
        % disp('ok')
        %%%% open print window for sumarry 
        handles = printParameters(paramGenFeatures,handles); 
        
        set(handles.loadParam,'Visible','off');
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.repFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
        % refresh 
    end
else 
    set(handles.loadFile,'Visible','on','Enable','on');
    set(handles.loadParam,'Visible','on','Enable','on');
end

guidata(hObject,handles)


% --- Executes on button press in butPSD.
function butPSD_Callback(hObject, eventdata, handles)
% hObject    handle to butPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.butAR,'Visible','off','Value',0);
set(handles.butCoherence,'Visible','off','Value',0);
set(handles.butPSD,'Visible','off','Value',1);
set(handles.butWT,'Visible','off','Value',0);
set(handles.butNP,'Visible','off','Value',0);
set(handles.butIRASA,'Visible','off','Value',0); 

paramGenFeatures.fileHeader{iE}.featureType = 'psd'; 

set(handles.textMethod,'Visible','on','String','Select psd method:'); 
set(handles.textWinType,'Visible','on'); 
set(handles.textSpecType,'Visible','on'); 

if isfield(paramGenFeatures.fileHeader{iE},'sampleFreq')
    switch paramGenFeatures.fileHeader{iE}.sampleFreqUnit
        case 'Hz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq;
        case 'kHz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq*1000;
    end
    switch paramGenFeatures.fileHeader{iE}.lenEpochUnit
        case 'samples'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch;
            fsFactor = 1;
        case 'msec'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch/1000;
        case 'sec'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch;
        case 'min'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch*60;
    end
    nFFT=fsFactor*lenE;
else
    if isfield(param,'decimationFactor')
        nFFT = round(paramGenFeatures.fileHeader{iE}.lenEpoch/paramGenFeatures.fileHeader{iE}.decimationFactor);       
    else
        nFFT = paramGenFeatures.fileHeader{iE}.lenEpoch;        
    end    
end
paramGenFeatures.fileHeader{iE}.nFFT = nFFT; 

%%%initial fft 
%datTab=[{'# of FFT points'} , num2str(nFFT)];

datTab=[{'# subsets'} , num2str(1) ; {'linear detrend (yes/no)'}, 'yes' ; {'normalize to uV(2)/Hz (yes/no)'}, 'yes'];
set(handles.tableParam,'Data',datTab, ...
    'Columnwidth',{150,50},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  ....
    'RowName',[],'Visible','on');

set(handles.textParam,'String','Parameters for FFT:', 'Visible','on'); 

set(handles.pushOK_1,'Visible','on'); 

set(handles.selMethod,'Value',1); 
set(handles.selMethod,'Visible','on','String',{'fft','welch','thomson'});

set(handles.WinType,'Value',3); 
set(handles.WinType,'Visible','on','String',{'none','hamming','hann','blackman','tukey'});

set(handles.psdSpecType,'Value',1); 
set(handles.psdSpecType,'Visible','on','String',{'power','log_power','log_power+','amplitude','log_amp','log_amp+'});

guidata(hObject,handles) 

% --- Executes on button press in butCoherence.
function butCoherence_Callback(hObject, eventdata, handles)
% hObject    handle to butCoherence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.butAR,'Visible','off','Value',0);
set(handles.butCoherence,'Visible','off','Value',1);
set(handles.butPSD,'Visible','off','Value',0);
set(handles.butWT,'Visible','off','Value',0);
set(handles.butNP,'Visible','off','Value',0);
set(handles.butIRASA,'Visible','off','Value',0); 

paramGenFeatures.fileHeader{iE}.featureType = 'coherence';


set(handles.textMethod,'Visible','on','String','Select coherence method:'); 
set(handles.textWinType,'Visible','on'); 
%set(handles.textSpecType,'Visible','on'); 

if isfield(paramGenFeatures.fileHeader{iE},'sampleFreq')
    switch paramGenFeatures.fileHeader{iE}.sampleFreqUnit
        case 'Hz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq;
        case 'kHz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq*1000;
    end
    switch paramGenFeatures.fileHeader{iE}.lenEpochUnit
        case 'samples'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch;
            fsFactor = 1;
        case 'msec'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch/1000;
        case 'sec'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch;
        case 'min'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch*60;
    end
    nFFT=fsFactor*lenE;
else
    if isfield(param,'decimationFactor')
        nFFT = round(paramGenFeatures.fileHeader{iE}.lenEpoch/paramGenFeatures.fileHeader{iE}.decimationFactor);       
    else
        nFFT = paramGenFeatures.fileHeader{iE}.lenEpoch;        
    end    
end
paramGenFeatures.fileHeader{iE}.nFFT = nFFT; 

%%%initial fft 
lenWin=round(paramGenFeatures.fileHeader{iE}.nFFT/8); %%% takes 1/8 of the epoch length 
strD(1)={num2str(lenWin)};
lenWinOverlap = lenWin / 2 ; %%% 50% overlap 
strD(2)={num2str(lenWinOverlap)};
strD(3)={num2str(round(paramGenFeatures.fileHeader{iE}.nFFT))};
datTab=[{'window length';'window overlap';'# of FFT points'} , {strD{1};strD{2};strD{3}}];        
set(handles.tableParam,'Data',datTab, ... 
    'Columnwidth',{130,50},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  .... 
    'RowName',[],'Visible','on');  

set(handles.textParam,'String','Parameters for ''cpsd.m'':', 'Visible','on');

set(handles.pushOK_1,'Visible','on'); 
set(handles.selMethod,'Value',1); 
set(handles.selMethod,'Visible','on','String',{'cpsd','mscohere','tfestimate','moody'});

set(handles.WinType,'Value',3); 
set(handles.WinType,'Visible','on','String',{'none','hamming','hann','blackman','tukey'});

guidata(hObject,handles) 



% --- Executes on button press in butWT.
function butWT_Callback(hObject, eventdata, handles)
% hObject    handle to butWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures


set(handles.butAR,'Visible','off','Value',0);
set(handles.butCoherence,'Visible','off','Value',0);
set(handles.butPSD,'Visible','off','Value',0);
set(handles.butWT,'Visible','off','Value',1);
set(handles.butNP,'Visible','off','Value',0);
set(handles.butIRASA,'Visible','off','Value',0); 

set(handles.textMethod,'Visible','on','String','Select type of wavelet  transform:'); 
set(handles.butCWT,'Visible','on','Value',0);
set(handles.butDWT,'Visible','on','Value',0);

guidata(hObject,handles) 


% --- Executes on button press in butCWT.
function butCWT_Callback(hObject, eventdata, handles)
% hObject    handle to butCWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

paramGenFeatures.fileHeader{iE}.featureType = 'cwt'; 
paramGenFeatures.fileHeader{iE}.cwtUnit     = 'scales'; 

set(handles.textMethod,'Visible','on','String','Select Type of CWT:'); 
set(handles.textScales,'Visible','on','String','Define Scales:'); 
set(handles.butDefFreq,'Visible','on'); 
set(handles.butCWT,'Visible','off','Value',1);
set(handles.butDWT,'Visible','off','Value',0);


set(handles.WaveType,'Value',1); 
set(handles.WaveType,'Visible','on','String',{'cMorlet','cGaussian','Shannon','FreqB-Spline','Haar','Morlet','Symlets','Daubechies'}); 

%%%%% show initial cMorlet case
strT={'cmor1-1.5','cmor1-1','cmor1-0.5','cmor1-1','cmor1-0.5','cmor1-0.1'};
set(handles.SubWaveType,'Value',1);
set(handles.SubWaveType,'Visible','on','String',strT);
set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:');
set(handles.procWTcoef,'Value',1);
set(handles.procWTcoef,'Visible','on','String',{'none','ITPC','ITLC','ERSP','WTav','avWT','WTav-avWT'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



set(handles.ScaleTab,'Visible','on'); 

set(handles.pushOK_1,'Visible','on'); 

guidata(hObject,handles) 


% --- Executes on button press in butIRASA.
function butIRASA_Callback(hObject, eventdata, handles)
% hObject    handle to butIRASA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.butAR,'Visible','off','Value',0);
set(handles.butCoherence,'Visible','off','Value',0);
set(handles.butPSD,'Visible','off','Value',1);
set(handles.butWT,'Visible','off','Value',0);
set(handles.butNP,'Visible','off','Value',0);
set(handles.butIRASA,'Visible','off','Value',0);

paramGenFeatures.fileHeader{iE}.featureType = 'irasa'; 

set(handles.textMethod,'Visible','off'); 
set(handles.textWinType,'Visible','on'); 
%set(handles.textSpecType,'Visible','on'); 

if isfield(paramGenFeatures.fileHeader{iE},'sampleFreq')
    switch paramGenFeatures.fileHeader{iE}.sampleFreqUnit
        case 'Hz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq;
        case 'kHz'
            fsFactor  = paramGenFeatures.fileHeader{iE}.sampleFreq*1000;
    end
    switch paramGenFeatures.fileHeader{iE}.lenEpochUnit
        case 'samples'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch;
            fsFactor = 1;
        case 'msec'
            lenE = paramGenFeatures.fileHeader{iE}.lenEpoch/1000;
        case 'sec'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch;
        case 'min'
            lenE=paramGenFeatures.fileHeader{iE}.lenEpoch*60;
    end
    nFFT=fsFactor*lenE;
else
    if isfield(param,'decimationFactor')
        nFFT = round(paramGenFeatures.fileHeader{iE}.lenEpoch/paramGenFeatures.fileHeader{iE}.decimationFactor);       
    else
        nFFT = paramGenFeatures.fileHeader{iE}.lenEpoch;        
    end    
end
paramGenFeatures.fileHeader{iE}.nFFT = nFFT; 

%%%initial nfft 
datTab=[{'# subsets'} , num2str(1) ; {'hset'},'1.1:0.05:1.9'; {'linear detrend (yes/no)'}, 'yes';{'rectify osc. part (yes/no)'},'yes';{'normalize to uV(2)/Hz (yes/no)'}, 'yes']; 
set(handles.tableParam,'Data',datTab, ... 
    'Columnwidth',{180,100},'ColumnName',[],'ColumnFormat', {'char' , 'char'},'ColumnEditable',[false,true],  .... 
    'RowName',[],'Visible','on'); 
set(handles.textParam,'String','Define IRASA parameters:', 'Visible','on'); 

set(handles.pushOK_1,'Visible','on'); 

%set(handles.selMethod,'Value',1); 
%set(handles.selMethod,'Visible','on','String',{'fft','welch','thomson'});

set(handles.WinType,'Value',3); 
set(handles.WinType,'Visible','on','String',{'none','hamming','hann','blackman','tukey'});

set(handles.psdSpecType,'Value',1); 
set(handles.psdSpecType,'Visible','on','String',{'power','log_power','log_power+','amplitude','log_amp','log_amp+'});

guidata(hObject,handles) 

% --- Executes on selection change in WaveType.
function WaveType_Callback(hObject, eventdata, handles)
% hObject    handle to WaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.WaveType,'String');
pos = get(handles.WaveType,'Value');

%%% define wavelet subtype 
switch  str{pos}
    case 'cMorlet'
        strT={'cmor1-1.5','cmor1-1','cmor1-0.5','cmor1-1','cmor1-0.5','cmor1-0.1'};
        set(handles.SubWaveType,'Value',1); 
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:'); 
    case 'cGaussian'
        for s=1:5
            strT{s}=['cgau',num2str(s)];
        end
        set(handles.SubWaveType,'Value',1);
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:');
    case 'Shannon'
        strT={'shan1-1.5','shan1-1','shan1-0.5','shan1-0.1','shan2-3'};
        set(handles.SubWaveType,'Value',1);
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:');  
    case 'FreqB-Spline'
        strT={'fbsp1-1-1.5','fbsp1-1-1','fbsp1-1-0.5','fbsp2-1-1','fbsp2-1-0.5','fbsp2-1-0.1'};
        set(handles.SubWaveType,'Value',1);
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:');
    case 'Symlets'
        for s=2:8
            strT{s-1}=['sym',num2str(s)];
        end
        set(handles.SubWaveType,'Value',1); 
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:'); 
    case 'Daubechies'
        for s=1:10
            strT{s}=['db',num2str(s)];
        end
        set(handles.SubWaveType,'Value',1); 
        set(handles.SubWaveType,'Visible','on','String',strT);
        set(handles.textWinType,'Visible','on','String','Select sub-Type of CWF:'); 
    otherwise
        set(handles.SubWaveType,'Visible','off');
        set(handles.textWinType,'Visible','off'); 
end

switch  str{pos}
    case {'Haar','Morlet','Symlets','Daubechies'}
        set(handles.procWTcoef,'Value',1); 
        set(handles.procWTcoef,'Visible','on','String',{'none','ERSP','WTav','avWT','WTav-avWT'});
    case {'cMorlet','cGaussian','Shannon','FreqB-Spline'}
        set(handles.procWTcoef,'Value',1); 
        set(handles.procWTcoef,'Visible','on','String',{'none','ITPC','ITLC','ERSP','WTav','avWT','WTav-avWT'});
    otherwise
       set(handles.procWTcoef,'Value',1); 
       set(handles.procWTcoef,'Visible','on','String',{'none'});
end

guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function WaveType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDefFreq.
function butDefFreq_Callback(hObject, eventdata, handles)
% hObject    handle to butDefFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

if get(handles.butDefFreq,'Value') 
    switch paramGenFeatures.fileHeader{iE}.cwtUnit
        case 'scales'
            set(handles.textScales,'Visible','on','String','Define Frequencies:');
            paramGenFeatures.fileHeader{iE}.cwtUnit='freqs'; 
            set(handles.butDefFreq,'String','Use Scales','Value',0); 
        case 'freqs'
            set(handles.textScales,'Visible','on','String','Define Scales:');
            paramGenFeatures.fileHeader{iE}.cwtUnit='scales'; 
            set(handles.butDefFreq,'String','Use Frequencies','Value',0); 
    end 
end


guidata(hObject,handles) 


% --- Executes on button press in butDWT.
function butDWT_Callback(hObject, eventdata, handles)
% hObject    handle to butDWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in butNP.
function butNP_Callback(hObject, eventdata, handles)
% hObject    handle to butNP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.butAR,'Visible','off','Value',1);
set(handles.butCoherence,'Visible','off','Value',0);
set(handles.butPSD,'Visible','off','Value',0);
set(handles.butWT,'Visible','off','Value',0);
set(handles.butNP,'Visible','off','Value',0);
set(handles.textMethod,'Visible','off'); 
set(handles.textFile,'Visible','off'); 

paramGenFeatures.fileHeader{iE}.featureType = 'np';


handles = printParameters(paramGenFeatures,handles);

set(handles.loadFile,'Visible','on','Enable','on');
set(handles.repFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');

guidata(hObject,handles) 

% --- Executes on button press in butAR.
function butAR_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to butAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.butAR,'Visible','off','Value',1);
set(handles.butCoherence,'Visible','off','Value',0);
set(handles.butPSD,'Visible','off','Value',0);
set(handles.butWT,'Visible','off','Value',0);
set(handles.butNP,'Visible','off','Value',0);

paramGenFeatures.fileHeader{iE}.featureType = 'ar';

guidata(hObject,handles) 


% --- Executes on button press in pushOK_1.
function pushOK_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end


set(handles.textMethod,'Visible','off'); 
set(handles.textWinType,'Visible','off'); 
%set(handles.textSpecType,'Visible','off'); 
set(handles.textParam,'Visible','off'); 
set(handles.pushOK_1,'Visible','off');
set(handles.selMethod,'Visible','off');
set(handles.WinType,'Visible','off');
%set(handles.psdSpecType,'Visible','off');
set(handles.tableParam,'Visible','off');

%%%% cwt 
set(handles.textScales,'Visible','off');  
set(handles.WaveType,'Visible','off');
set(handles.SubWaveType,'Visible','off');
set(handles.ScaleTab,'Visible','off'); 
set(handles.procWTcoef,'Visible','off'); 
set(handles.butDefFreq,'Visible','off'); 

switch paramGenFeatures.fileHeader{iE}.featureType
    case 'psd'
        set(handles.textSpecType,'Visible','off');
        set(handles.psdSpecType,'Visible','off');
        %%% psd method
        str = get(handles.selMethod,'String');
        pos = get(handles.selMethod,'Value');
        paramGenFeatures.fileHeader{iE}.psdMethod=str{pos};
        %%% psd window type
        str = get(handles.WinType,'String');
        pos = get(handles.WinType,'Value');
        paramGenFeatures.fileHeader{iE}.psdWindowType=str{pos};
        %%% psd Spectra type
        str = get(handles.psdSpecType,'String');
        pos = get(handles.psdSpecType,'Value');
        paramGenFeatures.fileHeader{iE}.psdSpectraType=str{pos};
        
        %%%% table parameters
        datParam = get(handles.tableParam,'Data');
        switch paramGenFeatures.fileHeader{iE}.psdMethod
            case 'fft'
%                 if isnan(str2double(datParam{1,2}))
%                     paramGenFeatures.fileHeader{iE}.nFFT=[];
%                 else
%                     paramGenFeatures.fileHeader{iE}.nFFT=str2double(datParam{1,2});
%                 end
                datParam = get(handles.tableParam,'Data');
                if isnan(str2double(datParam{1,2}))
                    paramGenFeatures.fileHeader{iE}.nSubset=[];
                else
                    paramGenFeatures.fileHeader{iE}.nSubset=str2double(datParam{1,2});
                end
                if ~strcmp(datParam{2,2},'yes') & ~strcmp(datParam{2,2},'no') 
                    paramGenFeatures.fileHeader{iE}.detrendL=[];
                else
                    paramGenFeatures.fileHeader{iE}.detrendL=(datParam{2,2});
                end
                if ~strcmp(datParam{3,2},'yes') & ~strcmp(datParam{3,2},'no')
                    paramGenFeatures.fileHeader{iE}.fftNorm2Hz=[];
                else
                    paramGenFeatures.fileHeader{iE}.fftNorm2Hz=(datParam{3,2});
                end
            case 'welch'
                if isnan(str2double(datParam{1,2}))
                    paramGenFeatures.fileHeader{iE}.psdWin_pwelch=[];
                else
                    paramGenFeatures.fileHeader{iE}.psdWin_pwelch=str2double(datParam{1,2});
                end
                if isnan(str2double(datParam{2,2}))
                    paramGenFeatures.fileHeader{iE}.psdWinOverlap_pwelch=[];
                else
                    paramGenFeatures.fileHeader{iE}.psdWinOverlap_pwelch = str2double(datParam{2,2});
                end
                if isnan(str2double(datParam{3,2}))
                    paramGenFeatures.fileHeader{iE}.nFFT=[];
                else
                    paramGenFeatures.fileHeader{iE}.nFFT=str2double(datParam{3,2});
                end
                if ~strcmp(datParam{4,2},'yes') & ~strcmp(datParam{4,2},'no') 
                    paramGenFeatures.fileHeader{iE}.detrendL=[];
                else
                    paramGenFeatures.fileHeader{iE}.detrendL=(datParam{4,2});
                end
                
            case 'thomson'
                if isnan(str2double(datParam{1,2}))
                    paramGenFeatures.fileHeader{iE}.nw_pmtm=[];
                else
                    paramGenFeatures.fileHeader{iE}.nw_pmtm=str2double(datParam{1,2});
                end
                if isnan(str2double(datParam{2,2}))
                    paramGenFeatures.fileHeader{iE}.nFFT=[];
                else
                    paramGenFeatures.fileHeader{iE}.nFFT=str2double(datParam{2,2});
                end
                 if ~strcmp(datParam{3,2},'yes') & ~strcmp(datParam{3,2},'no') 
                    paramGenFeatures.fileHeader{iE}.detrendL=[];
                else
                    paramGenFeatures.fileHeader{iE}.detrendL=(datParam{3,2});
                end
        end

    case 'irasa'
        set(handles.textSpecType,'Visible','off');
        set(handles.psdSpecType,'Visible','off');
        
        %%% irasa window type
        str = get(handles.WinType,'String');
        pos = get(handles.WinType,'Value');
        paramGenFeatures.fileHeader{iE}.irasaWindowType=str{pos};
        
        %%% irasa Spectra type
        str = get(handles.psdSpecType,'String');
        pos = get(handles.psdSpecType,'Value');
        paramGenFeatures.fileHeader{iE}.irasaSpectraType=str{pos};
        
        %%%% table parameters
        datParam = get(handles.tableParam,'Data');
        if isnan(str2double(datParam{1,2}))
            paramGenFeatures.fileHeader{iE}.nSubset=[];
        else
            paramGenFeatures.fileHeader{iE}.nSubset=str2double(datParam{1,2});
        end
        %if isnan(str2double(datParam{2,2}))
        %    paramGenFeatures.fileHeader{iE}.hset=[];
        %else
            paramGenFeatures.fileHeader{iE}.hset=datParam{2,2};
        %end
        if ~strcmp(datParam{3,2},'yes') & ~strcmp(datParam{3,2},'no')
            paramGenFeatures.fileHeader{iE}.detrendL=[];
        else
            paramGenFeatures.fileHeader{iE}.detrendL=(datParam{3,2});
        end
        if ~strcmp(datParam{4,2},'yes') & ~strcmp(datParam{4,2},'no')
            paramGenFeatures.fileHeader{iE}.rectOsc=[];
        else
            paramGenFeatures.fileHeader{iE}.rectOsc=datParam{4,2};
        end
        if ~strcmp(datParam{5,2},'yes') & ~strcmp(datParam{5,2},'no')
            paramGenFeatures.fileHeader{iE}.fftNorm2Hz=[];
        else
            paramGenFeatures.fileHeader{iE}.fftNorm2Hz=datParam{5,2};
        end
    case 'coherence'
        set(handles.textSpecType,'Visible','off');
        %set(handles.psdSpecType,'Visible','off');
        %%% coher method
        str = get(handles.selMethod,'String');
        pos = get(handles.selMethod,'Value');
        paramGenFeatures.fileHeader{iE}.coherMethod=str{pos};
        %%% psd window type
        str = get(handles.WinType,'String');
        pos = get(handles.WinType,'Value');
        if strcmpi(paramGenFeatures.fileHeader{iE}.coherMethod,'moody')
            % automatically set window type to hann
            paramGenFeatures.fileHeader{iE}.coherWindowType=str{3};
        else
            paramGenFeatures.fileHeader{iE}.coherWindowType=str{pos};
        end
        
        %%%% table parameters
        datParam = get(handles.tableParam,'Data');
        %%%%% same parameters for all three coherence methods
        if isnan(str2double(datParam{1,2}))
            paramGenFeatures.fileHeader{iE}.coherWin=[];
        else
            paramGenFeatures.fileHeader{iE}.coherWin = str2double(datParam{1,2});
        end
        if isnan(str2double(datParam{2,2}))
            paramGenFeatures.fileHeader{iE}.coherWinOverlap = [];
        else
            paramGenFeatures.fileHeader{iE}.coherWinOverlap = str2double(datParam{2,2});
        end
        if isnan(str2double(datParam{3,2}))
            paramGenFeatures.fileHeader{iE}.nFFT=[];
        else
            paramGenFeatures.fileHeader{iE}.nFFT=str2double(datParam{3,2});
        end
        
    case 'cwt'
        set(handles.textSpecType,'Visible','off');
        %set(handles.psdSpecType,'Visible','off');
        %%% coher method
        str = get(handles.WaveType,'String');
        pos = get(handles.WaveType,'Value');
        
        %%% 'Haar','Morlet','Symlets','Daubechies'
        switch str{pos}
            case 'Haar'
                paramGenFeatures.fileHeader{iE}.cwtType='haar';
            case 'Morlet'
                paramGenFeatures.fileHeader{iE}.cwtType='morl';
            otherwise     
            %case {'Symlets','Daubechies'}
                str1 = get(handles.SubWaveType,'String');
                pos1 = get(handles.SubWaveType,'Value');
                paramGenFeatures.fileHeader{iE}.cwtType=str1{pos1};
        end
        %%%% process WT coef 
        str = get(handles.procWTcoef,'String');
        pos = get(handles.procWTcoef,'Value');
        paramGenFeatures.fileHeader{iE}.procWTcoef=str{pos};
        
        %%% scales 
        strS = get(handles.ScaleTab,'String');
        switch paramGenFeatures.fileHeader{iE}.cwtUnit
            case 'scales'
                eval(['paramGenFeatures.fileHeader{iE}.cwtScales=',strS,';']);
            case 'freqs'
                eval(['paramGenFeatures.fileHeader{iE}.cwtFreqs=',strS,';']);
        end
        
end

%%%% now open for the second selection step
switch paramGenFeatures.fileHeader{iE}.featureType
    case {'psd','coherence','irasa'}
        set(handles.textMethod,'Visible','on','String',{'Frequency band(s) to store: ';
            '(e.g. [0,12] [14,15])'});
        set(handles.textHz,'Visible','on');
        if isfield(paramGenFeatures.fileHeader{iE},'sampleFreq')
            switch paramGenFeatures.fileHeader{iE}.sampleFreqUnit
                case 'Hz'
                    fsNyquist  = paramGenFeatures.fileHeader{iE}.sampleFreq/2;
                case 'kHz'
                    fsNyquist  = paramGenFeatures.fileHeader{iE}.sampleFreq*500;
            end
        else
            fsNyquist = 1/2;
        end
        strHz = ['[0 , ',num2str(fsNyquist),']'];
        set(handles.rangeHz,'Visible','on','String',strHz);
        set(handles.checkZeroMean,'Visible','on','String','Zero-mean prior spectra computaiton','Value',1);
    case {'cwt','dwt'}
        set(handles.checkZeroMean,'Visible','on','String','Zero-mean prior wevelet decomposition');
end

set(handles.pushOK2,'Visible','on');

handles = printParameters(paramGenFeatures,handles);


guidata(hObject,handles)


% --- Executes on button press in pushOK2.
function pushOK2_Callback(hObject, eventdata, handles)
% hObject    handle to pushOK2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

set(handles.textMethod,'Visible','off'); 
set(handles.textHz,'Visible','off'); 
set(handles.rangeHz,'Visible','off'); 
set(handles.pushOK2,'Visible','off');
set(handles.textFile,'Visible','off'); 

%%%% freq in 
switch paramGenFeatures.fileHeader{iE}.featureType
    case {'psd','coherence','irasa'}
        ss=get(handles.rangeHz,'String');
        ss=['{',ss,'}'];
        paramGenFeatures.fileHeader{iE}.freqIn= eval(ss);
end
%%%% zero-mean
if get(handles.checkZeroMean,'Value')
    paramGenFeatures.fileHeader{iE}.zeroMean = true;
else
    paramGenFeatures.fileHeader{iE}.zeroMean = false;
end

set(handles.checkZeroMean,'Visible','off','Value',1);

handles = printParameters(paramGenFeatures,handles);

set(handles.loadFile,'Visible','on','Enable','on');
set(handles.repFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


guidata(hObject,handles)


% --- Executes on button press in corrFile.
function corrFile_Callback(hObject, eventdata, handles)
% hObject    handle to corrFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','single', 'ListString',paramGenFeatures.fileName, ...
    'Name', 'Correct file');

if ok_click
    set(handles.corrFile,'UserData',listNum); %%% correction true 
    
    set(handles.textFile,'Visible','on','String',paramGenFeatures.fileName{listNum});
    set(handles.butPSD,'Visible','on','Value',0); 
    %set(handles.butAR,'Visible','on','Value',0); 
    set(handles.butCoherence,'Visible','on','Value',0); 
    set(handles.butWT,'Visible','on','Value',0); 
    set(handles.butNP,'Visible','on','Value',0); 
    set(handles.butIRASA,'Visible','on','Value',0); 
    set(handles.textMethod,'Visible','on','String','Select type of features to compute:'); 
    
    %%%% remove values 
    switch paramGenFeatures.fileHeader{listNum}.featureType
        case 'psd'
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'featureType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'psdWindowType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'psdSpectraType');
            
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'freqIn');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'zeroMean');
            %paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'refType');
            switch paramGenFeatures.fileHeader{listNum}.psdMethod
                case 'fft'
                    % paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nFFT');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nSubset');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'detrendL');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'fftNorm2Hz');
                case 'welch'
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'detrendL');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nFFT');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'psdWin_pwelch');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'psdWinOverlap_pwelch');
                case 'thomson'
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'detrendL');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nFFT');
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nw_pmtm');
            end
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'psdMethod');
        case 'irasa'
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'irasaSpectraType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'irasaWindowType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'freqIn');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'zeroMean');
            %paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'refType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nSubset');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'detrendL'); 
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'rectOsc'); 
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'fftNorm2Hz'); 
        case 'coherence'
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'featureType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'coherMethod');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'coherWindowType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'coherWin');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'nFFT');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'freqIn');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'zeroMean');
            %paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'refType');
        case 'cwt'
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'featureType');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'cwtType');
            switch paramGenFeatures.fileHeader{listNum}.cwtUnit
                case 'scales'
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'cwtScales');
                case 'freqs'
                    paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'cwtFreqs');
            end
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'cwtUnit');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'procWTcoef');
            paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'zeroMean');
            
            %paramGenFeatures.fileHeader{listNum}=rmfield(paramGenFeatures.fileHeader{listNum},'refType');
    end
    handles=printParameters(paramGenFeatures,handles); 
          
else
    %hE=errordlg('No file selected');
    %uiwait(hE);
    set(handles.loadFile,'Visible','on');
    set(handles.repFile,'Visible','on');
    set(handles.delFile,'Visible','on');
    set(handles.corrFile,'Visible','on');
    set(handles.pushFinishSelection,'Visible','on');
end    
guidata(hObject,handles)

% --- Executes on button press in delFile.
function delFile_Callback(hObject, eventdata, handles)
% hObject    handle to delFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNumAll, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','multiple', 'ListString',paramGenFeatures.fileName, ...
    'Name', 'Correct file');
if ok_click
    if paramGenFeatures.fileIndx    == 1 %%% the first and the only one
        paramGenFeatures.fileIndx    = 0;
        paramGenFeatures.fileName    = [];
        paramGenFeatures.pathName    = [];
        paramGenFeatures=rmfield(paramGenFeatures,'fileHeader');
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.loadParam,'Visible','on','Enable','on');
        set(handles.listboxSum,'Visible','off');
    else
        paramGenFeatures.fileIndx  = paramGenFeatures.fileIndx  - length(listNumAll);
        paramGenFeatures.fileName(listNumAll) = [];
        paramGenFeatures.pathName(listNumAll) = [];
        paramGenFeatures.fileHeader(listNumAll) = [];
        set(handles.loadFile,'Visible','on');
        handles = printParameters(paramGenFeatures,handles);
    end
    if paramGenFeatures.fileIndx > 0
        set(handles.loadFile,'Visible','on');
        set(handles.repFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
    end
else
    %hE=errordlg('No file selected');
    %uiwait(hE);
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
global paramGenFeatures

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select file which parameteres to replicate', ...
    'SelectionMode','single', 'ListString',paramGenFeatures.fileName, ...
    'Name', 'Select file to replicate');

if ok_click
    [fileName, pathName,filtInd] = uigetfile ({'./Data/EpochedData/*.mat'},'Open File','MultiSelect', 'on');
    pathName=getRelPath(pathName); 
    
    if filtInd
        fileIn = false;strFileIn = [];
        if iscell(fileName)
            lenFile = length(fileName);
            fileInd = ones(lenFile,1);
            for i=1:lenFile
                if sum(strcmp(paramGenFeatures.fileName,fileName{i})) && sum(strcmp(paramGenFeatures.pathName,pathName))
                    fileIn = true;
                    strFileIn = [strFileIn, ',', fileName{i}];
                    fileInd(i)=0;
                end
            end
        else
            lenFile = 1; fileInd = 1;
            if sum(strcmp(paramGenFeatures.fileName,fileName)) && sum(strcmp(paramGenFeatures.pathName,pathName))
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
                    iE = paramGenFeatures.fileIndx + 1;
                    paramGenFeatures.fileIndx = iE;
                    paramGenFeatures.fileHeader{iE} = header;
                    paramGenFeatures.fileName{iE}   = fName;
                    paramGenFeatures.pathName{iE}   = pathName;
                    %%% copy new header values
                    fNnew = fieldnames(paramGenFeatures.fileHeader{iE});
                    fNold = fieldnames(paramGenFeatures.fileHeader{listNum});
                    for fNi = 1:length(fNold)
                        if ~strcmp(fNold{fNi},fNnew)
                            str =['paramGenFeatures.fileHeader{iE}.',fNold{fNi},'=paramGenFeatures.fileHeader{listNum}.',fNold{fNi},';'];
                            eval(str)
                        end
                    end
                end
            end
        end
    end
end 
handles = printParameters(paramGenFeatures,handles);

set(handles.loadFile,'Visible','on');
set(handles.repFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


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

set(handles.pushGenFeatures,'Visible','on');
set(handles.pushSaveParam,'Visible','on');
set(handles.pushFinish,'Visible','on');
set(handles.pushGoBack,'Visible','on');

% --- Executes on button press in pushFinish.
function pushFinish_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

set(handles.pushGenFeatures,'Visible','on');
set(handles.pushSaveParam,'Visible','on');

%pSave= get(handles.pushSaveParam,'UserData') ; 

%if pSave 
if isfield(paramGenFeatures,'paramSaveFile')
    save(paramGenFeatures.paramSaveFile,'paramGenFeatures'); 
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

% --- Executes on button press in pushGenFeatures.
function pushGenFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pushGenFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

set(handles.pushGenFeatures,'Enable','off');
set(handles.pushSaveParam,'Enable','off');
set(handles.pushFinish,'Enable','off');
set(handles.pushGoBack,'Enable','off');

pathName = uigetdir('./Data/FeaturesData','Select folder where to save epoched data ...');
pathName=getRelPath(pathName); 

if pathName 
    %hW=warndlg('Working ..... ');
    paramGenFeatures.pathFeaturesData = pathName;     
    genFeatures(paramGenFeatures); 
    %close(hW) 
end 
   
set(handles.pushGenFeatures,'Enable','on');
set(handles.pushSaveParam,'Enable','on');
set(handles.pushFinish,'Enable','on');
set(handles.pushGoBack,'Enable','on');

guidata(hObject,handles)


% --- Executes on button press in pushSaveParam.
function pushSaveParam_Callback(hObject, eventdata, handles)
% hObject    handle to pushSaveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures  

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ... 
                                  'Save parameters as ...','./ParameterFiles/param_GenFeatures.mat');
pathName=getRelPath(pathName);

if fName
    str=strcat(pathName,fName);
    paramGenFeatures.paramSaveFile=str; 
    handles = printParameters(paramGenFeatures,handles);      
    save(str,'paramGenFeatures'); 
    % set(handles.pushSaveParam,'UserData',true);
end 
guidata(hObject,handles)

% --- Executes on button press in pushGoBack.
function pushGoBack_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to pushGoBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushGenFeatures,'Visible','off');
set(handles.pushSaveParam,'Visible','off');
set(handles.pushFinish,'Visible','off');
set(handles.pushGoBack,'Visible','off');

set(handles.loadFile,'Visible','on');
set(handles.repFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


guidata(hObject,handles)


% --- Executes on selection change in selMethod.
function selMethod_Callback(hObject, eventdata, handles)
% hObject    handle to selMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenFeatures

if get(handles.corrFile,'UserData')
   iE=get(handles.corrFile,'UserData');       
else
   iE=paramGenFeatures.fileIndx;
end

switch paramGenFeatures.fileHeader{iE}.featureType
    case 'psd'
        str = get(handles.selMethod,'String');
        pos = get(handles.selMethod,'Value');
        switch str{pos}
            case 'fft'
                set(handles.textParam,'String','Parameters for fft (fft.m):', 'Visible','on');
                % strD(1)={num2str(paramGenFeatures.fileHeader{iE}.nFFT)};
                % datTab=[{'# of FFT points'} , {strD{1}}];
                if isfield(paramGenFeatures.fileHeader{iE},'nSubset')
                    datTab=[{'# subsets'} , num2str(paramGenFeatures.fileHeader{iE}.nSubset) ; ...
                        {'linear detrend'}, paramGenFeatures.fileHeader{iE}.detrendL;];
                else
                    datTab=[{'# subsets'} , num2str(1) ; {'linear detrend (yes/no)'}, 'yes'];
                end
            case 'welch'
                lenWin=round(paramGenFeatures.fileHeader{iE}.nFFT/8); %%% takes 1/8 of the epoch length
                strD(1)={num2str(lenWin)};
                lenWinOverlap = lenWin / 2 ; %%% 50% overlap
                strD(2)={num2str(lenWinOverlap)};
                strD(3)={num2str(round(paramGenFeatures.fileHeader{iE}.nFFT))};
                if isfield(paramGenFeatures.fileHeader{iE},'detrendL')
                   strD(4)={(paramGenFeatures.fileHeader{iE}.detrendL)};
                else
                     strD(4)={'yes'};
                end
                datTab=[{'window length';'window overlap';'# of FFT points';'linear detrend (yes/no)'} , ...
                    {strD{1};strD{2};strD{3};strD{4}}];
                % datTab=[{'window length';'window overlap';'# of FFT points'} , {strD{1};strD{2};strD{3}}];
                set(handles.textParam,'String','Parameters for welch (pwelch.m):', 'Visible','on');
                
            case 'thomson'
                strD(1)={'4'};
                strD(2)={num2str(round(paramGenFeatures.fileHeader{iE}.nFFT))};
                if isfield(paramGenFeatures.fileHeader{iE},'detrendL')
                    strD(3)={(paramGenFeatures.fileHeader{iE}.detrendL)};
                else
                    strD(3)={'yes'};
                end
                datTab=[{'time-bandwidth product';'# of FFT points';'linear detrend (yes/no)'} , ...
                    {strD{1};strD{2};strD{3}}];
                % datTab=[{'time-bandwidth product';'# of FFT points'} , {strD{1};strD{2}}];
                set(handles.textParam,'String','Parameters for thomson (pmtm.m):', 'Visible','on');
        end
        set(handles.tableParam,'Data',datTab);
    case 'coherence'
        str = get(handles.selMethod,'String');
        pos = get(handles.selMethod,'Value');
        switch str{pos}
            case 'cpsd'
                set(handles.textParam,'String','Parameters for ''cpsd.m'':', 'Visible','on');
            case 'mscohere'
                lenWin=round(paramGenFeatures.fileHeader{iE}.nFFT/8); %%% takes 1/8 of the epoch length
                set(handles.textParam,'String','Parameters for ''mscohere.m'':', 'Visible','on');
            case 'tfestimate'                
                set(handles.textParam,'String','Parameters for ''tfestimate.m'':', 'Visible','on');
        end      
end

guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function selMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in WinType.
function WinType_Callback(hObject, eventdata, handles)
% hObject    handle to WinType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns WinType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WinType
guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function WinType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WinType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in psdSpecType.
function psdSpecType_Callback(hObject, eventdata, handles)
% hObject    handle to psdSpecType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns psdSpecType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from psdSpecType
guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function psdSpecType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psdSpecType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rangeHz_Callback(hObject, eventdata, handles)
% hObject    handle to rangeHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rangeHz as text
%        str2double(get(hObject,'String')) returns contents of rangeHz as a double
guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function rangeHz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeHz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkZeroMean.
function checkZeroMean_Callback(hObject, eventdata, handles)
% hObject    handle to checkZeroMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function handles = printParameters(param,handles)

% if nargin < 3
%     resL=false
% end
% if ~resL
if param.fileIndx > 0
    if isfield(param,'paramSaveFile')
        strLB={['Parameters Summary (save to: ',param.paramSaveFile,'):']};
    else
        strLB={'Parameters Summary (save to: ???):'};
    end
    for i=1:param.fileIndx
        strLB=[strLB; [int2str(i),')'] ;param.fileName{i}];
        if isfield(param.fileHeader{i},'sampleFreq');
            pStr= ['sampling freq: ',int2str(param.fileHeader{i}.sampleFreq), ...
                ' [',param.fileHeader{i}.sampleFreqUnit,']'];
            strLB=[strLB;pStr];
        end
        pStr=['epoch length: ',num2str(param.fileHeader{i}.lenEpoch), ...
            ' [',param.fileHeader{i}.lenEpochUnit,']'];
        strLB=[strLB;pStr];
        pStr=['overlap: ',num2str(param.fileHeader{i}.lenOverlap), ...
            ' [',param.fileHeader{i}.lenOverlapUnit,']'];
        strLB=[strLB;pStr];
        if isfield(param.fileHeader{i},'featureType')
            switch param.fileHeader{i}.featureType
                case 'psd'
                    if isfield(param.fileHeader{i},'psdMethod');
                        strLB=[strLB; ['psd method: ',param.fileHeader{i}.psdMethod]];
                        strLB=[strLB; ['psd window type: ',param.fileHeader{i}.psdWindowType]];
                        switch param.fileHeader{i}.psdMethod
                            case 'fft'
                                if isfield(param.fileHeader{i},'nSubset');
                                    strLB=[strLB; ['number of subsets: ',num2str(param.fileHeader{i}.nSubset)]];
                                end
                                if isfield(param.fileHeader{i},'detrendL');
                                    strLB=[strLB; ['linear detrend: ',(param.fileHeader{i}.detrendL)]];
                                end
                                if isfield(param.fileHeader{i},'fftNorm2Hz');
                                    strLB=[strLB; ['normalize to uV(2)/Hz: ',(param.fileHeader{i}.fftNorm2Hz)]];
                                end
                                % strLB=[strLB; ['number of FFT points: ',num2str(param.fileHeader{i}.nFFT)]];
                            case 'welch'
                                strLB=[strLB; ['window length: ',num2str(param.fileHeader{i}.psdWin_pwelch)]];
                                strLB=[strLB; ['overlap: ',num2str(param.fileHeader{i}.psdWinOverlap_pwelch)]];
                                strLB=[strLB; ['number of FFT points: ',num2str(param.fileHeader{i}.nFFT)]];
                                if isfield(param.fileHeader{i},'detrendL');
                                    strLB=[strLB; ['linear detrend: ',(param.fileHeader{i}.detrendL)]];
                                end
                            case 'thomson'
                                strLB=[strLB; ['time-bandwidth product: ',num2str(param.fileHeader{i}.nw_pmtm)]];
                                strLB=[strLB; ['number of FFT points: ',num2str(param.fileHeader{i}.nFFT)]];
                                if isfield(param.fileHeader{i},'detrendL');
                                    strLB=[strLB; ['linear detrend: ',(param.fileHeader{i}.detrendL)]];
                                end
                        end
                        strLB=[strLB;['type of spectra: ',param.fileHeader{i}.psdSpectraType]];
                        if isfield(param.fileHeader{i},'freqIn');
                            ss=[];
                            for ii=1:length(param.fileHeader{i}.freqIn)
                                ss= [ss,' [', num2str(param.fileHeader{i}.freqIn{ii}(1)),',', ...
                                    num2str(param.fileHeader{i}.freqIn{ii}(2)),'] ;'];
                            end
                            ss=ss(1:end-1);
                            strLB=[strLB; ['freq. band(s) to compute: ',ss]];
                        end
                    end
                case 'irasa'
                    if isfield(param.fileHeader{i},'irasaWindowType');
                        strLB=[strLB; ['psd window type: ',param.fileHeader{i}.irasaWindowType]];
                    end
                    if isfield(param.fileHeader{i},'nSubset');
                        strLB=[strLB; ['number of subsets: ',num2str(param.fileHeader{i}.nSubset)]];
                    end
                    if isfield(param.fileHeader{i},'hset')
                        strLB=[strLB; ['hset: ',(param.fileHeader{i}.hset)]];
                    end
                    if isfield(param.fileHeader{i},'detrendL');
                        strLB=[strLB; ['linear detrend: ',(param.fileHeader{i}.detrendL)]];
                    end
                    if isfield(param.fileHeader{i},'rectOsc');
                        strLB=[strLB; ['rectify osc. part: ',param.fileHeader{i}.rectOsc]];
                    end
                    if isfield(param.fileHeader{i},'fftNorm2Hz');
                        strLB=[strLB; ['normalize to uV(2)/Hz: ',param.fileHeader{i}.fftNorm2Hz]];
                    end
                    if isfield(param.fileHeader{i},'irasaSpectraType');
                        strLB=[strLB;['type of spectra: ',param.fileHeader{i}.irasaSpectraType]];
                    end
                case 'coherence'
                    if isfield(param.fileHeader{i},'coherMethod');
                        strLB=[strLB; ['coherence method: ',param.fileHeader{i}.coherMethod]];
                        strLB=[strLB; ['coherence window type: ',param.fileHeader{i}.coherWindowType]];
                        strLB=[strLB; ['window length: ',num2str(param.fileHeader{i}.coherWin)]];
                        strLB=[strLB; ['overlap: ',num2str(param.fileHeader{i}.coherWinOverlap)]];
                        strLB=[strLB; ['number of FFT points: ',num2str(param.fileHeader{i}.nFFT)]];
                        if isfield(param.fileHeader{i},'freqIn');
                            ss=[];
                            for ii=1:length(param.fileHeader{i}.freqIn)
                                ss= [ss,' [', num2str(param.fileHeader{i}.freqIn{ii}(1)),',', ...
                                    num2str(param.fileHeader{i}.freqIn{ii}(2)),'] ;'];
                            end
                            ss=ss(1:end-1);
                            strLB=[strLB; ['freq. band(s) to compute: ',ss]];
                        end
                    end
                case 'cwt'
                    if isfield(param.fileHeader{i},'cwtType');
                        strLB=[strLB; ['method: cwt']];
                        strLB=[strLB; ['cwt type: ',param.fileHeader{i}.cwtType]];
                        switch param.fileHeader{i}.cwtUnit
                            case 'scales'
                                strLB=[strLB; ['cwt scales: ',get(handles.ScaleTab,'String')]];
                            case 'freqs'
                                strLB=[strLB; ['cwt freqs.: ',get(handles.ScaleTab,'String')]];
                        end
                        strLB=[strLB; ['proc wt coeff: ',param.fileHeader{i}.procWTcoef]];
                    end
            end
        end
        %%% zero mean
        if isfield(param.fileHeader{i},'zeroMean');
            if param.fileHeader{i}.zeroMean
                pStr='zero mean: yes';
            else
                pStr='zero mean: no';
            end
            strLB=[strLB;pStr];
        end
    end
    %    set(listB,'String',strLB)
end
if ~isfield(handles,'listboxSum')
    pozF=get(handles.figure1,'Position');
    handles.listboxSum=uicontrol('Parent',handles.figure1,'Style','listbox', ...
        'Fontweight','bold','Units','normalized', ...
        'Position',[0.59 0.01 0.4 0.98], ...
        'Selected','off','SelectionHighlight','off');
    %%%%%%
end
set(handles.listboxSum,'Value',1);
set(handles.listboxSum,'String',strLB)
set(handles.listboxSum,'Visible','on');
% else %%% need to resize
%     set(handles.listboxSum,'Position',[0.59 0.01 0.4 0.98]);
% end



% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'listboxSum')
    set(handles.listboxSum,'Position',[0.59 0.01 0.4 0.98]); 
   %  handles = printParameters(paramGenFeatures,handles,true) ; 
end
guidata(hObject,handles) 


% --- Executes on selection change in SubWaveType.
function SubWaveType_Callback(hObject, eventdata, handles)
% hObject    handle to SubWaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SubWaveType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SubWaveType


% --- Executes during object creation, after setting all properties.
function SubWaveType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubWaveType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in procWTcoef.
function procWTcoef_Callback(hObject, eventdata, handles)
% hObject    handle to procWTcoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns procWTcoef contents as cell array
%        contents{get(hObject,'Value')} returns selected item from procWTcoef


% --- Executes during object creation, after setting all properties.
function procWTcoef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to procWTcoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ScaleTab_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleTab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScaleTab as text
%        str2double(get(hObject,'String')) returns contents of ScaleTab as a double


% --- Executes during object creation, after setting all properties.
function ScaleTab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleTab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
