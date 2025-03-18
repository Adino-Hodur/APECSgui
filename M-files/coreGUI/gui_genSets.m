function varargout = gui_genSets(varargin)
% GUI_GENSETS MATLAB code for gui_genSets.fig
%      GUI_GENSETS, by itself, creates a new GUI_GENSETS or raises the existing
%      singleton*.
%
%      H = GUI_GENSETS returns the handle to a new GUI_GENSETS or the handle to
%      the existing singleton*.
%
%      GUI_GENSETS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GENSETS.M with the given input arguments.
%
%      GUI_GENSETS('Property','Value',...) creates a new GUI_GENSETS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_genSets_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_genSets_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_genSets

% Last Modified by GUIDE v2.5 22-May-2012 12:33:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_genSets_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_genSets_OutputFcn, ...
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


% --- Executes just before gui_genSets is made visible.
function gui_genSets_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_genSets (see VARARGIN)
 
clear global 

global paramGenSet 

set(0,'Units','normalized'); 
set(handles.figure1,'Position',[0.25 0.1 0.6 0.6]); 

%%%% set this values 
paramGenSet.trainSet{1}=[];
paramGenSet.valSet{1}=[];
paramGenSet.testSet{1}=[];

% Choose default command line output for gui_genSets
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_genSets wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_genSets_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in trainSet.
function trainSet_Callback(hObject, eventdata, handles)
% hObject    handle to trainSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trainSet
if get(hObject,'Value')
    if get(handles.perTrain,'Value') || get(handles.perVal,'Value') || get(handles.perTest,'Value')
        set(handles.perTrain,'Visible','on');   
    elseif get(handles.segTrain,'Value') || get(handles.segVal,'Value') || get(handles.segTest,'Value')
        set(handles.segTrain,'Visible','on');
    else
        set(handles.perTrain,'Visible','on');
        set(handles.segTrain,'Visible','on');
    end
else 
    set(handles.perTrain,'Visible','off','Value',0); 
    set(handles.segTrain,'Visible','off','Value',0); 
    set(handles.textTrain,'Visible','off'); 
    set(handles.perTrain,'UserData',[])
end 
guidata(hObject,handles)

% --- Executes on button press in valSet.
function valSet_Callback(hObject, eventdata, handles)
% hObject    handle to valSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of valSet
if get(hObject,'Value')
    if get(handles.perTrain,'Value') || get(handles.perVal,'Value') || get(handles.perTest,'Value')
        set(handles.perVal,'Visible','on');   
    elseif get(handles.segTrain,'Value') || get(handles.segVal,'Value') || get(handles.segTest,'Value')
        set(handles.segVal,'Visible','on');
    else
        set(handles.perVal,'Visible','on');
        set(handles.segVal,'Visible','on');
    end
else   
    set(handles.perVal,'Visible','off','Value',0); 
    set(handles.segVal,'Visible','off','Value',0); 
    set(handles.textVal,'Visible','off'); 
    set(handles.perVal,'UserData',[])
end 
guidata(hObject,handles)

% --- Executes on button press in testSet.
function testSet_Callback(hObject, eventdata, handles)
% hObject    handle to testSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of testSet
if get(hObject,'Value')
    if get(handles.perTrain,'Value') || get(handles.perVal,'Value') || get(handles.perTest,'Value')
        set(handles.perTest,'Visible','on');   
    elseif get(handles.segTrain,'Value') || get(handles.segVal,'Value') || get(handles.segTest,'Value')
        set(handles.segTest,'Visible','on');
    else
        set(handles.perTest,'Visible','on');
        set(handles.segTest,'Visible','on');
    end
else 
    set(handles.perTest,'Visible','off','Value',0); 
    set(handles.segTest,'Visible','off','Value',0); 
    set(handles.textTest,'Visible','off'); 
    set(handles.perTest,'UserData',[])
end 
guidata(hObject,handles)

% --- Executes on button press in perTrain.
function perTrain_Callback(hObject, eventdata, handles)
% hObject    handle to perTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 
% Hint: get(hObject,'Value') returns toggle state of perTrain
if get(hObject,'Value')
    
    if isfield(paramGenSet,'classLabel')
        if length(unique(paramGenSet.classLabelAll)) == 1
            moreClassLabels = false ;
        else
            moreClassLabels = true;
        end
    else
        moreClassLabels = false ;
    end
    
    set(handles.segTrain,'Visible','off');
    posText=get(handles.textTrain,'Position');
    posT=get(handles.perTrain,'Position');
    posText(1)=posT(1);
    posText(2)=posT(2)-posText(4);
    set(handles.textTrain,'String','Percentage of data [%]','Visible','on', ...
        'Position',posText,'FontWeight','normal');
    
    [indC,strIn] = fcn1(paramGenSet); 
    %%%% open dialog window 
    doIt = true;
    valTab={'0'};
    for c=2:length(indC) % paramGenSet.numClass
        valTab=[valTab;'0'];
    end
    uD=zeros(1,paramGenSet.numClass); 

    uD1=get(handles.perVal,'UserData');
    uD2=get(handles.perTest,'UserData');
    while doIt
        output = inputdlg(eval(strIn),'% of data',ones(length(indC),1),valTab);
        if ~isempty(output)
            puD = str2double(output); 
            puD(isnan(uD))=0;
            uD(indC)=puD; 
            if ~isempty(uD1) || ~isempty(uD2)
                sumA = sum([uD ; uD1]);
                if ~isempty(uD2) && length(uD2) == 1
                    sumA(1,1) = sumA(1,1) +  sum(uD2); %%% one test class only
                else
                    sumA = sumA + sum(uD2);
                end
            else
                sumA = [];
            end
            %%%% now check with other files
            %%% create string of ind. class percentages if set 
            %strSet='% data segments are set';             
            for c=1:length(uD)
                if c==1 
                    strP=strcat('Class',int2str(c),':',int2str(uD(c)),'%');
                else
                    strP=strcat(strP,'Class',int2str(c),':',int2str(uD(c)),'%,');                
                end                
            end            
            strSet=[{strP(1:end-1)}];            
            if sum(uD) > 100 && ~moreClassLabels % ~isfield(paramGenSet,'classLabel')
                hE=errordlg('Sum of percenteges for train set is more than 100','Error');
                uiwait(hE);
                for c=1:paramGenSet.numClass
                    valTab{c}=num2str(uD(c));
                end
            elseif  sum(uD) == 0
                set(handles.perTrain,'Visible','off','Value',0);
                set(handles.trainSet,'Value',0);
                set(handles.textTrain,'Visible','off');
                doIt = false;
            elseif ~isempty(sumA) && moreClassLabels %isfield(paramGenSet,'classLabel')
                iP=find(sumA > 100);
                if ~isempty(iP)
                    strE=('Sum of percenteges of train,val and test sets is more than 100 for Class:');
                    for j=1:length(iP)
                        strE=strcat(strE,int2str(iP(j)),',');
                    end
                    hE=errordlg(strE,'Error');
                    uiwait(hE);
                    for c=1:length(indC)
                        valTab{c}=num2str(uD(indC(c)));
                    end
                else
                    set(handles.perTrain,'UserData',uD);
                    set(handles.textTrain,'String',strSet,'Visible','on','FontWeight','bold');
                    doIt = false;
                end                
            elseif sum(sumA) > 100
                hE=errordlg('Sum of percenteges for train, val and test sets is more than 100','Error');
                uiwait(hE);
                for c=1:length(indC)
                    valTab{c}=num2str(uD(indC(c)));
                end
            else
                set(handles.perTrain,'UserData',uD);
                set(handles.textTrain,'String',strSet,'Visible','on','FontWeight','bold');
                doIt = false;
            end
        else %%% end isempty(output)
            set(handles.perTrain,'Visible','off','Value',0);
            set(handles.trainSet,'Value',0);
            set(handles.textTrain,'Visible','off');
            doIt = false;
        end
    end %%% end while 
else  
    set(handles.textTrain,'Visible','off')
    set(handles.trainSet,'Value',0); 
    set(handles.perTrain,'Visible','off'); 
end 
guidata(hObject,handles)

% --- Executes on button press in segTrain.
function segTrain_Callback(hObject, eventdata, handles)
% hObject    handle to segTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 

if get(handles.corrFile,'UserData')
    fInd=get(handles.corrFile,'UserData'); 
else 
    fInd=paramGenSet.fileIndx; 
end 

% Hint: get(hObject,'Value') returns toggle state of perTrain
if get(hObject,'Value')
    set(handles.perTrain,'Visible','off');
    [indC,strIn] = fcn1(paramGenSet); 
    %%%% open segment panel        
    strT=sprintf('Training set - Time segments in %s',paramGenSet.fileHeader{fInd}.timeUnit); 
    set(handles.panelSeg,'Units','normalized');
    posP=get(handles.panelSeg,'Position'); 
    posT=get(handles.segTrain,'Position');
    posT1=get(handles.panelTop2,'Position');
    nPos = [posT(1), (posT1(2)-posP(4)*1.1), posP(3),  posP(4)];
    set(handles.panelSeg,'Position',nPos);
    set(handles.panelSeg,'Visible','on','Title',strT,'Units','character'); 
    
    datTab      = zeros(length(indC),2);
    if isfield(paramGenSet.fileHeader{fInd},'maxTime'); 
        datTab(:,2) = paramGenSet.fileHeader{fInd}.maxTime;
    end 
    coleditable = true(1,paramGenSet.numClass);
    set(handles.tableSeg,'parent',handles.panelSeg,'Data',datTab,'ColumnName',{'begin','end'}, ...
        'RowName',eval(strIn),'ColumnEditable',coleditable,'Visible','on') % ...
        %'Position', [4 4 47.2 15]); 
    set(handles.pushOKSeg,'Visible','on');
    set(handles.pushCanSeg,'Visible','on');
    set(handles.fileDone,'Visible','off'); 
    set(handles.valSet,'Visible','off'); 
    set(handles.testSet,'Visible','off'); 
    set(handles.segVal,'Visible','off'); 
    set(handles.segTest,'Visible','off'); 
    set(handles.trainSet,'Enable','off');
    set(handles.segTrain,'Visible','off');
    set(handles.textTest,'Visible','off');
    set(handles.textVal,'Visible','off')
else    
    set(handles.textTrain,'Visible','off');
    set(handles.trainSet,'Value',0); 
    set(handles.segTrain,'Visible','off'); 
end
guidata(hObject,handles)

% --- Executes on button press in perVal.
function perVal_Callback(hObject, eventdata, handles)
% hObject    handle to perVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 

    
if get(hObject,'Value')   
    
    if isfield(paramGenSet,'classLabel')
        if length(unique(paramGenSet.classLabelAll)) == 1
            moreClassLabels = false ;
        else
            moreClassLabels = true;
        end
    else
        moreClassLabels = false ;
    end

    set(handles.segVal,'Visible','off');
    posText=get(handles.textVal,'Position');
    posT=get(handles.perVal,'Position');
    posText(1)=posT(1);
    posText(2)=posT(2)-posText(4);
    set(handles.textVal,'String','Percentage of data [%]','Visible','on', ...
            'Position',posText,'FontWeight','normal');    
    [indC,strIn] = fcn1(paramGenSet); 
    %%%% open dialog window 
    doIt = true;
    valTab={'0'};
    for c=2:length(indC) % paramGenSet.numClass
        valTab=[valTab;'0'];
    end
    uD=zeros(1,paramGenSet.numClass); 
    uD1=get(handles.perTrain,'UserData');
    uD2=get(handles.perTest,'UserData');
    while doIt
        output = inputdlg(eval(strIn),'% of data',ones(length(indC),1),valTab);
        if ~isempty(output)
            puD = str2double(output); 
            puD(isnan(uD))=0;
            uD(indC)=puD; 
            if ~isempty(uD1) || ~isempty(uD2) 
                sumA = sum([uD ; uD1]);
                if ~isempty(uD2) && length(uD2) == 1
                   sumA(1,1) = sumA(1,1) +  sum(uD2); %%% one test class only  
                else
                    sumA = sumA + sum(uD2);
                end   
            else
                sumA = [];
            end           
            %%% create string of ind. class percentages if set 
            for c=1:length(uD)
                if c==1 
                    strP=strcat('Class',int2str(c),':',int2str(uD(c)),'%');
                else
                    strP=strcat(strP,'Class',int2str(c),':',int2str(uD(c)),'%,');                
                end                
            end            
            strSet=[{strP(1:end-1)}];             
            %%%% now check with other files
            if sum(uD) > 100 && ~moreClassLabels    %isfield(paramGenSet,'classLabel')
                hE=errordlg('Sum of percenteges for val set is more than 100','Error');
                uiwait(hE);
                for c=1:length(indC)
                    valTab{c}=num2str(uD(indC(c)));
                end
            elseif  sum(uD) == 0
                set(handles.perVal,'Visible','off','Value',0);
                %set(handles.segVal,'Visible','on');
                set(handles.valSet,'Value',0);
                set(handles.textVal,'Visible','off');
                doIt = false;
            elseif ~isempty(sumA) && moreClassLabels % isfield(paramGenSet,'classLabel')
                iP=find(sumA > 100);
                if ~isempty(iP)
                    strE=('Sum of percenteges of train,val and test sets is more than 100 for Class:');
                    for j=1:length(iP)
                        strE=strcat(strE,int2str(iP(j)),',');
                    end
                    hE=errordlg(strE,'Error');
                    uiwait(hE);
                    for c=1:length(indC)
                        valTab{c}=num2str(uD(indC(c)));
                    end
                else
                    set(handles.perVal,'UserData',uD);
                    set(handles.textVal,'String',strSet,'Visible','on','FontWeight','bold');
                    doIt = false;
                end                
            elseif sum(sumA) > 100
                hE=errordlg('Sum of percenteges for train, val and test sets is more than 100','Error');
                uiwait(hE);
                for c=1:paramGenSet.numClass
                    valTab{c}=num2str(uD(c));
                end
            else
                set(handles.perVal,'UserData',uD);
                set(handles.textVal,'String',strSet,'Visible','on','FontWeight','bold');
                doIt = false;
            end
        else %%% end isempty(output)
            set(handles.perVal,'Visible','off','Value',0);
            set(handles.valSet,'Value',0);
            set(handles.textVal,'Visible','off');
            doIt = false;
        end
    end %%% end while 
else     
    set(handles.textVal,'Visible','off')
    set(handles.valSet,'Value',0); 
    set(handles.perVal,'Visible','off'); 
end 
guidata(hObject,handles)


% --- Executes on button press in segVal.
function segVal_Callback(hObject, eventdata, handles)
% hObject    handle to segVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 

if get(handles.corrFile,'UserData')
    fInd=get(handles.corrFile,'UserData'); 
else 
    fInd=paramGenSet.fileIndx; 
end 

% Hint: get(hObject,'Value') returns toggle state of perTrain
if get(hObject,'Value')
    set(handles.perVal,'Visible','off');
    [indC,strIn] = fcn1(paramGenSet); 
    %%%% open segment panel    
    strT=sprintf('Validation set - Time segments in %s',paramGenSet.fileHeader{fInd}.timeUnit);  
    set(handles.panelSeg,'Units','normalized');
    posP=get(handles.panelSeg,'Position'); 
    posT=get(handles.segVal,'Position');
    nPos = [posT(1), (posT(2)-posP(4)/2), posP(3),  posP(4)];
    set(handles.panelSeg,'Position',nPos);
    set(handles.panelSeg,'Visible','on','Title',strT,'Units','character');
    
    datTab      = zeros(length(indC),2);
    if isfield(paramGenSet.fileHeader{fInd},'maxTime'); 
        datTab(:,2) = paramGenSet.fileHeader{fInd}.maxTime;
    end 
    coleditable = true(1,paramGenSet.numClass);
    set(handles.tableSeg,'parent',handles.panelSeg,'Data',datTab,'ColumnName',{'begin','end'}, ...
        'RowName',eval(strIn),'ColumnEditable',coleditable,'Visible','on', ...
        'Position',[4 4 47.2 15]);
    set(handles.pushOKSeg,'Visible','on');
    set(handles.pushCanSeg,'Visible','on');
    set(handles.fileDone,'Visible','off');
    set(handles.trainSet,'Visible','off'); 
    set(handles.testSet,'Visible','off'); 
    set(handles.segTest,'Visible','off');
    set(handles.segTrain,'Visible','off');
    set(handles.textTest,'Visible','off');
    set(handles.textTrain,'Visible','off');
    set(handles.valSet,'Enable','off');
    set(handles.segVal,'Visible','off');
else
    set(handles.textVal,'Visible','off');
    set(handles.valSet,'Value',0); 
    set(handles.segVal,'Visible','off'); 
end
guidata(hObject,handles)

% --- Executes on button press in perTest.

function perTest_Callback(hObject, eventdata, handles)
% hObject    handle to perTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 

if get(hObject,'Value')    
    set(handles.segTest,'Visible','off');
    posText=get(handles.textTest,'Position');
    posT=get(handles.perTest,'Position');
    posText(1)=posT(1);
    posText(2)=posT(2)-posText(4);

    set(handles.textTest,'String','Percentage of data [%]','Visible','on', ...
        'Position',posText,'FontWeight','normal');
    
    if isfield(paramGenSet,'classLabel')
        if length(unique(paramGenSet.classLabelAll)) == 1
            moreClassLabels = false ;
        else
            moreClassLabels = true;
        end
    else
        moreClassLabels = false ;
    end
    
   % if isfield(paramGenSet,'classLabel') && moreClassLabels%%% class labels exist
   if moreClassLabels %%% class labels exist    
        [indC,strIn] = fcn1(paramGenSet);
        %%%% open dialog window
        doIt = true;
        valTab={'0'};
        for c=2:length(indC) % paramGenSet.numClass
            valTab=[valTab;'0'];
        end
        uD=zeros(1,paramGenSet.numClass);
        uD1=get(handles.perTrain,'UserData');
        uD2=get(handles.perVal,'UserData');
        while doIt
            output = inputdlg(eval(strIn),'% of data',ones(length(indC),1),valTab);
            if ~isempty(output)
                puD = str2double(output);
                puD(isnan(uD))=0;
                uD(indC)=puD;
                if ~isempty(uD1) || ~isempty(uD2)
                    sumA = sum([uD ; uD1]);
                    if ~isempty(uD2) && length(uD2) == 1
                        sumA(1,1) = sumA(1,1) +  sum(uD2); %%% one test class only
                    else
                        sumA = sumA + sum(uD2);
                    end
                else
                    sumA = [];
                end
                %%% create string of ind. class percentages if set
                for c=1:length(uD)
                    if c==1
                        strP=strcat('Class',int2str(c),':',int2str(uD(c)),'%');
                    else
                        strP=strcat(strP,'Class',int2str(c),':',int2str(uD(c)),'%,');
                    end
                end
                strSet=[{strP(1:end-1)}];
                %%%% now check with other files
                if  sum(uD) == 0
                    set(handles.perTest,'Visible','off','Value',0);
                    set(handles.testSet,'Value',0);
                    set(handles.textTest,'Visible','off');
                    doIt = false;
                elseif ~isempty(sumA) 
                    iP=find(sumA > 100);
                    if ~isempty(iP)
                        strE=('Sum of percenteges of train,val and test sets is more than 100 for Class:');
                        for j=1:length(iP)
                            strE=strcat(strE,int2str(iP(j)),',');
                        end
                        hE=errordlg(strE,'Error');
                        uiwait(hE);
                        for c=1:length(indC)
                            valTab{c}=num2str(uD(indC(c)));
                        end
                    else
                        set(handles.perTest,'UserData',uD);
                        set(handles.textTest,'String',strSet,'Visible','on','FontWeight','bold');
                        doIt = false;
                    end
                else
                    set(handles.perTest,'UserData',uD);
                    set(handles.textTest,'String',strSet,'Visible','on','FontWeight','bold');
                    doIt = false;
                end
            else %%% end isempty(output)
                set(handles.perTest,'Visible','off','Value',0);
                set(handles.testSet,'Value',0);
                set(handles.textTest,'Visible','off');
                doIt = false;
            end
        end %%% end while
    else %%%% no class labels or one label for more classes        
        %%%% open dialog window
        doIt = true;
        valTab={'0'};
        uD   = 0; 
        uD1=get(handles.perTrain,'UserData');        
        uD2=get(handles.perVal,'UserData');
        while doIt
            output = inputdlg('All class(es)','% of data',1,valTab);
            if ~isempty(output)                
                uD = str2double(output);
                if isnan(uD) 
                    uD=0; 
                end 
                if ~isempty(uD1) || ~isempty(uD2)
                    sumA = sum([uD1; uD2]);
                else
                    sumA = [];
                end
                %%% create string of ind. class percentages if set
                strSet=strcat('All class(es)',':',int2str(uD),'%');
                %%%% now check with other files
                if sum(uD) > 100 
                    hE=errordlg('Sum of percenteges for test set is more than 100','Error');
                    uiwait(hE);
                    valTab{1}=num2str(uD);
                elseif  sum(uD) == 0
                    set(handles.perTest,'Visible','off','Value',0);
                    set(handles.testSet,'Value',0);
                    set(handles.textTest,'Visible','off');
                    doIt = false;
                elseif ~isempty(sumA)                     
                    if (sum(sumA)+uD) > 100
                        strE=('Sum of percenteges of train,val and test sets is more than 100:');
                        hE=errordlg(strE,'Error');
                        uiwait(hE);
                        valTab{1}=num2str(uD);
                    else
                        set(handles.perTest,'UserData',uD);
                        set(handles.textTest,'String',strSet,'Visible','on','FontWeight','bold');
                        doIt = false;
                    end
                else
                    set(handles.perTest,'UserData',uD);
                    set(handles.textTest,'String',strSet,'Visible','on','FontWeight','bold');
                    doIt = false;
                end
            else %%% end isempty(output)
                set(handles.perTest,'Visible','off','Value',0);
                set(handles.testSet,'Value',0);
                set(handles.textTest,'Visible','off');
                doIt = false;
            end
        end %%% end while
    end

else     
    set(handles.textTest,'Visible','off')
    set(handles.testSet,'Value',0); 
    set(handles.perTest,'Visible','off');     
end 
guidata(hObject,handles)

% --- Executes on button press in segTrain.
function segTest_Callback(hObject, eventdata, handles)
% hObject    handle to segTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet 

if get(handles.corrFile,'UserData')
    fInd=get(handles.corrFile,'UserData'); 
else 
    fInd=paramGenSet.fileIndx; 
end 

% Hint: get(hObject,'Value') returns toggle state of perTrain
if get(hObject,'Value')
    set(handles.perTest,'Visible','off');  
    [indC,strIn] = fcn1(paramGenSet);         
    %%%% open segment panel    
    strT=sprintf('Testing set - Time segments in %s',paramGenSet.fileHeader{fInd}.timeUnit); 
    set(handles.panelSeg,'Units','normalized');
    posP=get(handles.panelSeg,'Position'); 
    posT=get(handles.segTest,'Position');
    nPos = [posT(1), (posT(2)-posP(4)/2), posP(3),  posP(4)];
    set(handles.panelSeg,'Position',nPos);
    set(handles.panelSeg,'Visible','on','Title',strT,'Units','character');
    
    if isfield(paramGenSet,'classLabel')
        if length(unique(paramGenSet.classLabelAll)) == 1
            moreClassLabels = false ;
        else
            moreClassLabels = true;
        end
    else
        moreClassLabels = false ;
    end
    
    
    if moreClassLabels         
        datTab      = zeros(length(indC),2);
        if isfield(paramGenSet.fileHeader{fInd},'maxTime');
            datTab(:,2) = paramGenSet.fileHeader{fInd}.maxTime;
        end
        coleditable = true(1,paramGenSet.numClass);
        set(handles.tableSeg,'parent',handles.panelSeg,'Data',datTab,'ColumnName',{'begin','end'}, ...
            'RowName',eval(strIn),'ColumnEditable',coleditable,'Visible','on', ...
            'Position',[4 4 47.2 15]);
    else
        datTab      = zeros(1,2);
        if isfield(paramGenSet.fileHeader{fInd},'maxTime');
            datTab(:,2) = paramGenSet.fileHeader{fInd}.maxTime;
        end
        coleditable = true(1,1);
        set(handles.tableSeg,'parent',handles.panelSeg,'Data',datTab,'ColumnName',{'begin','end'}, ...
            'RowName','Class(s)','ColumnEditable',coleditable,'Visible','on', ...
            'Position',[4 4 49.5 15]);
    end
    set(handles.pushOKSeg,'Visible','on');
    set(handles.pushCanSeg,'Visible','on');
    set(handles.fileDone,'Visible','off');
    set(handles.trainSet,'Visible','off'); 
    set(handles.valSet,'Visible','off');     
    set(handles.segVal,'Visible','off'); 
    set(handles.segTrain,'Visible','off');
    set(handles.textVal,'Visible','off');
    set(handles.textTrain,'Visible','off'); 
    set(handles.testSet,'Enable','off');
    set(handles.segTest,'Visible','off'); 
else
    set(handles.testSet,'Value',0); 
    set(handles.segTest,'Visible','off'); 
    set(handles.textTest,'Visible','off');
end
guidata(hObject,handles)


% --- Executes on button press in reshBox.
function reshBox_Callback(hObject, eventdata, handles)
% hObject    handle to reshBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reshBox


function numClass_Callback(hObject, eventdata, handles)
% hObject    handle to numClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numClass as text
%        str2double(get(hObject,'String')) returns contents of numClass as a double
global paramGenSet

if ~str2double(get(handles.numClass,'String'))  %% is zero
    errordlg('Minimum value for Number of classes is 1 .... ')
    set(handles.numClass,'String',''); 
else
    %if ~isfield(paramGenSet,'numClass')
        paramGenSet.numClass = str2double(get(hObject,'String')) ;
        str=sprintf('Number of classes: %s \n',get(hObject,'String'));
        set(handles.textNumClass,'String',str,'HorizontalAlignment','left');
        set(handles.numClass,'Visible','off');
    %end
    set(handles.textNumClass,'Visible','on');
    set(handles.reshBox,'Visible','on');
    set(handles.panelTop1,'Visible','on');
    set(handles.panelTop2,'Visible','on');
    set(handles.trainSet,'Visible','on');
    set(handles.valSet,'Visible','on');
    set(handles.testSet,'Visible','on');
    set(handles.fileDone,'Visible','on');
end


guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function numClass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushOKSeg.
function pushOKSeg_Callback(hObject, eventdata, handles)
% hObject    handle to pushOKSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

typeStr=get(handles.panelSeg,'Title');

%%% check values correctness first
errC='Error: '; 
corSeg = true;  
dT = get(handles.tableSeg,'Data');
for i=1:size(dT,1)
    if dT(i,1) > dT(i,2)
        corSeg = false;
        if ~(strncmp(typeStr,'Tes',3) && size(dT,1)==1)
            errC=[errC, 'Class', num2str(i), ','];
        end
    end
end
if ~corSeg
    errC=[errC(1:end-1) ': begin of seg must be smaller than end']; 
    
end 

if corSeg
    if strncmp(typeStr,'Tra',3)
        posText=get(handles.textTrain,'Position');
        posText(1)=60;posText(3)=29;
        set(handles.textTrain,'String','Time segments are set','Visible','on','Position',posText, ...
            'Fontweight','bold');
        set(handles.segTrain,'UserData',get(handles.tableSeg,'Data'));
        set(handles.trainSet,'Enable','on');
        set(handles.segTrain,'Enable','on','Visible','on');
        if get(handles.segVal,'Value')
            set(handles.segVal,'Visible','on');
            set(handles.textVal,'Visible','on');
        end
        if get(handles.segTest,'Value')
            set(handles.segTest,'Visible','on');
            set(handles.textTest,'Visible','on');
        end
    end
    if strncmp(typeStr,'Val',3)
        posText=get(handles.textVal,'Position');
        posText(1)=60;posText(3)=29;
        set(handles.textVal,'String','Time segments are set','Visible','on','Position',posText, ...
            'Fontweight','bold');
        set(handles.segVal,'UserData',get(handles.tableSeg,'Data'));
        set(handles.valSet,'Enable','on');
        set(handles.segVal,'Enable','on','Visible','on');
        if get(handles.segTrain,'Value')
            set(handles.segTrain,'Visible','on');
            set(handles.textTrain,'Visible','on');
        end
        if get(handles.segTest,'Value')
            set(handles.segTest,'Visible','on');
            set(handles.textTest,'Visible','on');
        end
    end
    if strncmp(typeStr,'Tes',3)
        posText=get(handles.textTest,'Position');
        posText(1)=60;posText(3)=29;
        set(handles.textTest,'String','Time segments are set','Visible','on','Position',posText, ...
            'Fontweight','bold');
        set(handles.segTest,'UserData',get(handles.tableSeg,'Data'));
        set(handles.testSet,'Enable','on');
        set(handles.segTest,'Enable','on','Visible','on');
        if get(handles.segTrain,'Value')
            set(handles.segTrain,'Visible','on');
            set(handles.textTrain,'Visible','on');
        end
        if get(handles.segVal,'Value')
            set(handles.segVal,'Visible','on');
            set(handles.textVal,'Visible','on');
        end
    end
    set(handles.trainSet,'Visible','on');
    set(handles.valSet,'Visible','on');
    set(handles.testSet,'Visible','on');
    set(handles.fileDone,'Visible','on');
    set(handles.panelSeg,'Visible','off');
    set(handles.tableSeg,'Visible','off');
    set(handles.pushOKSeg,'Visible','off');
    set(handles.pushCanSeg,'Visible','off');
else 
    set(handles.pushOKSeg,'Enable','off');
    set(handles.pushCanSeg,'Enable','off');
    set(handles.tableSeg,'Enable','off');    
    hE=errordlg(errC,'Error: begin > end');  
    uiwait(hE);  
    set(handles.pushOKSeg,'Enable','on');
    set(handles.pushCanSeg,'Enable','on');
    set(handles.tableSeg,'Enable','on');
end
guidata(hObject,handles)

%end

% --- Executes on button press in pushCanSeg.
function pushCanSeg_Callback(hObject, eventdata, handles)
% hObject    handle to pushCanSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if get(handles.pushCanSeg,'Value')
typeStr=get(handles.panelSeg,'Title');
if strncmp(typeStr,'Tra',3)
    set(handles.segTrain,'Visible','off','Value',0);
    set(handles.trainSet,'Value',0);
    set(handles.trainSet,'Enable','on');
    %set(handles.segTrain,'Enable','on','Visible','on');
    if get(handles.segTest,'Value')
        set(handles.segTest,'Visible','on');
        set(handles.textTest,'Visible','on');
    end
    if get(handles.segVal,'Value')
       set(handles.segVal,'Visible','on');
       set(handles.textVal,'Visible','on');
    end
end
if strncmp(typeStr,'Val',3)
    set(handles.segVal,'Visible','off','Value',0);
    set(handles.valSet,'Value',0);
    set(handles.valSet,'Enable','on');
    %set(handles.segVal,'Enable','on','Visible','on');
    if get(handles.segTrain,'Value')
        set(handles.segTrain,'Visible','on');
        set(handles.textTrain,'Visible','on');
    end
    if get(handles.segTest,'Value')
        set(handles.segTest,'Visible','on');
        set(handles.textTest,'Visible','on');
    end
end
if strncmp(typeStr,'Tes',3)
    set(handles.segTest,'Visible','off','Value',0);
    set(handles.testSet,'Value',0);
    set(handles.testSet,'Enable','on');
    %set(handles.segTest,'Enable','on','Visible','on');
    if get(handles.segTrain,'Value')
        set(handles.segTrain,'Visible','on');
        set(handles.textTrain,'Visible','on');
    end
    if get(handles.segVal,'Value')
        set(handles.segVal,'Visible','on');
        set(handles.textVal,'Visible','on');
    end
end
set(handles.trainSet,'Visible','on');
set(handles.valSet,'Visible','on');
set(handles.testSet,'Visible','on');
set(handles.fileDone,'Visible','on');
set(handles.panelSeg,'Visible','off');
set(handles.tableSeg,'Visible','off');
set(handles.pushOKSeg,'Visible','off');
set(handles.pushCanSeg,'Visible','off');
%end
guidata(hObject,handles)
    
 
% --- Executes on button press in fileDone.
function fileDone_Callback(hObject, eventdata, handles)
% hObject    handle to fileDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenSet
global tmpCorr

%%%% switch off visibility ..... 
hNames=fieldnames(handles);
for i=1:length(hNames)
    if ~((strcmp(hNames{i},'figure1')) | (strcmp(hNames{i},'File')) | ...
            (strcmp(hNames{i},'Open')) | (strcmp(hNames{i},'output')))
        hTmp=strcat('handles.',hNames{i});
        if isprop(eval(hTmp),'Visible')
            set(eval(hTmp),'Visible','off');
        end
     end
end

%%%% read parameters
if get(handles.corrFile,'UserData')
   indE=get(handles.corrFile,'UserData'); 
   corrFile  = true; 
   set(handles.corrFile,'UserData',[]);
else
    indE=paramGenSet.fileIndx;
    corrFile = false;  
end

%%%% check if s.t. selected 
fSel = true;
if ~get(handles.trainSet,'Value') && ~get(handles.valSet,'Value') && ~get(handles.testSet,'Value')
    fSel = false;
else
    if get(handles.trainSet,'Value') && ~get(handles.perTrain,'Value') && ~get(handles.segTrain,'Value')
        fSel= false;
    end
    if get(handles.valSet,'Value')   &&  ~get(handles.perVal,'Value')  && ~get(handles.segVal,'Value')
        fSel= false;
    end
    if get(handles.testSet,'Value')  &&  ~get(handles.perTest,'Value') && ~get(handles.segTest,'Value')
        fSel= false;
    end
end
%if get(handles.trainSet,'Value') || get(handles.valSet,'Value') || get(handles.testSet,'Value')    
if fSel 
    if get(handles.reshBox,'Value')
        paramGenSet.reshuffle(indE) = true;
    else
        paramGenSet.reshuffle(indE) = false;
    end    
    %%%%% train
    if ~get(handles.trainSet,'Value'); %%%% train set not defined
        if ~isempty(get(handles.perVal,'UserData')) || ~isempty(get(handles.perTest,'UserData'))
            paramGenSet.trainSet{indE}.perClass = [];
        elseif  ~isempty(get(handles.segVal,'UserData')) || ~isempty(get(handles.segTest,'UserData'))
            paramGenSet.trainSet{indE}.segClass  = [];
        end
    else
        if get(handles.perTrain,'Value')
            paramGenSet.trainSet{indE}.perClass=get(handles.perTrain,'UserData');
        elseif get(handles.segTrain,'Value')
            paramGenSet.trainSet{indE}.segClass=zeros(paramGenSet.numClass,2);
            [indC] = fcn1(paramGenSet);
            paramGenSet.trainSet{indE}.segClass(indC,:)=get(handles.segTrain,'UserData');
        end
    end
    %%%%% validation
    if ~get(handles.valSet,'Value'); %%%% val set not defined
        if ~isempty(get(handles.perTrain,'UserData')) || ~isempty(get(handles.perTest,'UserData'))
            paramGenSet.valSet{indE}.perClass = [];
        elseif  ~isempty(get(handles.segTrain,'UserData')) || ~isempty(get(handles.segTest,'UserData'))
            paramGenSet.valSet{indE}.segClass  = [];
        end
    else
        if get(handles.perVal,'Value')
            paramGenSet.valSet{indE}.perClass=get(handles.perVal,'UserData');
        elseif get(handles.segVal,'Value')
            paramGenSet.valSet{indE}.segClass=zeros(paramGenSet.numClass,2);
            [indC] = fcn1(paramGenSet);
            paramGenSet.valSet{indE}.segClass(indC,:)=get(handles.segVal,'UserData');
        end
    end
    %%%%% test
    if ~get(handles.testSet,'Value'); %%%% val set not defined
        if ~isempty(get(handles.perTrain,'UserData')) || ~isempty(get(handles.perVal,'UserData'))
            paramGenSet.testSet{indE}.perClass = [];
        elseif  ~isempty(get(handles.segTrain,'UserData')) || ~isempty(get(handles.segVal,'UserData'))
            paramGenSet.testSet{indE}.segClass  = [];
        end
    else
        if get(handles.testSet,'Value')
            if get(handles.perTest,'Value')
                paramGenSet.testSet{indE}.perClass=get(handles.perTest,'UserData');
            elseif get(handles.segTest,'Value')
                if isfield(paramGenSet,'classLabel') && (length(unique(paramGenSet.classLabelAll)) > 1)
                    paramGenSet.testSet{indE}.segClass=zeros(paramGenSet.numClass,2);
                    [indC] = fcn1(paramGenSet);
                    paramGenSet.testSet{indE}.segClass(indC,:)=get(handles.segTest,'UserData');
                else
                    paramGenSet.testSet{indE}.segClass=zeros(1,2);                    
                    paramGenSet.testSet{indE}.segClass(1,:)=get(handles.segTest,'UserData');
                end
            end
        end
    end
    % %%%%% print parameters to separte figure    
    handles = printParameters(paramGenSet,handles);  
else
    if  corrFile
        hW=warndlg('Warning - file was not corrected, becouse none set selected');
        uiwait(hW);
        paramGenSet.trainSet{indE}= tmpCorr.trainSet;
        paramGenSet.valSet{indE}  = tmpCorr.valSet;
        paramGenSet.testSet{indE} = tmpCorr.testSet;
        handles = printParameters(paramGenSet,handles);
    elseif indE == 1
        %paramGenSet = []; 
        paramGenSet.fileIndx = paramGenSet.fileIndx - 1; 
        paramGenSet.fileName{1}   = []; 
        paramGenSet.pathName{1}   = []; 
        paramGenSet.fileHeader{1} = []; 
        if isfield(paramGenSet,'classLabel')
            paramGenSet=rmfield(paramGenSet,'classLabel');
        end
        paramGenSet=rmfield(paramGenSet,'numClass');        
        set(handles.textNumClass,'String','Number of classes: ');
        set(handles.numClass,'String',[]);      
        hW=warndlg('Warning - none set selected');   
        uiwait(hW);
    else 
        paramGenSet.fileIndx = paramGenSet.fileIndx - 1; 
        paramGenSet.fileName(end) = []; 
        paramGenSet.pathName(end) = []; 
        hW=warndlg('Warning - none set selected') ; 
        uiwait(hW);
        handles = printParameters(paramGenSet,handles);
    end     
end


%%%% reset parameters to run new file 
%%%%% resetting values & clear some properties 
for i=1:length(hNames)
    if ~((strcmp(hNames{i},'figure1')) | (strcmp(hNames{i},'File')) | ...
            (strcmp(hNames{i},'Open')) | (strcmp(hNames{i},'output')) | (strcmp(hNames{i},'listboxSum')))
        hTmp=strcat('handles.',hNames{i});
       % if isprop(eval(hTmp),'Visible')
       %     set(eval(hTmp),'Visible','off');
       % end         
        if isprop(eval(hTmp),'Value') 
            set(eval(hTmp),'Value',0);
        end
        if isprop(eval(hTmp),'UserData')
            set(eval(hTmp),'UserData',[]); 
        end        
    end
end

if paramGenSet.fileIndx > 0
    set(handles.loadFile,'Visible','on');
    set(handles.repFile,'Visible','on');
    set(handles.corrFile,'Visible','on');
    set(handles.delFile,'Visible','on');
    set(handles.pushFinishSelection,'Visible','on');
else
    set(handles.loadFile,'Visible','on');
    set(handles.loadParam,'Visible','on');
end

guidata(hObject,handles)


% --- Executes on button press in loadFile.
function loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenSet

set(handles.corrFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
set(handles.pushFinish,'Visible','off');

set(handles.loadFile,'Visible','off');
set(handles.loadParam,'Visible','off');
    
[fileName, pathName] = uigetfile ({'./Data/FeaturesData/*.mat'},'Open File'); 
pathName=getRelPath(pathName); 

if fileName
    if isfield(paramGenSet,'fileIndx')
        paramGenSet.fileIndx = paramGenSet.fileIndx + 1;
    else
        paramGenSet.fileIndx = 1;
    end
    paramGenSet.fileName{paramGenSet.fileIndx} = fileName;
    paramGenSet.pathName{paramGenSet.fileIndx} = pathName;
    %%% load header file
    strF=strcat(pathName,fileName);
    warning off
    load(strF,'header')
    warning on
    if ~exist('header','var')
        hE=errordlg('Header not present in the file ...','Error - header missing');
        uiwait(hE);
        toDo = 5;
    else
        paramGenSet.fileHeader{paramGenSet.fileIndx} = header;
        if paramGenSet.fileIndx == 1
            %%% pass info about multi way structure of features data
            paramGenSet.Xlabels  = header.Xlabels;
            if isfield(header,'origXlabels')
                paramGenSet.origXlabels  = header.origXlabels;
            end
            paramGenSet.multiWay = header.multiWay;
            paramGenSet.numCol   =  header.Xsize(2); 
            if isfield(header,'freqIn')
                paramGenSet.freqIn   = header.freqIn;
                paramGenSet.fLines  = header.f_lines_in;
            end
            if isfield(header,'errorType')
                paramGenSet.errorType=header.errorType;
            end
            if isfield(header,'classLabel')
                strI = ['File contains ', num2str(length(header.classLabel)),' class labels ... Use them?'];
                hC=questdlg(strI,'Class labels present','yes','no','yes');
                switch hC
                    case 'yes'
                        paramGenSet.classLabelAvail=header.classLabel; 
                        strI=['Enter number of classes for (', num2str(length(header.classLabel)),' labels present)'];
                        prompt = {strI};
                        num_lines = 1;
                        def = {'2'};
                        dlg_title = 'Number of classes';
                        options.Resize='on';
                        options.WindowStyle='normal';
                        options.Interpreter='tex';
                        answer = inputdlg(prompt,dlg_title,num_lines,def,options);
                        if ~isempty(answer)
                            paramGenSet.numClass= str2num(answer{1});
                            switch paramGenSet.numClass
                                case 1
                                    paramGenSet.classLabel=[1]; 
                                case 2 
                                    paramGenSet.classLabel=[-1 1]; 
                                otherwise
                                    paramGenSet.classLabel=[1:paramGenSet.classLabel];    
                            end 
                            paramGenSet = def_class(paramGenSet,header.classLabel);
                            %paramGenSet.classLabelAvail=paramGenSet.classLabelAll; 
                            if isfield(paramGenSet,'classLabel')
                                toDo=1;
                            else
                                toDo=2; %%% don't use labels 
                            end
                        else
                            toDo=5;
                        end
                    case 'no'
                        toDo = 2; %%% don't use labels 
                end
            else %%% dont't use labels
                toDo = 2;
            end
        elseif isfield(paramGenSet,'freqIn') && length(paramGenSet.fLines) ~= length(header.f_lines_in)
            hE=errordlg('length of frequency lines  ...','Error - variables mismatch');
            uiwait(hE);
            toDo = 5;
        elseif paramGenSet.numCol ~= header.Xsize(2) 
            hE=errordlg('number of columns in the file don''t match with the previous file(s)   ...','Error - number of columns mismatch');
            uiwait(hE);
            toDo = 5;
        elseif isfield(paramGenSet,'freqIn') && ~isempty(setdiff(paramGenSet.fLines,header.f_lines_in))
            hE=errordlg('frequency lines in the file don''t match with the previous file(s) ...','Error - variables mismatch');
            uiwait(hE);
            toDo = 5;
        elseif isfield(paramGenSet,'Xlabels') && length(paramGenSet.Xlabels) ~= length(header.Xlabels)
            hE=errordlg('length of variables in the file don''t match with the previous file(s) ...','Error - variables mismatch');
            uiwait(hE);
            toDo = 5;
        elseif  isfield(paramGenSet,'Xlabels') && sum(find(strcmpi(paramGenSet.Xlabels,header.Xlabels)==0))
            hE=errordlg('Xlables present in the file don''t match with the previous file(s)...','Error - labels mismatch');
            uiwait(hE);
            toDo = 5;
        elseif isfield(paramGenSet,'classLabel')  && ~isfield(header,'classLabel')
            hE=errordlg('Error: This file contains no class labels ....');
            uiwait(hE);
            toDo=5;
            %%%% remove this guy
            paramGenSet.fileName(end)=[];
            paramGenSet.pathName(end)=[];
            paramGenSet.fileHeader(end)=[];
            paramGenSet.fileIndx = paramGenSet.fileIndx - 1;
        elseif isfield(paramGenSet,'classLabel')  && isfield(header,'classLabel') && (length(unique(paramGenSet.classLabelAll)) > 1)
            labD=setdiff(header.classLabel,paramGenSet.classLabelAvail);
            paramGenSet.classLabelAvail=[paramGenSet.classLabelAvail,header.classLabel]; %%% keep record of all possible labels 
            if ~isempty(labD)
                %%%%% add class !
                strI='File contains additional class label(s):';
                for l=1:length(labD)-1
                    strI=strcat(strI,int2str(labD(l)),',');
                end
                strI=strcat(strI,int2str(labD(end)),'... Add them?');
                hA=questdlg(strI,'Additional class labels present ... ','yes','no','no');
                switch hA
                    case 'yes'
                        paramGenSet = add_class(paramGenSet,labD);
                end
            end
            if isfield(paramGenSet,'errorType')
                if ~isfield(header,'errorType')
                    hE=warndlg('Warning: error variable(s) missing .... error info will not be used !','Missing error variable(s)');
                    uiwait(hE);
                    paramGenSet=rmfield(paramGenSet,'errorType');
                elseif sum(find(strcmpi(paramGenSet.errorType,header.errorType)==0))
                    hE=warndlg('Warning: error variable(s) in the file don''t match with the previous file(s) .... error info will not be used !','Mismatch error variable(s)');
                    uiwait(hE);
                    paramGenSet=rmfield(paramGenSet,'errorType');
                end
            end
            toDo = 1;
        elseif isfield(paramGenSet,'errorType') && ~isfield(header,'errorType')
            hE=warndlg('Warning: error variable(s) missing .... error info will not be used !','Missing error variable(s)');
            uiwait(hE);
            paramGenSet=rmfield(paramGenSet,'errorType');
            toDo = 3;
        elseif isfield(paramGenSet,'errorType') && isfield(header,'errorType')
            if  sum(find(strcmpi(paramGenSet.errorType,header.errorType)==0))
                hE=warndlg('Warning: error variable(s) in the file don''t match with the previous file(s) .... error info will not be used !','Mismatch error variable(s)');
                uiwait(hE);
                paramGenSet=rmfield(paramGenSet,'errorType');                
            end
            toDo = 3;
        else %%%% labels not used ....
            toDo = 3;
        end
    end
elseif isfield(paramGenSet,'fileIndx') 
    toDo = 4; 
else 
    toDo = 5;
end %%% end fileName
switch toDo
    case {1,2,3}
        if isfield(paramGenSet,'classLabel')
            [sI,pI]=intersect(paramGenSet.classLabelAll,paramGenSet.fileHeader{paramGenSet.fileIndx}.classLabel);
            if ~isempty(sI)
                strFN=['Labels present:',' '];                                
                iiS=sort(pI);
                for jj=1:length(iiS)
                    strFN=[strFN,int2str(paramGenSet.classLabelAll(iiS(jj))),','];
                end
                strFN=strFN(1:end-1);
                strT={fileName; strFN};
                set(handles.textFile,'Visible','on','String',strT);
            else
                set(handles.textFile,'Visible','on','String',fileName);
            end
        else
            set(handles.textFile,'Visible','on','String',fileName);
        end
        posT=get(handles.textFile,'Position');
end
switch toDo
    case 1
        str{1}=sprintf('Number of classes: %d  ',paramGenSet.numClass);
        if isfield(paramGenSet,'classLabel')
            str{2}='Labels by class: ';
            for c=1:length(paramGenSet.classN)
                str{2}=[str{2},'{'];
                for kk=1:length(paramGenSet.classN{c})
                    str{2}=[str{2},num2str(paramGenSet.classN{c}(kk)),','];
                end
                str{2}(end:end+1)='},';
            end
            str{2}=str{2}(1:end-1);
        end
        set(handles.textNumClass,'Visible','on','String',str,'HorizontalAlignment','left');             
        set(handles.reshBox,'Visible','on');
        set(handles.panelTop1,'Visible','on');
        set(handles.panelTop2,'Visible','on');
        set(handles.trainSet,'Visible','on');
        set(handles.valSet,'Visible','on');
        set(handles.testSet,'Visible','on');
        set(handles.fileDone,'Visible','on');
    case 2
        %posT(1)=posT(1) + 30;
        set(handles.textNumClass,'Visible','on','HorizontalAlignment','right');
        set(handles.numClass,'Visible','on');
    case 3        
        %posT(1)=posT(1) + 30;
        set(handles.textNumClass,'Visible','on','HorizontalAlignment','right');
        set(handles.reshBox,'Visible','on');
        set(handles.panelTop1,'Visible','on');
        set(handles.panelTop2,'Visible','on');
        set(handles.trainSet,'Visible','on');
        set(handles.valSet,'Visible','on');
        set(handles.testSet,'Visible','on');
        set(handles.fileDone,'Visible','on');   
    case 4 
        set(handles.loadFile,'Visible','on');
        set(handles.repFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
    case 5
        set(handles.loadFile,'Visible','on');
        set(handles.loadParam,'Visible','on');
end

guidata(hObject,handles) 


% --- Executes on button press in corrFile.
function corrFile_Callback(hObject, eventdata, handles)
% hObject    handle to corrFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenSet
global tmpCorr

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','single', 'ListString',paramGenSet.fileName, ...
    'Name', 'Correct file');

if ok_click
    set(handles.corrFile,'UserData',listNum); %%% correction true 
    
    set(handles.textFile,'Visible','on','String',paramGenSet.fileName{listNum});
    set(handles.textNumClass,'Visible','on');
    
    set(handles.reshBox,'Visible','on','Value',paramGenSet.reshuffle(listNum));
    set(handles.panelTop1,'Visible','on');
    set(handles.panelTop2,'Visible','on');
    set(handles.fileDone,'Visible','on');
    
    set(handles.trainSet,'Visible','on','Value',0);
    set(handles.valSet,'Visible','on','Value',0);
    set(handles.testSet,'Visible','on','Value',0);
    
    tmpCorr.trainSet = paramGenSet.trainSet{listNum};
    tmpCorr.valSet   = paramGenSet.valSet{listNum};
    tmpCorr.testSet  = paramGenSet.testSet{listNum}; 
    
    paramGenSet.trainSet{listNum}= []; 
    paramGenSet.valSet{listNum}  = []; 
    paramGenSet.testSet{listNum} = []; 


    %%% train
%     if  length(paramGenSet.trainSet) >= listNum
%         if ~isempty(paramGenSet.trainSet{listNum})
%             set(handles.trainSet,'Visible','on','Value',0);
%             set(handles.perTrain,'Visible','on','Value',0);
%             set(handles.segTrain,'Visible','on','Value',0);
%             posText=get(handles.textTrain,'Position');
%             if isfield(paramGenSet.trainSet{listNum},'perClass')
%                 posText(1)=30;posText(3)=29;
%                 set(handles.textTrain,'String','Correct exisiting %','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             elseif isfield(paramGenSet.trainSet{listNum},'segClass')
%                 posText(1)=60;posText(3)=29;
%                 set(handles.textTrain,'String','Correct exisitng segments','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             end
%         else
%             set(handles.trainSet,'Visible','on','Value',0);
%         end
%     else
%         set(handles.trainSet,'Visible','on','Value',0);
%     end
%     %%%% val
%     if  length(paramGenSet.valSet) >= listNum
%         if ~isempty(paramGenSet.valSet{listNum})
%             set(handles.valSet,'Visible','on','Value',0);
%             set(handles.perVal,'Visible','on','Value',0);
%             set(handles.segVal,'Visible','on','Value',0);
%             posText=get(handles.textVal,'Position');
%             if isfield(paramGenSet.valSet{listNum},'perClass')
%                 posText(1)=30;posText(3)=29;
%                 set(handles.textVal,'String','Correct exisiting %','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             elseif isfield(paramGenSet.valSet{listNum},'segClass')
%                 posText(1)=60;posText(3)=29;
%                 set(handles.textVal,'String','Correct exisitng segments','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             end
%         else
%             set(handles.valSet,'Visible','on','Value',0);
%         end
%     else
%         set(handles.valSet,'Visible','on','Value',0);
%     end
%     %%%% test 
%     if  length(paramGenSet.testSet) >= listNum
%         if ~isempty(paramGenSet.testSet{listNum})
%             set(handles.testSet,'Visible','on','Value',true);
%             set(handles.perTest,'Visible','on','Value',false);
%             set(handles.segTest,'Visible','on','Value',false);
%             posText=get(handles.textTest,'Position');
%             if isfield(paramGenSet.testSet{listNum},'perClass')
%                 posText(1)=30;posText(3)=29;
%                 set(handles.textTest,'String','Correct exisiting %','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             elseif isfield(paramGenSet.testSet{listNum},'segClass')
%                 posText(1)=60;posText(3)=29;
%                 set(handles.textTest,'String','Correct exisitng segments','Visible','on','Position',posText, ...
%                     'Fontweight','bold');
%             end
%         else
%             set(handles.testSet,'Visible','on','Value',0);
%         end
%     else
%         set(handles.testSet,'Visible','on','Value',0);
%     end
    
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
global paramGenSet

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
%set(handles.pushFinish,'Visible','off');


[listNum, ok_click] = listdlg('PromptString','Select file which parameteres to replicate', ...
    'SelectionMode','single', 'ListString',paramGenSet.fileName, ...
    'Name', 'Select file to replicate');


if ok_click
    
%     %%%%  MODIFICATION start %%%%
%     SubNo = '202-noO1art';
%     podtrznik = strfind( paramGenSet.fileName{1}, '_' );
%     switch paramGenSet.fileName{1}(podtrznik(2)+1:podtrznik(2)+3)
% %         case 'ECE'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',SubNo(1:3), ...
% %                 '_',paramGenSet.fileName{1}(podtrznik(1)+1:podtrznik(2)-1),'_ECS.mat')}, ...
% %                 'Open File','MultiSelect', 'on');
% %             pathName=getRelPath(pathName); 
% %         case 'ECS'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',SubNo(1:3), ...
% %                 '_',paramGenSet.fileName{1}(podtrznik(1)+1:podtrznik(2)-1),'_EOE.mat')}, ...
% %                 'Open File','MultiSelect', 'on');
% %             pathName=getRelPath(pathName); 
% %         case 'EOE'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',SubNo(1:3), ...
% %                 '_',paramGenSet.fileName{1}(podtrznik(1)+1:podtrznik(2)-1),'_EOS.mat')}, ...
% %                 'Open File','MultiSelect', 'on');
% %             pathName=getRelPath(pathName); 
% %         case 'EOS'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',SubNo(1:3), ...
% %                 '_',num2str(str2double(paramGenSet.fileName{1}(podtrznik(1)+1:podtrznik(2)-1))+1),'_ECE.mat')}, ...
% %                 'Open File','MultiSelect', 'on');
% %             pathName=getRelPath(pathName); 
%         case 'VLH'
%             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
%                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',SubNo(1:3), ...
%                 '_',num2str(str2double(paramGenSet.fileName{1}(podtrznik(1)+1:podtrznik(2)-1))+1), ...
%                 '_VLH.mat')},'Open File','MultiSelect', 'on');
%             pathName=getRelPath(pathName); 
%     end
%     
%     
% %     switch paramGenSet.fileName{1}(8:10)
% %         case 'ECE'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',...
% %                 '201_',paramGenSet.fileName{1}(5:6),'_ECS.mat')},'Open File','MultiSelect', 'on');
% %     pathName=getRelPath(pathName); 
% %         case 'ECS'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',...
% %                 '201_',paramGenSet.fileName{1}(5:6),'_EOE.mat')},'Open File','MultiSelect', 'on');
% %     pathName=getRelPath(pathName); 
% %         case 'EOE'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',...
% %                 '201_',paramGenSet.fileName{1}(5:6),'_EOS.mat')},'Open File','MultiSelect', 'on');
% %     pathName=getRelPath(pathName); 
% %         case 'EOS'
% %             [fileName, pathName, filtInd] = uigetfile ({strcat('./Data/FeaturesData/Sub',SubNo, ...
% %                 '/win2sec_overlap250msec_fs128Hz_fft_hann_log_power/',...
% %                 '201_',num2str(str2double(paramGenSet.fileName{1}(5:6))+1),'_ECE.mat')},'Open File','MultiSelect', 'on');
% %     pathName=getRelPath(pathName); 
% %     end
% 
% %%%% MODIFICATION end %%%%
    
%%%% ORIGINAL CODE %%%%
    [fileName, pathName, filtInd] = uigetfile ({'./Data/FeaturesData/'},'Open File','MultiSelect', 'on');
    pathName=getRelPath(pathName); 
    
    if filtInd
        %fileIn = false;strFileIn = [];
        if iscell(fileName)
            lenFile = length(fileName);
            fileInd = ones(lenFile,1);
            %             %for i=1:lenFile
            %              %   if sum(strcmp(paramGenSet.fileName,fileName{i})) && sum(strcmp(paramGenSet.pathName,pathName))
            %                     %fileIn = true;
            %                     %strFileIn = [strFileIn, ',', fileName{i}];
            %                     %fileInd(i)=0;
            %                 %end
            %             %end
        else
            lenFile = 1;
            fileInd = 1;
            %             %if sum(strcmp(paramGenSet.fileName,fileName)) && sum(strcmp(paramGenSet.pathName,pathName))
            %                 %fileIn = true;
            %             %    strFileIn = [strFileIn, ',', fileName];
            %                 fileInd = 0;
            %             %end
        end
        %if fileIn
        %    strFileIn = ['These file(s) are alrady in: ',strFileIn(2:end), '.... will not be added !!!'];
        %    hE=errordlg(strFileIn,'Warning - file(s) alrady in');
        %    uiwait(hE);
        %end
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
                    iE = paramGenSet.fileIndx + 1;
                    paramGenSet.fileIndx = iE;
                    paramGenSet.fileHeader{iE} = header;
                    paramGenSet.fileName{iE}   = fName;
                    paramGenSet.pathName{iE}   = pathName;
                    %%%% copy other parameters
                    paramGenSet.trainSet{iE} = paramGenSet.trainSet{listNum};
                    paramGenSet.valSet{iE}   = paramGenSet.valSet{listNum};
                    paramGenSet.testSet{iE}  = paramGenSet.testSet{listNum};
                    paramGenSet.reshuffle(iE)= paramGenSet.reshuffle(listNum);
                end
            end
        end
    end
end
           
handles = printParameters(paramGenSet,handles);
    
set(handles.loadFile,'Visible','on');
set(handles.repFile,'Visible','on');
set(handles.delFile,'Visible','on');
set(handles.corrFile,'Visible','on');
set(handles.pushFinishSelection,'Visible','on');


guidata(hObject,handles) 

% --- Executes on button press in delFile.
function delFile_Callback(hObject, eventdata, handles)
% hObject    handle to delFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet

set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');
set(handles.pushFinish,'Visible','off');


[listNumAll, ok_click] = listdlg('PromptString','Select a file to correct', ...
    'SelectionMode','multiple', 'ListString',paramGenSet.fileName, ...
    'Name', 'Correct file');
if ok_click
    if paramGenSet.fileIndx    == 1 %%% the first and the only one
        paramGenSet.fileIndx    = 0;
        paramGenSet.fileName    = [];
        paramGenSet.pathName    = [];
        paramGenSet.trainSet    = [];
        paramGenSet.valSet      = [];
        paramGenSet.testSet     = [];
        if isfield(paramGenSet,'classLabel')
            paramGenSet=rmfield(paramGenSet,'classLabel');
        end
        if isfield(paramGenSet,'freqInl')
            paramGenSet=rmfield(paramGenSet,'freqIn');
            paramGenSet=rmfield(paramGenSet,'fLines');
        end
        if isfield(paramGenSet,'Xlabels')
            paramGenSet=rmfield(paramGenSet,'Xlabels');
        end
        paramGenSet=rmfield(paramGenSet,'fileHeader');
        paramGenSet=rmfield(paramGenSet,'numClass');
        set(handles.textNumClass,'String','Number of classes: ');
        set(handles.numClass,'String','');
        if ~isempty(findobj('Tag','print param'))
            close(findobj('Tag','print param'));
        end
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.loadParam,'Visible','on','Enable','on');
        
        set(handles.listboxSum,'Visible','off');
    else
        paramGenSet.fileIndx  = paramGenSet.fileIndx  - length(listNumAll);
        paramGenSet.fileName(listNumAll) = [];
        paramGenSet.pathName(listNumAll) = [];
        paramGenSet.fileHeader(listNumAll) = [];
        paramGenSet.trainSet(listNumAll)= [];
        paramGenSet.valSet(listNumAll)= [];
        paramGenSet.testSet(listNumAll)= [];
        set(handles.loadFile,'Visible','on');
        handles = printParameters(paramGenSet,handles);
    end
    if paramGenSet.fileIndx > 0
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


% --- Executes on button press in pushFinish.
function pushFinish_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenSet

set(handles.pushGenSet,'Visible','on');
set(handles.pushSaveParam,'Visible','on');

pSave= get(handles.pushSaveParam,'UserData') ; 

%if pSave
if isfield(paramGenSet,'paramSaveFile')
    save(paramGenSet.paramSaveFile,'paramGenSet'); 
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

% --- Executes on button press in pushFinishSelection.
function pushFinishSelection_Callback(hObject, eventdata, handles)
% hObject    handle to pushFinishSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loadFile,'Visible','off');
set(handles.repFile,'Visible','off');
set(handles.delFile,'Visible','off');
set(handles.corrFile,'Visible','off');
set(handles.pushFinishSelection,'Visible','off');

set(handles.pushGenSet,'Visible','on');
set(handles.pushSaveParam,'Visible','on');
set(handles.pushFinish,'Visible','on');
set(handles.pushGoBack,'Visible','on');

guidata(hObject,handles)

% --- Executes on button press in pushGenSet.

function pushGenSet_Callback(hObject, eventdata, handles)
% hObject    handle to pushGenSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paramGenSet

 set(handles.pushGenSet,'Enable','off');
 set(handles.pushSaveParam,'Enable','off');
 set(handles.pushFinish,'Enable','off');
 set(handles.pushGoBack,'Enable','off');
 

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'},'Save genereted sets as ...', ...
                              strcat('./Data/TrainValTest/data_',paramGenSet.fileName{1}(1:end-4),'.mat'));
%[fName, pathName] = uiputfile( {'*.mat','MATLAB File'},'Save genereted sets as ...', ...
%                               strcat('./Data/TrainValTest/Sub', SubNo,'/data_', ...
%                               paramGenSet.fileName{1}(1:podtrznik(2)+3),'_1class_2sec_250ms.mat'));


%  [fName, pathName] = uiputfile( {'*.mat','MATLAB File'},'Save genereted sets as ...', ...
%                                strcat('./Data/TrainValTest/Sub201-log-power/data_',paramGenSet.fileName{1}(1:10),'_1class_2sec_250ms.mat'));
pathName=getRelPath(pathName); 

if fName    
     paramGenSet.fileNameGenSet=fName; 
     paramGenSet.pathNameGenSet=pathName; 
     genTrainValTestSplits(paramGenSet);  
end

set(handles.pushGenSet,'Enable','on');
set(handles.pushSaveParam,'Enable','on');
set(handles.pushFinish,'Enable','on');
set(handles.pushGoBack,'Enable','on');

guidata(hObject,handles)


% --- Executes on button press in pushSaveParam.
function pushSaveParam_Callback(hObject, eventdata, handles)
% hObject    handle to pushSaveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
global paramGenSet

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ... 
                                  'Save parameters as ...','./ParameterFiles/param_GenerateSets.mat');
pathName=getRelPath(pathName);                               
if fName
    str=strcat(pathName,fName);
    paramGenSet.paramSaveFile=str; 
    handles = printParameters(paramGenSet,handles);   
    save(str,'paramGenSet'); 
    %set(handles.pushSaveParam,'UserData',true);
end 
guidata(hObject,handles)


% --- Executes on button press in loadParam.
function loadParam_Callback(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global paramGenSet

set(handles.loadFile,'Enable','off'); 
set(handles.loadParam,'Enable','off'); 

[fileName, pathName] = uigetfile ({'./ParameterFiles/Sub201/*.mat'},'Open File');
pathName=getRelPath(pathName); 

if fileName
    %%% load parameters    
    strF=strcat(pathName,fileName);
    warning off 
    s=load(strF,'paramGenSet');
    warning on 
        
    if ~isfield(s,'paramGenSet')       
        hE=msgbox([fileName,' is not a correct parameter''s file'],'Error - not parameter''s file','error');
        uiwait(hE);
        set(handles.loadFile,'Enable','on'); 
        set(handles.loadParam,'Enable','on');        
    else
        paramGenSet=s.paramGenSet; 
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
        
        %%%% open print window for sumarry 
        handles = printParameters(paramGenSet,handles); 
        
        set(handles.loadFile,'Visible','on','Enable','on');
        set(handles.repFile,'Visible','on');
        set(handles.corrFile,'Visible','on');
        set(handles.delFile,'Visible','on');
        set(handles.pushFinishSelection,'Visible','on');
        
        %%%% add number of classes string 
        str{1}=sprintf('Number of classes: %d \n',paramGenSet.numClass);
        if isfield(paramGenSet,'classLabel')
            str{2}='Labels used:';
            for i=1:paramGenSet.numClass
                str{2}=strcat(str{2},int2str(paramGenSet.classLabelAll(i)),',');
            end
        end
        set(handles.textNumClass,'String',str);         
    end
else 
   set(handles.loadFile,'Enable','on'); 
   set(handles.loadParam,'Enable','on');
end

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
        pStr=strcat('number of classes:',int2str(param.numClass));
        strLB=[strLB;pStr];
        if isfield(param,'classLabel')
            %if isfield(paramGenSet,'classLabel')
            pStr='class lables :';
            for c=1:length(param.classN)
                pStr=[pStr,'{'];
                for kk=1:length(param.classN{c})
                     pStr=[ pStr,num2str(param.classN{c}(kk)),','];
                end
                 pStr(end:end+1)='},';
            end
             %pStr= pStr(1:end-1);
        %end
%             pStr='class lables :';
%             for c=1:length(param.classLabel)
%                 pStr=strcat(pStr,num2str(param.classLabel(c)),','); 
%             end 
            strLB=[strLB;pStr(1:end-1)];
        end 
        if param.reshuffle(i)
            pStr=strcat('reshuffle:','yes');
        else
            pStr=strcat('reshuffle:','no');
        end
        strLB=[strLB;pStr];
        %%%% train
        if (length(param.trainSet) >=i)
            if ~isempty(param.trainSet{i})
                if isfield(param.trainSet{i},'perClass')
                    strLB=[strLB; 'train blocks:'];
                    for c=1:size(param.trainSet{i}.perClass,2)
                        pstr=strcat('class',int2str(c),': ',num2str(param.trainSet{i}.perClass(c)),'%');
                        strLB=[strLB;pstr];
                    end
                elseif isfield(param.trainSet{i},'segClass')
                    strLB=[strLB; 'train blocks:'];
                    for c=1:size(param.trainSet{i}.segClass,1)
                        pstr=strcat('class',int2str(c),': begin:',num2str(param.trainSet{i}.segClass(c,1)));
                        pstr=strcat(pstr,' end:',num2str(param.trainSet{i}.segClass(c,2)));
                        strLB=[strLB;pstr];
                    end
                end
            end
        end
        %%%%% validation
        if (length(param.valSet) >=i)
            if ~isempty(param.valSet{i})
                if isfield(param.valSet{i},'perClass')
                    strLB=[strLB; 'validation blocks:'];
                    for c=1:size(param.valSet{i}.perClass,2)
                        pstr=strcat('class',int2str(c),': ',num2str(param.valSet{i}.perClass(c)),'%');
                        strLB=[strLB;pstr];
                    end
                elseif isfield(param.valSet{i},'segClass')
                    strLB=[strLB; 'validation blocks:'];
                    for c=1:size(param.valSet{i}.segClass,1)
                        pstr=strcat('class',int2str(c),': begin:',num2str(param.valSet{i}.segClass(c,1)));
                        pstr=strcat(pstr,' end:',num2str(param.valSet{i}.segClass(c,2)));
                        strLB=[strLB;pstr];
                    end
                end
            end
        end
        %%%% test
        if (length(param.testSet) >=i)
            if ~isempty(param.testSet{i})
                if isfield(param.testSet{i},'perClass')
                    if isfield(param,'classLabel')
                        strLB=[strLB; 'test blocks:'];
                        for c=1:size(param.testSet{i}.perClass,2)
                            pstr=strcat('class',int2str(c),': ',num2str(param.testSet{i}.perClass(c)),'%');
                            strLB=[strLB;pstr];
                        end
                    else                        
                        if ~isempty(param.testSet{i}.perClass)
                            pstr=['test block (all classes): ',num2str(param.testSet{i}.perClass(1)),'%'];
                            strLB=[strLB;pstr];
                        else 
                            strLB=[strLB; 'test block:'];
                        end
                        
                    end
                elseif isfield(param.testSet{i},'segClass')
                    if isfield(param,'classLabel')
                        strLB=[strLB; 'test blocks:'];
                        for c=1:size(param.testSet{i}.segClass,1)
                            pstr=strcat('class',int2str(c),': begin:',num2str(param.testSet{i}.segClass(c,1)));
                            pstr=strcat(pstr,' end:',num2str(param.testSet{i}.segClass(c,2)));
                            strLB=[strLB;pstr];
                        end
                    else
                        if ~isempty(param.testSet{i}.segClass)
                            pstr=['test block (all classes): begin:',num2str(param.testSet{i}.segClass(1,1))];
                            pstr=strcat(pstr,' end:',num2str(param.testSet{i}.segClass(1,2)));
                            strLB=[strLB;pstr];
                        else 
                           strLB=[strLB; 'test block:']; 
                        end                        
                    end
                end
            end
        end
    end
    %set(handles.listB,'String',strLB)
end

if ~isfield(handles,'listboxSum')
    handles.listboxSum=uicontrol('Parent',handles.figure1,'Style','listbox', ... 
        'Fontweight','bold','Units','normalized', ... 
        'Position',[0.69 0.01 0.31 0.99], ...
        'Selected','off','SelectionHighlight','off');
end 
set(handles.listboxSum,'Value',1);
set(handles.listboxSum,'String',strLB)
set(handles.listboxSum,'Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function paramGenSet = def_class(paramGenSet,newLabels)


numLab=length(newLabels); 

dlg_title = 'Define classes';
num_lines = 1;

labelsSetSwitch=true;
while labelsSetSwitch
    %if paramGenSet.numClass == numLab
        def={};prompt={};
    %else
     %   prompt={'Class labels present (don''t edit)'};
        pStr=[];
        for c=1:numLab
            pStr=[pStr,' ',num2str(newLabels(c))];
        end
     %   def={pStr};
     % end
    for c=1:paramGenSet.numClass
        if paramGenSet.numClass == numLab
            def    = [def,num2str(newLabels(c))];
        else
            def    = [def,' '];
        end
        if paramGenSet.numClass == numLab
            strP   = ['Enter labels class ',num2str(c),' (separate by space or commna):'];
        else
            strP   = ['Enter labels class ',num2str(c),' (separate by space or commna): \n','Available class labels: ',pStr];
        end
        prompt = [prompt, sprintf(strP)];
    end
    
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer = inputdlg(prompt,dlg_title,num_lines,def,options);
    if isempty(answer)
        hC=questdlg('No labels selected. Use them?', ...
            'Use labels? ','yes','no','yes');
        switch hC
            case 'no'
                labelsSetSwitch=false;
        end
    else
%         if paramGenSet.numClass ~= numLab
%             answer=answer(2:end);
%         end 
        indC=1; 
        paramGenSet.classLabelAll=[]; 
        for c=1:length(answer)
            if ~isempty(str2num(answer{c}))
                paramGenSet.classN{indC}=str2num(answer{c});
                paramGenSet.classLabelAll=[paramGenSet.classLabelAll,paramGenSet.classN{indC}]; 
                indC=indC+1;     
            end 
            paramGenSet.numClass=indC-1; 
        end 
        labelsSetSwitch=false;
    end
end

%     paramGenSet.class1= str2num(answer{2});
%     paramGenSet.class2= str2num(answer{3});
%     paramGenSet.classLabelAll=[paramGenSet.class1, paramGenSet.class2];

% strIn=strcat(strIn,'}');
% labelsSetSwitch=true;
% while labelsSetSwitch
%     output = inputdlg(eval(strIn),'Define class lables',ones(numLab,1),valTab,'on');
%     if ~(isempty(output) || (sum(cellfun(@(x) isempty(x),output))==length(output)))
%         indClass=1;
%         for i=1:length(output)
%             if ~isempty(output{i})
%                 paramGenSet.classLabelAll(indClass + newClass)=str2double(output{i});
%                 indClass=indClass + 1;
%             end
%         end
%         labelsSetSwitch=false;
%     else
%         hC=questdlg('No labels selected .... use them ?', ...
%             'Use labels? ','yes','no','yes');
%         switch hC
%             case 'no'
%                 labelsSetSwitch=false;
%         end
%     end
% end
% if isfield(paramGenSet,'classLabel')
%     paramGenSet.numClass=length(paramGenSet.classLabelAll);
% end
% 
% if exist('hD','var')
%     close(hD)
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function paramGenSet = add_class(paramGenSet,newLabels)

numLab=length(newLabels); 
existClass = length(paramGenSet.classN);

dlg_title = 'Add new labels or classes';
num_lines = 1;

%allLabels=[paramGenSet.classLabelAll newLabels];  

labelsSetSwitch=true;
while labelsSetSwitch
    prompt={}; 
    %prompt={'New class labels present (don''t edit)'};
    pStrN=[];
    for c=1:numLab
        pStrN=[pStrN,' ',num2str(newLabels(c))];
    end
    %def={pStr};
%     for c=1:length(paramGenSet.classN)
%         pStr=[];
%         for kk=1:length(paramGenSet.classN{c})
%             pStr    = [pStr,num2str(paramGenSet.classN{c}(kk)),' '];
%         end
%         def{c}    = pStr(1:end-1);
%     end
    for c=1:numLab
        def{c} = num2str(newLabels(c));
    end    
    for c=1:numLab % +length(paramGenSet.classN)
        strP   = ['Enter labels class ',num2str(c+existClass),' (separate by space or commna):']; %  \n','Available new class labels: ', pStrN];
        prompt = [prompt, sprintf(strP)];
    end
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer = inputdlg(prompt,dlg_title,num_lines,def,options);
    if isempty(answer)
        hC=questdlg('No labels selected. Use them?', ...
            'Use labels? ','yes','no','yes');
        switch hC
            case 'no'
                labelsSetSwitch=false;
        end
    else
%         if paramGenSet.numClass ~= numLab
%             answer=answer(2:end);
%         end
        indC=1;
        %paramGenSet.classLabelAll=[];
        for c=1:length(answer)
            if ~isempty(str2num(answer{c}))
                paramGenSet.classN{indC+existClass}=str2num(answer{c});
                paramGenSet.classLabelAll=[paramGenSet.classLabelAll,paramGenSet.classN{indC+existClass}];
                indC=indC+1;
            end
            paramGenSet.numClass=length(paramGenSet.classN);
            switch paramGenSet.numClass
                case 1
                    paramGenSet.classLabel=[1];
                case 2
                    paramGenSet.classLabel=[-1 1];
                otherwise
                    paramGenSet.classLabel=[1:paramGenSet.classLabel];
            end
        end
        labelsSetSwitch=false;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [indC, strIn] = fcn1(param)
if isfield(param,'classLabel')
    if unique(param.classLabel) < length(param.classLabel)
        %%%% here more than one class with the same label!!!! 
        indC = 1:param.numClass;
    else
        [sI,pI]=intersect(param.classLabelAll,param.fileHeader{param.fileIndx}.classLabel);
        if ~isempty(sI)
            indC=sort(pI);
        end
    end
else
    indC= 1:param.numClass;
end
strIn='{';
for i=1:length(indC)
    strIn=strcat(strIn,'''Class ',int2str(indC(i)),''',');
end
strIn(end)='}';


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'listboxSum')
    set(handles.listboxSum,'Position',[0.69 0.01 0.31 0.99]); 
   %  handles = printParameters(paramGenFeatures,handles,true) ; 
end
% if strcmp(get(handles.panelSeg,'Visible'),'on')
%     pozT2  = get(handles.panelTop2,'Position');
%     pozST  = get(handles.segTrain,'Position');  
%     pozD   = get(handles.fileDone,'Position'); 
%     pozLeft = (pozST(1)+pozST(3)+ 1);
%     set(handles.panelSeg,'Position',[pozLeft, pozD(2),  (pozT2(3)*0.9 - pozLeft), (pozT2(2)-pozD(2))]); 
%     
%    %  handles = printParameters(paramGenFeatures,handles,true) ; 
% end
guidata(hObject,handles)
