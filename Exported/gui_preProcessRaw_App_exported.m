classdef gui_preProcessRaw_App_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1              matlab.ui.Figure
        GridLayout           matlab.ui.container.GridLayout
        pushDone             matlab.ui.control.Button
        pushGenSet           matlab.ui.control.Button
        repFile              matlab.ui.control.Button
        pushGoBack           matlab.ui.control.Button
        pushFinish           matlab.ui.control.Button
        corrValues           matlab.ui.control.Button
        pushSaveParam        matlab.ui.control.Button
        ListBox              matlab.ui.control.ListBox
        Panel                matlab.ui.container.Panel
        pushOK2              matlab.ui.control.StateButton
        ApplyButton          matlab.ui.control.Button
        minBOverlap          matlab.ui.control.CheckBox
        checkCompY           matlab.ui.control.CheckBox
        checkRef             matlab.ui.control.CheckBox
        checkSelL            matlab.ui.control.CheckBox
        textNotch            matlab.ui.control.Label
        editNotch            matlab.ui.control.EditField
        newSF                matlab.ui.control.EditField
        textRes              matlab.ui.control.Label
        checkNotchFilt       matlab.ui.control.CheckBox
        checkFilt            matlab.ui.control.CheckBox
        checkRes             matlab.ui.control.CheckBox
        secBOverlap          matlab.ui.control.CheckBox
        msecBOverlap         matlab.ui.control.CheckBox
        lenOverlap           matlab.ui.control.EditField
        textOverlap          matlab.ui.control.Label
        minB                 matlab.ui.control.CheckBox
        secB                 matlab.ui.control.CheckBox
        msecB                matlab.ui.control.CheckBox
        samplB               matlab.ui.control.CheckBox
        lenEpoch             matlab.ui.control.EditField
        textEpoch            matlab.ui.control.Label
        checkboxJoinSeg      matlab.ui.control.CheckBox
        textJoinSeg          matlab.ui.control.Label
        pushFinishSelection  matlab.ui.control.Button
        fileTextR            matlab.ui.control.Label
        corrFile             matlab.ui.control.Button
        delFile              matlab.ui.control.Button
        fileText             matlab.ui.control.Label
        loadParam            matlab.ui.control.Button
        loadFile             matlab.ui.control.Button
        Image                matlab.ui.control.Image
        topPanel             matlab.ui.container.Panel
    end

    
    %Ahoj svet 
    properties (Access = private)
        paramPreProcess
        %#%listboxSum
        fileName
        pathName
        fileName2
        pathName2
        fileName3
        pathName3
        fileName4
        pathName4
        vektor
        vektor2
        listNum
    end
    
    methods (Access = private)
        function outC = checkCorrOver(app, lenO, unitV, param)
            
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
        end
        
        function app = handles_set2(app, param, iE)
            
            %##%set(handles.lenOverlap,'Visible','off','String',[]);
            %##%set(handles.samplB,'Visible','off','Enable','on');
            %##%set(handles.msecB,'Visible','off');
            %##%set(handles.secB,'Visible','off');
            %##%set(handles.minB,'Visible','off');
            %##%set(handles.textEpoch,'Visible','off');
            
            
            
            %set(handles.checkRes,'Visible','on');
            %set(handles.checkFilt,'Visible','on');
            %##%set(handles.checkNotchFilt,'Visible','on');
            %##%set(handles.pushOK1,'Visible','on');
            
            %%%% right text
            if isfield(param.fileHeader{iE},'sampleFreq')
                if isfield(param.fileHeader{iE},'new_sampleFreq')
                    nstr=['New sampling frequency: ',num2str(param.fileHeader{iE}.new_sampleFreq), ...
                        ' [',param.fileHeader{iE}.sampleFreqUnit,']'];
                    strRFT(1)={nstr};
                    %##%set(handles.checkRes,'Visible','on','Value',1);
                    app.checkRes.Value=1;
                else
                    strRFT(1)={'Re-sampling: no'};
                    %##%set(handles.checkRes,'Visible','on','Value',0);
                    app.checkRes.Value=0;
                end
                %if isfield(paramPreProcess.fileHeader{listNum},'decimationFactor')
                %    paramPreProcess.fileHeader{listNum}=rmfield(paramPreProcess.fileHeader{listNum},'decimationFactor');
                %end
            else
                if isfield(param.fileHeader{iE},'decimationFactor')
                    param.fileHeader{iE}.decimationFactor = nsf;
                    nstr=['Decimation factor: ',num2str(param.fileHeader{iE}.decimationFactor)];
                    strRFT(1)={nstr};
                    %##%set(handles.checkRes,'Visible','on','Value',1);
                    app.checkRes.Value=1;
                else
                    strRFT(1)={'Decimation: no'};
                    %##%set(handles.checkRes,'Visible','on','Value',0);
                    app.checkRes.Value=0;
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
                %##%set(handles.checkFilt,'Visible','on','Value',1);
                    app.checkFilt.Value=1;
            else
                strRFT(3)={'Filtering: no'};
                %##%set(handles.checkFilt,'Visible','on','Value',0);
                app.checkFilt.Value=0;
            end
            strRFT(4)={'--------------------------------'};
            if isfield(param.fileHeader{iE},'notchFilter')
                nstr=['Notch Filter: ',num2str(param.fileHeader{iE}.notchFilter),' [Hz]'];
                strRFT(5)={nstr};
                %##%set(handles.checkNotchFilt,'Visible','on','Value',1);
                app.checkFilt.Value=1;
            else
                strRFT(5)={'Notch Filter: no'};
                %##%set(handles.checkFilt,'Visible','on','Value',0);
                app.checkFilt.Value=0;
            end
            strRFT(6)={'--------------------------------'};
            
            %##%set(handles.fileTextR,'Visible','on','String',strRFT);
            app.fileTextR.Text=strRFT;
        end
        
        function app = printParameters(app,param)
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %disp(param);
            if param.fileIndx > 0
                if isfield(param,'paramSaveFile')
                    strLB={['Parameters Summary (save to: ',param.paramSaveFile,'):']};
                else
                    strLB={'Parameters Summary (save to: ???):'};
                end
                for i=1:param.fileIndx
                    pStr=strcat(int2str(i),')');
                    %#%strLB=[strLB;pStr;param.app.fileName{i}];
                    %#%strLB=[strLB;pStr;param.app.fileName{i}];
                    strLB=[strLB;pStr;param.fileName{i}];

                    if isfield(param.fileHeader{i},'sampleFreq')
                        pStr=['sampling freq: ',int2str(param.fileHeader{i}.sampleFreq), ...
                            ' [',param.fileHeader{i}.sampleFreqUnit,']'];
                        strLB=[strLB;pStr];
                    end
                    if param.fileHeader{i}.joinSeg
                        pStr='join disc. seg.: true';
                    else
                        pStr='join disc. seg.: false';
                    end
                    strLB=[strLB;pStr];
                    pStr=['epoch length: ',num2str(param.fileHeader{i}.lenEpoch), ...
                        ' [',param.fileHeader{i}.lenEpochUnit,']'];
                    strLB=[strLB;pStr];
                    pStr=['overlap: ',num2str(param.fileHeader{i}.lenOverlap), ...
                        ' [',param.fileHeader{i}.lenOverlapUnit,']'];
                    strLB=[strLB;pStr];
                    if isfield(param.fileHeader{i},'new_sampleFreq')
                        pStr=['new sampling freq: ',int2str(param.fileHeader{i}.new_sampleFreq), ...
                            ' [',param.fileHeader{i}.sampleFreqUnit,']'];
                        strLB=[strLB;pStr];
                    elseif isfield(param.fileHeader{i},'decimationFactor')
                        pStr=['decimation factor: ',int2str(param.fileHeader{i}.decimationFactor)];
                        strLB=[strLB;pStr];
                    end
                    if isfield(param.fileHeader{i},'filterFile')
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
                    if isfield(param.fileHeader{i},'notchFilter')
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
                    if isfield(param.fileHeader{i},'eventsProcessFile')
                        pStr=['processing events: yes (',param.fileHeader{i}.eventsPathName,param.fileHeader{i}.eventsProcessFile,')'];
                        strLB=[strLB;pStr];
                    else
                        pStr=strcat('processing events: no');
                        strLB=[strLB;pStr];
                    end
                    %%% re-referncing type
                    if isfield(param.fileHeader{i},'refType')
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

            %#%if isempty(app.listboxSum) || ~isvalid(app.listboxSum)
            % Vytvorenie listboxu dynamicky, ak neexistuje
               %#% app.listboxSum = uilistbox(app.figure1,'Position', [1, 1, 200, 400]);
            %#%end

 

            
            % Nastavenie vlastností listboxu
            if ~isempty(strLB) % Skontroluje, či zoznam nie je prázdny
                %#%app.listboxSum.Items = strLB; % Priradenie položiek do ListBoxu
                app.ListBox.Items = strLB;
                %#%app.listboxSum.Value = strLB{1}; % Nastavenie prvého prvku ako vybraného
                app.ListBox.Value = strLB{1};
            else
                %#%app.listboxSum.Items = {}; % Ak je prázdny, nastavíme prázdny zoznam
                app.ListBox.Items= {};
                %#%app.listboxSum.Value = {}; % Žiadna predvolená hodnota
                app.ListBox.Value = {};
            end

            %#%app.listboxSum.Visible = 'on';
            app.ListBox.Visible = "on";
            %if ~isfield(handles,'listboxSum')
             %   handles.listboxSum=uicontrol('Parent',handles.figure1,'Style','listbox', ...
              %      'Units','normalized', ...
               %     'Position',[0.65 0.01 0.4 0.98], ...
                %    'Selected','off','SelectionHighlight','off');
            %end
            %set(handles.listboxSum,'Value',1);
            %set(handles.listboxSum,'String',strLB)
            %set(handles.listboxSum,'Visible','on');
        end
        
        % Update components that require runtime configuration
        function addRuntimeConfigurations(app)
            
            % Load data for component configuration
            componentData = load('gui_preProcessRaw_App.mat');
            
            % Set component properties that require runtime configuration
            app.pushSaveParam.UserData = componentData.pushSaveParam.UserData;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function gui_preProcessRaw_OpeningFcn(app, varargin)
            % --- Executes just before gui_preProcessRaw is made visible.
            
            % Add runtime required configuration - Added by Migration Tool
            %addRuntimeConfigurations(app);
            
            % Ensure that the app appears on screen when run
            %movegui(app.figure1, 'onscreen');
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
            % This function has no output args, see OutputFcn.
            % hObject    handle to figure
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % varargin   command line arguments to gui_preProcessRaw (see VARARGIN)
            
            %clear global
            %global paramPreProcess
            app.Panel.Visible="off";
            
            %set(0,'Units','normalized');
            %set(handles.figure1,'Position',[0.2 0.2 0.65 0.6]);
            
            %set(handles.figure1,'Position',[0.2 0.2 0.4 0.3]);
            
            % Choose default command line output for gui_preProcessRaw
            %handles.output = hObject;
            
            % Update handles structure
            %guidata(hObject, handles);
        end

        % Value changed function: checkCompY
        function checkCompY_Callback(app, event)
            % --- Executes on button press in checkCompY.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkCompY (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
               %##%iE=get(handles.corrFile,'UserData');
            %##%else
                %##%iE=paramPreProcess.fileIndx;
            %##%end

            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            %##%if get(handles.checkCompY,'Value')
            if app.checkCompY.Value==true 
                %##%set(handles.checkCompY,'Enable','off');
                %##%set(handles.checkSelL,'Enable','off');
                %##%set(handles.checkRef,'Enable','off');
                %##%set(handles.pushOK2,'Enable','off');
                app.checkCompY.Enable = 'off';
                %#%app.checkSelL.Enable = 'off';
                %#%app.checkRef.Enable = 'off';
                %#%app.pushOK2.Enable = 'off';
            
                [app.fileName4, app.pathName4] = uigetfile ({'./Customized-M-files/*.m'},'Open a Events Processing File');
                app.pathName4=getRelPath(app.pathName4);

            
                if app.fileName4
                    %%% load parameters
                    strF=strcat(app.pathName4,app.fileName4);
                    %%%% define filter file, this also means filtering data .....
                    app.paramPreProcess.fileHeader{iE}.eventsPathName=app.pathName4;
                    app.paramPreProcess.fileHeader{iE}.eventsProcessFile=app.fileName4;
                    %paramPreProcess.fileHeader{iE}.eventsProcessFile=fileName;
                    
                    nstr=['Processing events: yes (', app.fileName,')'];
                    app.vektor2={nstr};
                    %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                    %##%app.fileTextR.Visible = 'on';
                    
                    %###%set(handles.checkCompY,'Enable','on','Value',1);
                    %##%set(handles.checkSelL,'Enable','on');
                    %##%set(handles.pushOK2,'Enable','on');
                    %##%set(handles.checkRef,'Enable','on');                
                    app.checkCompY.Enable = 'on';
                    app.checkCompY.Value = 1;
                    %#%app.checkSelL.Enable = 'on';
                    %#%app.checkRef.Enable = 'on';
                    %#%app.pushOK2.Enable = 'on';

                else
                    %###%set(handles.checkCompY,'Enable','on','Value',0);
                    %###%set(handles.checkSelL,'Enable','on');
                    %###%set(handles.pushOK2,'Enable','on');
                    %###%set(handles.checkRef,'Enable','on');
                    app.checkCompY.Enable = 'on';
                    app.checkCompY.Value = 0;
                    %#%app.checkSelL.Enable = 'on';
                    %#%app.checkRef.Enable = 'on';
                    %#%app.pushOK2.Enable = 'on';
                end
            else
                app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'eventsProcessFile');
                app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'eventsPathName');
                %#%strRFT = get(handles.fileTextR,'String');
                app.vektor2={'Processing events: no'};
                %###%set(handles.fileTextR,'Visible','on','String',strRFT);
                %#%app.fileTextR.Visible = 'on';
                %#%app.fileTextR.Text = strRFT;

            end
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: checkFilt
        function checkFilt_Callback(app, event)
            % --- Executes on button press in checkFilt.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkFilt (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %#%if get(handles.corrFile,'UserData')
               %#%iE=get(handles.corrFile,'UserData');
            %#%else
                %#%iE=app.paramPreProcess.fileIndx;
           %#% end
           if app.checkFilt.Value
           app.checkFilt.Enable="off";
           [app.fileName2, app.pathName2] = uigetfile ({'./Filters/*.mat'},'Open a Filter File');
           app.pathName2=getRelPath(app.pathName2);
           end
            
            
            app.checkFilt.Enable="on";
            %##%guidata(hObject,handles)
        end

        % Value changed function: checkNotchFilt
        function checkNotchFilt_Callback(app, event)
            % --- Executes on button press in checkNotchFilt.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkNotchFilt (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %#%if get(handles.corrFile,'UserData')
              %#% iE=get(handles.corrFile,'UserData');
            %#%else
              %#%  iE=app.paramPreProcess.fileIndx;
            %#%end

             if app.checkNotchFilt.Value==true
                %##%set(handles.checkNotchFilt,'Enable','off'); % ,'Value',0);
                app.checkNotchFilt.Enable="off";
                 %##%set(handles.checkFilt,'Enable','off');
                %##%set(handles.checkRes,'Enable','off');
                %##%set(handles.pushOK1,'Enable','off');
            
                %##%set(handles.textNotch,'Visible','on');
                %##%set(handles.editNotch,'Visible','on');
                app.textNotch.Visible="on";
                app.editNotch.Visible="on";
             else
                 %##%set(handles.textNotch,'Visible','off');
                %##%set(handles.editNotch,'Visible','off','String',[]);
                app.textNotch.Visible="off";
                app.editNotch.Visible="off";
                app.editNotch.Value='';

            end
            
            
        end

        % Value changed function: checkRef
        function checkRef_Callback(app, event)
            % --- Executes on button press in checkRef.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkRef (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
                %##%iE=get(handles.corrFile,'UserData');
            %##%else
                %##%iE=paramPreProcess.fileIndx;
            %##%end

            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            
            
            %##%if get(handles.checkRef,'Value')
            if app.checkRef.Value
                %##%set(handles.pushOK2,'Enable','off');
                %##%set(handles.checkCompY,'Enable','off');
                %##%set(handles.checkSelL,'Enable','off');
                %##%set(handles.checkRef,'Enable','off');
                app.checkRef.Enable="off";
                str={'Average Reference','Average Reference & GF','A1A2-2' ...
                    'Laplacian-Sph','Laplacian-Geo'};
                [sPos,iOK] = listdlg('PromptString','Select a type of re-referencing:',...
                    'SelectionMode','single','ListString',str);
                if iOK
                    app.paramPreProcess.fileHeader{iE}.refType= str{sPos};
                    if regexpi(str{sPos},'Laplacian')
                        [app.fileName3, app.pathName3] = uigetfile ({'./M-files/ssltool/data/*.mat'},'Load Head Model for Laplacian');
                        app.pathName3=getRelPath(app.pathName3);
                        if app.fileName3
                            app.vektor=['Re-referencing: ',app.paramPreProcess.fileHeader{iE}.refType,' (',app.fileName3,')'];
                            app.paramPreProcess.fileHeader{iE}.refType= str{sPos};
                            app.paramPreProcess.fileHeader{iE}.fnHeadModel = [app.pathName3,app.fileName3];
                        else
                            %##%set(handles.checkRef,'Value',0)
                            app.checkRef.Value=0;
                            app.paramPreProcess.fileHeader{iE}.refType = 'none';
                            app.vektor='Re-referencing: no';
                        end
                    else
                        app.vektor=['Re-referencing: ',app.paramPreProcess.fileHeader{iE}.refType];
                    end
                else
                    set(handles.checkRef,'Value',0)
                    app.checkRef.Value=0;
                    app.paramPreProcess.fileHeader{iE}.refType = 'none';
                    app.vektor='Re-referencing: no';
                end
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                
                %##%set(handles.pushOK2,'Enable','on');
                %##%set(handles.checkCompY,'Enable','on');
                %##%set(handles.checkSelL,'Enable','on');
                %##%set(handles.checkRef,'Enable','on');
                app.checkRef.Enable="on";
            else
                app.paramPreProcess.fileHeader{iE}.refType= 'none';
                if isfield(app.paramPreProcess.fileHeader{iE},'fnHeadModel')
                    app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'fnHeadModel');
                end
                app.vektor='Re-referencing: no';
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
            end
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: checkRes
        function checkRes_Callback(app, event)
            % --- Executes on button press in checkRes.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkRes (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
                %##%iE=get(handles.corrFile,'UserData');
            %##%else
                %##%iE=paramPreProcess.fileIndx;
            %##%end

             if ~isempty(app.corrFile.UserData) % Skontroluje, či UserData nie je prázdne
                iE = app.corrFile.UserData; % Získa hodnotu z UserData
            else
                iE = app.paramPreProcess.fileIndx; % Použije predvolený index
            end
            if app.checkRes.Value==true
                %##%set(handles.checkRes,'Enable','off');
                app.checkRes.Enable="off";
                %##%set(handles.checkFilt,'Enable','off');
                %##%set(handles.checkNotchFilt,'Enable','off');
                %##%set(handles.pushOK1,'Enable','off');
            
                %##%set(handles.textRes,'Visible','on');
                %##%set(handles.newSF,'Visible','on');
                app.textRes.Visible="on";
                app.newSF.Visible="on";
                %disp(app.corrFile.UserData);
            else
                %##%strRFT = get(handles.fileTextR,'String');
                app.newSF.Visible="off";
                app.newSF.Value='';
                app.textRes.Visible="off";
                
                
            
            end
           
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: checkSelL
        function checkSelL_Callback(app, event)
            % --- Executes on button press in checkSelL.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to checkSelL (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
           

            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            %if get(handles.checkSelL,'Value')
                %##%set(handles.checkSelL,'Enable','off','Visible','off');
                %#%set(handles.pushOK2,'Enable','off');
                %##%set(handles.checkCompY,'Enable','off');
                %##%set(handles.checkRef,'Enable','off');

                app.checkSelL.Enable="off";
            
            
                param.Xlabels = app.paramPreProcess.fileHeader{iE}.Xlabels;
                if isfield(app.paramPreProcess.fileHeader{iE},'Xlabels2use')
                    param.Xlabels2use = app.paramPreProcess.fileHeader{iE}.Xlabels2use;
                end
            
                save('tmpSelElect','param');
                hS = plotSelElect_App; 
                uiwait(hS.figure1)
                load('tmpSelElect','param');
                delete('tmpSelElect.mat')
                if isfield(param,'Xlabels2use')
                    app.paramPreProcess.fileHeader{iE}.Xlabels2use = param.Xlabels2use;
                end
                clear param
            
                if isfield(app.paramPreProcess.fileHeader{iE},'Xlabels2use')
                    if length(app.paramPreProcess.fileHeader{iE}.Xlabels2use) == length(app.paramPreProcess.fileHeader{iE}.Xlabels)
                       %##% strRFT = get(handles.fileTextR,'String');
                       %#%strRFT= app.fileTextR.Text;
                       %#% strRFT=[strRFT,{'Variables to use: all'}];
                       %#% strRFT=[strRFT,{' '}];
                        %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
                        app.checkSelL.Enable="on";
                        app.checkSelL.Visible="on";
                        app.checkSelL.Value=0;
                    else
                        %##%strRFT = get(handles.fileTextR,'String');
                        %#%strRFT=app.fileTextR.Text;
                        %#%strRFT=[strRFT,{'Variables to use: '}];
                        %#%pStr = [];
                        %ppStr=paramPreProcess.fileHeader{iE}.Xlabels
                        %#%for sI=1:length(app.paramPreProcess.fileHeader{iE}.Xlabels2use)
                           %#% pStr=[pStr,regexprep(app.paramPreProcess.fileHeader{iE}.Xlabels2use{sI},'[^\w'']',''),','];
                        %#%end
                        %#%pStr=pStr(1:end-1);
                        %#%strRFT=[strRFT,{pStr}];
                        %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',1);
                        app.checkSelL.Enable="on";
                        app.checkSelL.Visible="on";
                        app.checkSelL.Value=1;
                    end
                else
                    %##%strRFT = get(handles.fileTextR,'String');
                    %##%strRFT(7)={'Variables to use: all'};
                    %##%strRFT(8)={' '};
                    %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
                    %#%strRFT = app.fileTextR.Text;
                    %#%strRFT=[strRFT,{'Variables to use: all'}];
                    %#%strRFT=[strRFT,{' '}];
                    app.checkSelL.Enable="on";
                    app.checkSelL.Visible="on";
                    app.checkSelL.Value=0;
                    
                end
            
               %##%set(handles.fileTextR,'Visible','on','String',strRFT);
               
               %set(handles.checkSelL,'Enable','off','Visible','on');
               %##%set(handles.pushOK2,'Enable','on');
               %##%set(handles.checkCompY,'Enable','on');
               %##%set(handles.checkRef,'Enable','on');
            % else
            %     strRFT = get(handles.fileTextR,'String');
            %     strRFT(5)={'Used variables: all'};
            %     strRFT(7)={' '};
            %     set(handles.fileTextR,'Visible','on','String',strRFT);
            % end
            
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: corrFile
        function corrFile_Callback(app, event)
            % --- Executes on button press in corrFile.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to corrFile (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%set(handles.loadFile,'Visible','off');
            %##%set(handles.delFile,'Visible','off');
            %##%set(handles.corrFile,'Visible','off');
            %##%set(handles.repFile,'Visible','off');
            %##%set(handles.pushFinishSelection,'Visible','off');
            %set(handles.pushFinish,'Visible','off');
            app.loadFile.Visible="off";
            app.delFile.Visible="off";
            app.corrFile.Visible="off";
            app.repFile.Visible="off";
            app.pushFinishSelection.Visible="off";
            
            
            [app.listNum, ok_click] = listdlg('PromptString','Select a file to correct', ...
                'SelectionMode','single', 'ListString',app.paramPreProcess.fileName, ...
                'Name', 'Correct file');
            %#%app.fileName=app.paramPreProcess.fileName{listNum};
            %#%disp(listNum)
            if ok_click
                %##%set(handles.corrFile,'UserData',listNum); %%% correction true
                %##%set(handles.loadFile,'Visible','off')
                %##%set(handles.loadParam,'Visible','off');
                %##%set(handles.lenEpoch,'Visible','on','String',[]);
                %##%set(handles.topPanel,'Visible','on');
                %##%set(handles.textEpoch,'Visible','on','String','Define epoch''s length');
                app.corrFile.UserData=app.listNum;
                app.loadFile.Visible="off";
                app.loadParam.Visible="off";
                app.Panel.Visible="on";
                app.lenEpoch.Visible="on";
                %#%app.lenEpoch.Value='';
                app.lenOverlap.Visible="on";
                app.textOverlap.Visible="on";
                app.topPanel.Visible="on";
                app.textEpoch.Visible="on";
                %#%app.textEpoch.Text="Define epoch''s length";

                   strFT=[{app.paramPreProcess.fileName{app.listNum}}; {'--------------------------------'}];
                if isfield(app.paramPreProcess.fileHeader{app.listNum},'sampleFreq')
                   str=['Sampling frequency: ',num2str(app.paramPreProcess.fileHeader{app.listNum}.sampleFreq)];
                   strFT=[strFT; {str}];
                   strFT=[strFT; {'--------------------------------'}];
                end
                app.fileText.Text = strjoin(strFT, newline);  
               
                %##%set(handles.fileText,'String',strFT,'Visible','on');
                %##%set(handles.samplB,'Visible','on','Value',0);
                %##%set(handles.msecB,'Visible','on','Value',0);
                %##%set(handles.secB,'Visible','on','Value',0);
                %##%set(handles.minB,'Visible','on','Value',0);
                %##%set(handles.textJoinSeg,'Visible','on');
                %##%set(handles.checkboxJoinSeg,'Visible','on','Value',0);

                app.Panel.Visible="on";
                app.Panel.Enable="on";
                %#%app.fileText.Text = strjoin(strFT, newline);  
                app.fileText.Visible = 'on'; 
                app.samplB.Visible="on";
                %#%app.samplB.Value=0;
                app.msecB.Visible="on";
                %#%app.msecB.Value=0;
                app.secB.Visible="on";
                %#%app.secB.Value=0;
                app.minB.Visible="on";
                %#%app.minB.Value=0;
                app.textJoinSeg.Visible="on";
                app.checkboxJoinSeg.Visible="on";
                %#%app.checkboxJoinSeg.Value=0;
                app.msecBOverlap.Visible="on";
       
                      app.secBOverlap.Visible="on";
                      app.minBOverlap.Visible="on";
                      app.checkNotchFilt.Visible="on";
                      app.checkRes.Visible="on";
                      app.checkFilt.Visible="on";
                      app.fileTextR.Visible="on";
                      app.checkSelL.Visible="on";
                      app.checkRef.Visible="on";
                      app.checkCompY.Visible="on";
                      app.ApplyButton.Visible="on";
                      app.fileTextR.Visible="on";
                      app.pushOK2.Visible="off";
                

            
                %%%% remove values
                app.paramPreProcess.fileHeader{app.listNum}=rmfield(app.paramPreProcess.fileHeader{app.listNum},'lenEpoch');
                app.paramPreProcess.fileHeader{app.listNum}=rmfield(app.paramPreProcess.fileHeader{app.listNum},'lenEpochUnit');
                app.paramPreProcess.fileHeader{app.listNum}=rmfield(app.paramPreProcess.fileHeader{app.listNum},'lenOverlap');
                app.paramPreProcess.fileHeader{app.listNum}=rmfield(app.paramPreProcess.fileHeader{app.listNum},'lenOverlapUnit');
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
                %app.ListBox.Visible="off";
            else
                %##%set(handles.loadFile,'Visible','on');
                %##%set(handles.delFile,'Visible','on');
                %##%set(handles.corrFile,'Visible','on');
                %##%set(handles.repFile,'Visible','on');
                %##%set(handles.pushFinishSelection,'Visible','on');

                app.loadFile.Visible="on";
                app.delFile.Visible="on";
                app.corrFile.Visible="on";
                app.repFile.Visible="on";
                app.pushFinishSelection.Visible="on";
                
            
            end
            %##%guidata(hObject,handles)
        end

        % Button pushed function: corrValues
        function corrValues_Callback(app, event)
            % --- Executes on button press in corrValues.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to corrValues (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
               %##%iE=get(handles.corrFile,'UserData');
            %##%else
                %##%iE=paramPreProcess.fileIndx;
            %##%end
            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            %%%%% remove  old values
            app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'lenEpoch');
            app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'lenEpochUnit');
            app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'lenOverlap');
            app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'lenOverlapUnit');
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
            
            %#%strFT =[{app.paramPreProcess.app.fileName{iE}}; {'--------------------------------'}];
            %strRFT=[{};{}];
            %#%if isfield(app.paramPreProcess.fileHeader{iE},'sampleFreq')
               %#% str=['Sampling frequency: ',num2str(app.paramPreProcess.fileHeader{iE}.sampleFreq), ...
                  %#% ' [',app.paramPreProcess.fileHeader{iE}.sampleFreqUnit,']'];
                %#%strFT=[strFT; {str}];
                %#%strFT=[strFT; {'--------------------------------'}];
            %#%end
            
            %##%set(handles.fileText,'String',strFT,'Visible','on');
            %##%set(handles.fileTextR,'Visible','off','String',[]);
            %##%set(handles.textJoinSeg,'Visible','on');
            %##%set(handles.checkboxJoinSeg,'Visible','on','Value',0);
            app.fileText.Visible="on";      
            %#%app.fileText.Text=strFT;
            app.lenEpoch.Visible="on";
            %#%app.lenEpoch.Value='';
            app.topPanel.Visible="on";
            app.textEpoch.Visible="on";
            app.textJoinSeg.Visible="on";
            app.checkboxJoinSeg.Visible="on";
            %#%app.checkboxJoinSeg.Value=false;
            app.lenOverlap.Visible="on";
            %#%app.lenOverlap.Value='';
            app.textOverlap.Visible="on";
            %set(handles.fileTextR,'String',strRFT,'Visible','on');
            if  isfield(app.paramPreProcess.fileHeader{iE},'sampleFreq')
                %##%set(handles.samplB,'Visible','on','Value',0);
                %##%set(handles.msecB,'Visible','on','Value',0);
                %##%set(handles.secB,'Visible','on','Value',0);
                %##%set(handles.minB,'Visible','on','Value',0);
                      app.Panel.Visible="on";
                      app.Panel.Enable="on";
                      app.samplB.Visible="on";
                      %#%app.samplB.Value=false;
                      app.msecB.Visible="on";
                      %#%app.msecB.Value=false;
                      app.secB.Visible="on";
                      %#%app.secB.Value=false;
                      app.minB.Visible="on";
                      %#%app.minB.Value=false;
                      app.msecBOverlap.Visible="on";
                      %#%app.msecBOverlap.Value=false;
                      app.secBOverlap.Visible="on";
                      %#%app.secBOverlap.Value=false;
                      app.minBOverlap.Visible="on";
                      %#%app.minBOverlap.Value=false;
                      app.checkNotchFilt.Visible="on";
                      app.checkRes.Visible="on";
                      app.checkFilt.Visible="on";
                      app.fileTextR.Visible="on";
                      app.checkSelL.Visible="on";
                      app.checkRef.Visible="on";
                      app.checkCompY.Visible="on";
            else
                %##%set(handles.samplB,'Visible','on','Value',0);
                app.samplB.Visible="on";
                app.samplB.Value=0;
            end
            %##%set(handles.lenEpoch,'Visible','on','String',[]);
            %##%set(handles.textEpoch,'Visible','on','String','Define epoch''s length');
            %##%set(handles.corrValues,'Visible','off');
            %##%set(handles.pushDone,'Visible','off');
            app.pushOK2.Visible="off";
            app.corrValues.Visible="off";
            app.pushDone.Visible="off";
            app.pushOK2.Enable="on";
            %##%guidata(hObject,handles)
        end

        % Button pushed function: delFile
        function delFile_Callback(app, event)
            % --- Executes on button press in delFile.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to delFile (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%set(handles.loadFile,'Visible','off');
            %##%set(handles.repFile,'Visible','off');
            %##%set(handles.corrFile,'Visible','off');
            %##%set(handles.delFile,'Visible','off');
            %##%set(handles.pushFinishSelection,'Visible','off');
            %set(handles.pushFinish,'Visible','off');
            app.loadFile.Visible='off';
            app.repFile.Visible='off';
            app.corrFile.Visible='off';
            app.delFile.Visible='off';
            app.pushFinishSelection.Visible = 'off';
            
            
            [listNumAll, ok_click] = listdlg('PromptString','Select a file to correct', ...
                'SelectionMode','multiple', 'ListString',app.paramPreProcess.fileName, ...
                'Name', 'Correct file');
            if ok_click
                if app.paramPreProcess.fileIndx    == 1 %%% the first and the only one
                    app.paramPreProcess.fileIndx    = 0;
                    app.paramPreProcess.fileName    = [];
                    app.paramPreProcess.pathName    = [];
                    app.paramPreProcess=rmfield(app.paramPreProcess,'fileHeader');
                    if ~isempty(findobj('Tag','print param')) %######################################################################################
                        close(findobj('Tag','print param'));
                    end

    
                    %##%if isfield(handles,'listboxSum')
                        %##%set(handles.listboxSum,'Visible','off');
                        %#%app.listboxSum.Visible='off';
                        app.ListBox.Visible='off';
                    %##%end
                    if isprop(app, 'ListBox') % Overí, či `listboxSum` existuje ako vlastnosť aplikácie
                        %#%app.listboxSum.Visible = 'off';
                        app.ListBox.Visible = 'off';
                    end
                    %##%set(handles.loadFile,'Visible','on','Enable','on');
                    %##%set(handles.loadParam,'Visible','on','Enable','on');
                    app.loadFile.Visible = 'on';
                    app.loadFile.Enable = 'on';
                    app.loadParam.Visible = 'on';
                    app.loadParam.Enable = 'on';

                else
                    app.paramPreProcess.fileIndx  = app.paramPreProcess.fileIndx  - length(listNumAll);
                    app.paramPreProcess.fileName(listNumAll) = [];
                    app.paramPreProcess.pathName(listNumAll) = [];
                    app.paramPreProcess.fileHeader(listNumAll) = [];
                    %##%set(handles.loadFile,'Visible','on','Enable','on');
                    app.loadFile.Visible='on';
                    app.loadFile.Enable='on';
                    %##%handles = printParameters(app, paramPreProcess, handles);
                    app = printParameters(app,app.paramPreProcess);
                end
                if app.paramPreProcess.fileIndx > 0
                    %##%set(handles.loadFile,'Visible','on');
                    %##%set(handles.repFile,'Visible','on');
                    %##%set(handles.delFile,'Visible','on');
                    %##%set(handles.corrFile,'Visible','on');
                    %##%set(handles.pushFinishSelection,'Visible','on');
                    app.loadFile.Visible='on';
                    app.repFile.Visible='on';
                    app.delFile.Visible='on';
                    app.corrFile.Visible='on';
                    app.pushFinishSelection.Visible='on';
                end
            else
                %##%set(handles.loadFile,'Visible','on');
                %##%set(handles.repFile,'Visible','on');
                %##%set(handles.delFile,'Visible','on');
                %##%set(handles.corrFile,'Visible','on');
                %##%set(handles.pushFinishSelection,'Visible','on');
                app.loadFile.Visible='on';
                app.repFile.Visible='on';
                app.delFile.Visible='on';
                app.corrFile.Visible='on';
                app.pushFinishSelection.Visible='on';
            end
            %##%guidata(hObject,handles)
        end

        % Value changed function: editNotch
        function editNotch_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to editNotch (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %#%if get(handles.corrFile,'UserData')
              %#% iE=get(handles.corrFile,'UserData');
               % set(handles.corrFile,'UserData',[]);
            %#%else
               %#% iE=app.paramPreProcess.fileIndx;
            %#%end
            
            %##%nsf=str2double(get(handles.editNotch,'String'));
           
            app.checkNotchFilt.Enable="on";
            
            %##%guidata(hObject,handles)
        end

        % Size changed function: figure1
        function figure1_ResizeFcn(app, event)
            % --- Executes when figure1 is resized.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to figure1 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%if isfield(handles,'listboxSum')
                %##%set(handles.listboxSum,'Position',[0.65 0.01 0.4 0.98]);
               %  handles = printParameters(paramGenFeatures,handles,true) ;
            %##%end
            %##%guidata(hObject,handles)

     
            % --- Executes when figure1 is resized.
    
            % Získanie veľkosti figure v pixeloch
            %##%figPos = app.figure1.Position;  % [x, y, width, height]
    
            %##%if isprop(app, 'listboxSum') % Skontrolujeme, či komponenta existuje
                % Nastavenie novej pozície pre listbox v pixeloch
                %##%app.listboxSum.Position = [figPos(3) * 0.65, figPos(4) * 0.01, figPos(3) * 0.4, figPos(4) * 0.98];
            %##%end
        end

        % Value changed function: lenEpoch
        function lenEpoch_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to lenEpoch (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: lenOverlap
        function lenOverlap_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to lenOverlap (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
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
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: loadFile
        function loadFile_Callback(app, event)
            % --- Executes on button press in loadFile.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to loadFile (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            %##%global paramPreProcess
            
            %##%set(handles.corrFile,'Visible','off');
            %##%set(handles.repFile,'Visible','off');
            %##%set(handles.delFile,'Visible','off');
            %##%set(handles.pushFinishSelection,'Visible','off');
            app.corrFile.Visible="off";
            app.repFile.Visible="off";
            app.delFile.Visible="off";
            app.pushFinishSelection.Visible="off";

            %set(handles.pushFinish,'Visible','off');
            
            %##%set(handles.loadFile,'Enable','off');
            %##%set(handles.loadParam,'Enable','off');
            app.loadFile.Enable="off";
            app.loadParam.Enable="off";
            
            [app.fileName, app.pathName] = uigetfile ({'./Data/RawData/*.mat'},'Open File');
            app.pathName=getRelPath(app.pathName);
           
            
            if isfield(app.paramPreProcess,'fileIndx') && sum(strcmp(app.paramPreProcess.fileName,app.fileName)) && sum(strcmp(app.paramPreProcess.pathName,app.pathName))
                hE=errordlg('This file is alrady in .... Error!!','Error - file alrady in');
                uiwait(hE);
                toDo = 3;
            elseif app.fileName
                %%% load header file
                strF=strcat(app.pathName,app.fileName);
                load(strF,'header')
                if ~exist('header','var')
                    hE=errordlg('Header no present in the file ...','Error - header missing');
                    uiwait(hE);
                    toDo = 1;
                else
                    if isfield(app.paramPreProcess,'fileIndx')
                        app.paramPreProcess.fileIndx = app.paramPreProcess.fileIndx + 1;
                    else
                        app.paramPreProcess.fileIndx = 1;
                    end
                    app.paramPreProcess.fileName{app.paramPreProcess.fileIndx} = app.fileName;
                    app.paramPreProcess.pathName{app.paramPreProcess.fileIndx} = app.pathName;
                    app.paramPreProcess.fileHeader{app.paramPreProcess.fileIndx} = header;
                    toDo = 2;
                end
            elseif  isfield(app.paramPreProcess,'fileIndx')
                toDo = 3;
            else
                toDo = 1;
            end
            
            switch toDo
                case 1
                  %##%set(handles.loadFile,'Enable','on')
                  %##%set(handles.loadParam,'Enable','on');
                  app.loadFile.Enable="on";
                  app.loadParam.Enable="on";
                case 2
                  %##%set(handles.loadFile,'Visible','off')
                  %##%set(handles.loadParam,'Visible','off');
                  %##%set(handles.lenEpoch,'Visible','on','String',[]);
                  %##%set(handles.topPanel,'Visible','on');
                  %##%set(handles.textEpoch,'Visible','on');
                  %##%set(handles.textJoinSeg,'Visible','on');
                  %##%set(handles.checkboxJoinSeg,'Visible','on');
                  app.loadFile.Visible="off";
                  app.loadParam.Visible="off";
                  app.lenEpoch.Visible="on";
                  app.lenEpoch.Value='';
                  app.topPanel.Visible="on";
                  app.textEpoch.Visible="on";
                  app.textJoinSeg.Visible="on";
                  app.checkboxJoinSeg.Visible="on";
                  app.checkboxJoinSeg.Value=false;
                  app.lenOverlap.Visible="on";
                  app.lenOverlap.Value='';
                  app.textOverlap.Visible="on";

                  
                  strFT=[{app.fileName}; {'--------------------------------'}];
                  if isfield(header,'sampleFreq')
                      str=['Sampling frequency: ',num2str(header.sampleFreq)];
                      if isfield(header,'sampleFreqUnit')
                          str=[str,' [',header.sampleFreqUnit,']'];
                      else
                          app.paramPreProcess.fileHeader{app.paramPreProcess.fileIndx}.sampleFreqUnit='Hz';
                          str=[str,' [Hz]'];
                      end
                      strFT=[strFT; {str}];
                      strFT=[strFT; {'--------------------------------'}];
                  end
                  %##%set(handles.fileText,'String',strFT,'Visible','on');
                  app.fileText.Text=strFT;
                  app.fileText.Visible="on";
                  if isfield(header,'sampleFreq')
                      %##%set(handles.samplB,'Visible','on','Value',0);
                      %##%set(handles.msecB,'Visible','on','Value',0);
                      %##%set(handles.secB,'Visible','on','Value',0);
                      %##%set(handles.minB,'Visible','on','Value',0);
                      app.Panel.Visible="on";
                      app.Panel.Enable="on";
                      app.samplB.Visible="on";
                      app.samplB.Value=false;
                      app.msecB.Visible="on";
                      app.msecB.Value=false;
                      app.secB.Visible="on";
                      app.secB.Value=false;
                      app.minB.Visible="on";
                      app.minB.Value=false;
                      app.msecBOverlap.Visible="on";
                      app.msecBOverlap.Value=false;
                      app.secBOverlap.Visible="on";
                      app.secBOverlap.Value=false;
                      app.minBOverlap.Visible="on";
                      app.minBOverlap.Value=false;
                      app.textNotch.Visible="off";
                      app.textRes.Visible="off";
                      app.editNotch.Value='';
                      app.editNotch.Visible="off";
                      app.newSF.Visible="off";
                      app.newSF.Value='';
                      app.checkNotchFilt.Visible="on";
                      app.checkNotchFilt.Value=false;
                      app.checkRes.Visible="on";
                      app.checkRes.Value=false;
                      app.checkFilt.Visible="on";
                      app.checkFilt.Value=false;
                      app.fileTextR.Visible="on";
                      app.fileTextR.Text='';

                      app.checkSelL.Visible="on";
                      app.checkSelL.Value=false;
                      app.checkRef.Visible="on";
                      app.checkRef.Value=false;
                      app.checkCompY.Visible="on";
                      app.checkCompY.Value=false;
                      app.ApplyButton.Visible="on";
                      app.pushOK2.Visible="off";
                      app.ListBox.Visible="off";




                  else
                      %##%set(handles.samplB,'Visible','on','Value',0);
                      app.samplB.Visible="on";
                      app.samplB.Value=0;
                  end
                case 3
                    %##%set(handles.loadFile,'Visible','on','Enable','on');
                    %##%set(handles.pushFinishSelection,'Visible','on');
                    %##%set(handles.repFile,'Visible','on');
                    %##%set(handles.corrFile,'Visible','on');
                    %##%set(handles.delFile,'Visible','on');
                    app.loadFile.Visible="on";
                    app.loadFile.Enable="on";
                    app.pushFinishSelection.Visible="on";
                    app.repFile.Visible="on";
                    app.corrFile.Visible="on";
                    app.delFile.Visible="on";
                    
            end
            
            %guidata(hObject,handles)
        end

        % Button pushed function: loadParam
        function loadParam_Callback(app, event)
            % --- Executes on button press in loadParam.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to loadParam (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            %global paramPreProcess
            
             %##%set(handles.loadFile,'Enable','off');
             %##%set(handles.loadParam,'Enable','off');
            app.loadFile.Enable="off";
            app.loadParam.Enable="off";
            
            [app.fileName, app.pathName] = uigetfile ({'./ParameterFiles/*.mat'},'Open File');
            
            app.pathName=getRelPath(app.pathName);
            
            
            if app.fileName
                %%% load parameters
                %#%strF=fullfile(app.pathName,app.fileName);
                strF=strcat(app.pathName,app.fileName);
                warning off
                s=load(strF,'paramPreProcess');
                warning on


              
                    
                    
                if ~isfield(s,'paramPreProcess')
                    hE=msgbox([app.fileName,' is not a correct parameter''s file'],'Error - not parameter''s file','error');
                    uiwait(hE);
                     %##%set(handles.loadFile,'Enable','on');
                     %##%set(handles.loadParam,'Enable','on');
                    app.loadFile.Enable="on";
                    app.loadParam.Enable="on";
                else
                    app.paramPreProcess=s.paramPreProcess;
                   %%% Získanie všetkých vlastností objektu "app"
                    hNames = properties(app);
        
                    %%% Resetovanie hodnôt
                   for i = 1:length(hNames)
                    propName = hNames{i};
            
                    %%% Preskočenie určitých komponentov
                    %#%if ~ismember(propName, {'figure1', 'File', 'Open', 'output'})
                       %#% hTmp = app.(propName);
                
                     %%% Skrytie komponentov, ak majú vlastnosť "Visible"
                    %#%if isprop(hTmp, 'Visible')
                       %#% hTmp.Visible = 'off';
                    %#%end
                
                    %%% Resetovanie hodnoty, ak komponent podporuje "Value"
                    %#%if isempty(hTmp) && isvalid(hTmp) && isprop(hTmp, 'Value')
                       %#% hTmp.Value = 0;
                    %#%end
                
                    %%% Vymazanie používateľských údajov, ak existujú
                    %#%if isprop(hTmp, 'UserData')
                       %#% hTmp.UserData = [];
                    %#%end
                   end
                   %#%end
            
                    %%%% open print window for sumarry
                    %##%handles = printParameters(app, paramPreProcess,handles);
                    
                    app = printParameters(app,app.paramPreProcess);
                    
                    %##%set(handles.loadParam,'Visible','off');
                    %##%set(handles.loadFile,'Visible','on','Enable','on');
                    %##%set(handles.repFile,'Visible','on');
                    %##%set(handles.corrFile,'Visible','on');
                    %##%set(handles.delFile,'Visible','on');
                    %##%set(handles.pushFinishSelection,'Visible','on');
                    app.loadParam.Visible="off";
                    app.loadFile.Visible="on";
                    app.loadFile.Enable="on";
                    app.repFile.Visible="on";
                    app.corrFile.Visible="on";
                    app.delFile.Visible="on";
                    app.pushFinishSelection.Visible="on";
                    app.Image.Visible="on";
                    app.ListBox.Visible="on";

                end
            else
                %##%set(handles.loadFile,'Visible','on','Enable','on');
                %##%set(handles.loadParam,'Visible','on','Enable','on');
                    app.loadParam.Visible="on";
                    app.loadParam.Enable="on";
                    app.loadFile.Visible="on";
                    app.loadFile.Enable="on";
                    %#%app.ListBox.Visible="on";
            end
            
            %guidata(hObject,handles)
        end

        % Value changed function: minB
        function minB_Callback(app, event)
            % --- Executes on button press in minB.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to minB (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            
            %##%set(handles.samplB,'Value',0);
            %##%set(handles.msecB,'Value',0);
            %##%set(handles.secB,'Value',0);
            %set(handles.minB,'Value',0);
            app.samplB.Value=false;
            app.msecB.Value=false;
            app.secB.Value=false;

        lenEpochValue = str2double(app.lenEpoch.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && app.minB.Value == 1
                app.lenEpoch.Value = ''; % Vymaže obsah
                app.minB.Value = 0; % Nastaví na false
        end
            

            
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: msecB
        function msecB_Callback(app, event)
            % --- Executes on button press in msecB.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to msecB (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            

            
            %##%set(handles.samplB,'Value',0);
            app.samplB.Value=false;
            %set(handles.msecB,'Value',0);
            %##%set(handles.secB,'Value',0);
            app.secB.Value=false;
            %##%set(handles.minB,'Value',0);
            app.minB.Value=false;

        lenEpochValue = str2double(app.lenEpoch.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && app.msecB.Value == 1
                app.lenEpoch.Value = ''; % Vymaže obsah
                app.msecB.Value = 0; % Nastaví na false
        end

            
            

            
            %##%guidata(hObject,handles)
        end

        % Value changed function: newSF
        function newSF_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to newSF (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of newSF as text
            %        str2double(get(hObject,'String')) returns contents of newSF as a double
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
               %##%iE=get(handles.corrFile,'UserData');
               % set(handles.corrFile,'UserData',[]);
           %##% else
                %##%iE=paramPreProcess.fileIndx;
            %##%end

            
            app.checkRes.Enable="on";
            
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: pushDone
        function pushDone_Callback(app, event)
            % --- Executes on button press in pushDone.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushDone (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%set(handles.pushDone,'Visible','off','Value',0);
            %##%set(handles.corrValues,'Visible','off','Value',0);
            app.pushDone.Visible="off";
            %##%app.pushDone.Value=0;
            
            %##%set(handles.topPanel,'Visible','off');
            %##%set(handles.fileText,'Visible','off');
            %##%set(handles.textEpoch,'Visible','off');
            %##%set(handles.fileTextR,'Visible','off','String',[]);
            app.topPanel.Visible="off";
            app.fileText.Visible="off";
            app.textEpoch.Visible="off";
            app.fileTextR.Visible="off";
            %#%app.fileTextR.Text='';
            app.corrValues.Visible="off";
            %##%handles = printParameters(app, paramPreProcess,handles);
            %disp(app.paramPreProcess)

            app = printParameters(app,app.paramPreProcess);
            
            %##%set(handles.loadFile,'Visible','on','Enable','on');
            %##%set(handles.pushFinishSelection,'Visible','on');
            %##%set(handles.repFile,'Visible','on');
            %##%set(handles.corrFile,'Visible','on','UserData',[]);
            %##%set(handles.delFile,'Visible','on');
            app.loadFile.Visible="on";
            app.loadFile.Enable="on";
            app.pushFinishSelection.Visible="on";
            app.pushFinishSelection.Enable="on";
            app.repFile.Visible="on";
            app.repFile.Enable="on";
            app.corrFile.Visible="on";
            app.corrFile.Enable="on";
            app.corrFile.UserData ='';
            app.delFile.Visible="on";
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: pushFinishSelection
        function pushFinishSelection_Callback(app, event)
            % --- Executes on button press in pushFinishSelection.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushFinishSelection (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%set(handles.loadFile,'Visible','off');
            %##%set(handles.delFile,'Visible','off');
            %##%set(handles.corrFile,'Visible','off');
            %##%set(handles.repFile,'Visible','off');
            %##%set(handles.pushFinishSelection,'Visible','off');
            app.loadFile.Visible="off";
            app.delFile.Visible="off";
            app.corrFile.Visible="off";
            app.repFile.Visible="off";
            app.pushFinishSelection.Visible="off";
            
            
            %##%set(handles.pushGenSet,'Visible','on');
            %##%set(handles.pushSaveParam,'Visible','on');
            %##%set(handles.pushFinish,'Visible','on');
            %##%set(handles.pushGoBack,'Visible','on');
            app.Image.Visible="on";
            app.pushGenSet.Visible="on";
            app.pushSaveParam.Visible="on";
            app.pushFinish.Visible="on";
            app.pushGoBack.Visible="on";
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: pushFinish
        function pushFinish_Callback(app, event)
            % --- Executes on button press in pushFinish.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushFinish (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%set(handles.pushGenSet,'Visible','on');
            %##%set(handles.pushSaveParam,'Visible','on');
            app.pushGenSet.Visible="on";
            app.pushSaveParam.Visible="on";
            
            %pSave= get(handles.pushSaveParam,'UserData') ;
            %if pSave
            
            %##%if isfield(app.paramPreProcess,'paramSaveFile')
                %##%save(app.paramPreProcess.paramSaveFile,'paramPreProcess');
                %##%close(handles.figure1);
            %##%else
                %##%hD=questdlg('Parameters not saved .... Continue anyway?', ...
                    %##%'Parameters not saved !','yes','no','no');
                %##%switch hD
                    %##%case 'yes'
                        %##%close(handles.figure1);
                    %##%case 'no'
                        %%% do nothing here, keep loop
                %##%end
            %##%end


            if isfield(app.paramPreProcess, 'paramSaveFile')
                paramPreProcess = app.paramPreProcess;  % Uloženie do premennej
                save(app.paramPreProcess.paramSaveFile, 'paramPreProcess');  % Uloženie parametrov
                delete(app);  % Zatvorenie aplikácie
            else
                hD = questdlg('Parameters not saved .... Continue anyway?', ...
                'Parameters not saved!', 'Yes', 'No', 'No');

                switch hD
                    case 'Yes'
                        delete(app);  % Zatvorenie aplikácie
                    case 'No'
                                     % Nerob nič, aplikácia ostáva otvorená
                end
            end
        end

        % Button pushed function: pushGenSet
        function pushGenSet_Callback(app, event)
            % --- Executes on button press in pushGenSet.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushGenSet (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            %##%global paramPreProcess
            
            %##%set(handles.pushGenSet,'Enable','off');
            %##%set(handles.pushSaveParam,'Enable','off');
            %##%set(handles.pushFinish,'Enable','off');
            %##%set(handles.pushGoBack,'Enable','off');

            app.pushGenSet.Enable="off";
            app.pushSaveParam.Enable="off";
            app.pushFinish.Enable="off";
            app.pushGoBack.Enable="off";
            
            app.pathName = uigetdir('./Data/EpochedData','Select folder where to save epoched data ...');
            app.pathName=getRelPath(app.pathName);
            
            if app.pathName
                %hW=warndlg('Working ..... ');
                app.paramPreProcess.pathEpochedData = app.pathName;
                preProcessData(app.paramPreProcess);
                %close(hW)
            else
            
            end
            
            
            %##%set(handles.pushGenSet,'Enable','on');
            %##%set(handles.pushSaveParam,'Enable','on');
            %##%set(handles.pushFinish,'Enable','on');
            %##%set(handles.pushGoBack,'Enable','on');
            app.pushGenSet.Enable="on";
            app.pushSaveParam.Enable="on";
            app.pushFinish.Enable="on";
            app.pushGoBack.Enable="on";
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: pushGoBack
        function pushGoBack_Callback(app, event)
            % --- Executes on button press in pushGoBack.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushGoBack (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%set(handles.pushGenSet,'Visible','off');
            %##%set(handles.pushSaveParam,'Visible','off');
            %##%set(handles.pushFinish,'Visible','off');
            %##%set(handles.pushGoBack,'Visible','off');
            app.pushGenSet.Visible="off";
            app.pushSaveParam.Visible="off";
            app.pushFinish.Visible="off";
            app.pushGoBack.Visible="off";
            
            %##%set(handles.loadFile,'Visible','on');
            %##%set(handles.repFile,'Visible','on');
            %##%set(handles.corrFile,'Visible','on');
            %##%set(handles.delFile,'Visible','on');
            %##%set(handles.pushFinishSelection,'Visible','on');
            app.loadFile.Visible="on";
            app.repFile.Visible="on";
            app.corrFile.Visible="on";
            app.delFile.Visible="on";
            app.pushFinishSelection.Visible="on";
            
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: pushOK2
        function pushOK2_Callback(app, event)
            % --- Executes on button press in pushOK2.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushOK2 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
               %##%iE=get(handles.corrFile,'UserData');
            %##%else
               %##%iE=paramPreProcess.fileIndx;
            %##%end

            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            %%%%% take off visibility
            %##%set(handles.pushOK2,'Visible','off','Value',0);
            %##%set(handles.checkCompY,'Visible','off','Value',0);
            %##%set(handles.checkSelL,'Visible','off','Value',0);
            %##%set(handles.checkRef,'Visible','off','Value',0);
            app.Panel.Visible="off";
            app.Panel.Enable="off";
            app.samplB.Visible="off";
            %#%app.samplB.Value=false;
            app.msecB.Visible="off";
            %#%app.msecB.Value=false;
            app.secB.Visible="off";
            %#%app.secB.Value=false;
            app.minB.Visible="off";
            %#%app.minB.Value=false;
            app.msecBOverlap.Visible="off";
            %#%app.msecBOverlap.Value=false;
            app.secBOverlap.Visible="off";
            %#%app.secBOverlap.Value=false;
            app.minBOverlap.Visible="off";
            %#%app.minBOverlap.Value=false;
            app.checkNotchFilt.Visible="off";
            app.checkRes.Visible="off";
            app.checkFilt.Visible="off";
            %#%app.fileTextR.Visible="off";
            app.checkSelL.Visible="off";
            app.checkRef.Visible="off";
            app.checkCompY.Visible="off";
            app.lenEpoch.Visible="off";
            %#%app.lenEpoch.Value='';
            app.topPanel.Visible="off";
            app.textEpoch.Visible="off";
            app.textJoinSeg.Visible="off";
            app.checkboxJoinSeg.Visible="off";
            app.lenOverlap.Visible="off";
            app.textOverlap.Visible="off";

            
            %%%% visibilty on
            %##%set(handles.corrValues,'Visible','on');
            %##%set(handles.pushDone,'Visible','on');
            app.corrValues.Visible="on";
            app.pushDone.Visible="on";
            app.pushOK2.Enable="on";
            app.pushOK2.Value=0;
            
            %##%guidata(hObject,handles)
        end

        % Button pushed function: pushSaveParam
        function pushSaveParam_Callback(app, event)
            % --- Executes on button press in pushSaveParam.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to pushSaveParam (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            [fName, app.pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
                                              'Save parameters as ...','./ParameterFiles/param_PreProcess.mat');
            app.pathName=getRelPath(app.pathName);
            
            if fName
                str=strcat(app.pathName,fName);
                app.paramPreProcess.paramSaveFile=str;
                %##%handles = printParameters(app, paramPreProcess,handles);
                app = printParameters(app,app.paramPreProcess);
                save(str,'paramPreProcess');
                %set(handles.pushSaveParam,'UserData',true);
            end
            %##%guidata(hObject,handles)
        end

        % Button pushed function: repFile
        function repFile_Callback(app, event)
            % --- Executes on button press in repFile.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to repFile (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            
            %##%set(handles.loadFile,'Visible','off');
            %##%set(handles.repFile,'Visible','off');
            %##%set(handles.corrFile,'Visible','off');
            %##%set(handles.delFile,'Visible','off');
            %##%set(handles.pushFinishSelection,'Visible','off');
            %set(handles.pushFinish,'Visible','off');
            app.loadFile.Visible="off";
            app.repFile.Visible="off";
            app.corrFile.Visible="off";
            app.delFile.Visible="off";
            app.pushFinishSelection.Visible="off";
            
            
            [listNum, ok_click] = listdlg('PromptString','Select file which parameteres to replicate', ...
                'SelectionMode','single', 'ListString',app.paramPreProcess.fileName, ...
                'Name', 'Select file to replicate');
            
            if ok_click
                [app.fileName, app.pathName, filtInd] = uigetfile ({'./Data/RawData/*.mat'},'Open File','MultiSelect', 'on');
                app.pathName=getRelPath(app.pathName);
            
                if filtInd
                    fileIn = false;strFileIn = [];
                    if iscell(app.fileName)
                        lenFile = length(app.fileName);
                        fileInd = ones(lenFile,1);
                        for i=1:lenFile
                            if sum(strcmp(app.paramPreProcess.fileName,app.fileName{i})) && sum(strcmp(app.paramPreProcess.pathName,app.pathName))
                                fileIn = true;
                                strFileIn = [strFileIn, ',', app.fileName{i}];
                                fileInd(i)=0;
                            end
                        end
                    else
                        lenFile = 1; fileInd = 1;
                        if sum(strcmp(app.paramPreProcess.fileName,app.fileName)) && sum(strcmp(app.paramPreProcess.pathName,app.pathName))
                            fileIn = true;
                            strFileIn = [strFileIn, ',', app.fileName];
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
                            if iscell(app.fileName)
                                fName=app.fileName{i};
                            else
                                fName=app.fileName;
                            end
                            strF=strcat(app.pathName,fName);
                            load(strF,'header')
                            if ~exist('header','var')
                                strH = ['Header not present in the', app.fileName{i},' file ... will not be included'];
                                hE=errordlg(strH,'Error - header missing');
                                uiwait(hE);
                            else
                                iE = app.paramPreProcess.fileIndx + 1;
                                app.paramPreProcess.fileIndx = iE;
                                app.paramPreProcess.fileHeader{iE} = header;
                                app.paramPreProcess.fileName{iE} = fName;
                                app.paramPreProcess.pathName{iE} = app.pathName;
                                %%%% copy other parameters
                                fNnew = fieldnames(app.paramPreProcess.fileHeader{iE});
                                fNold = fieldnames(app.paramPreProcess.fileHeader{listNum});
                                for fNi = 1:length(fNold)
                                    %##%if ~strcmp(fNold{fNi},fNnew)
                                    %##%    str =['paramPreProcess.fileHeader{iE}.',fNold{fNi},'=paramPreProcess.fileHeader{listNum}.',fNold{fNi},';'];
                                    %##%    eval(str)
                                    %##%end
                                    if ~strcmp(fNold{fNi}, fNnew)
                                        app.paramPreProcess.fileHeader{iE}.(fNold{fNi}) = ...
                                        app.paramPreProcess.fileHeader{listNum}.(fNold{fNi});
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            %##%handles = printParameters(app, paramPreProcess, handles);
            %disp(app.paramPreProcess)
            app = printParameters(app,app.paramPreProcess);
            
            %##%set(handles.loadFile,'Visible','on');
            %##%set(handles.repFile,'Visible','on');
            %##%set(handles.delFile,'Visible','on');
            %##%set(handles.corrFile,'Visible','on');
            %##%set(handles.pushFinishSelection,'Visible','on');
            app.loadFile.Visible="on";
            app.repFile.Visible="on";
            app.delFile.Visible="on";
            app.corrFile.Visible="on";
            app.pushFinishSelection.Visible="on";
            
            
            %##%guidata(hObject,handles)
        end

        % Value changed function: samplB
        function samplB_Callback(app, event)
            % --- Executes on button press in samplB.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to samplB (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            %##%global paramPreProcess
            
            %##%if get(handles.corrFile,'UserData')
               %##%iE=get(handles.corrFile,'UserData');
            %##%else
                %##%iE=app.paramPreProcess.fileIndx;
            %##%end


            
            %set(handles.samplB,'Value',0);
            %##%set(handles.msecB,'Value',0);
            %##%set(handles.secB,'Value',0);
            %##%set(handles.minB,'Value',0);
            app.msecB.Value=false;
            app.secB.Value=false;
            app.minB.Value=false;

        lenEpochValue = str2double(app.lenEpoch.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && app.samplB.Value == 1
                app.lenEpoch.Value = ''; % Vymaže obsah
                app.samplB.Value = 0; % Nastaví na false
        end
            

            
            %##%guidata(hObject,handles)
        end

        % Value changed function: secB
        function secB_Callback(app, event)
            % --- Executes on button press in secB.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            %##%[hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to secB (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            %##%global paramPreProcess
            

            
            %##%set(handles.samplB,'Value',0);
            %##%set(handles.msecB,'Value',0);
            %set(handles.secB,'Value',0);
            %##%set(handles.minB,'Value',0);
            app.samplB.Value=0;
            app.msecB.Value=0;
            app.minB.Value=0;
         lenEpochValue = str2double(app.lenEpoch.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && app.secB.Value == 1
                app.lenEpoch.Value = ''; % Vymaže obsah
                app.secB.Value = 0; % Nastaví na false
        end
            %##%lenV=str2double(get(handles.lenEpoch,'String'));
            
            
           
            
           %##% guidata(hObject,handles)
        end

        % Value changed function: msecBOverlap
        function msecBOverlapValueChanged(app, event)
            value = app.msecBOverlap.Value;
            app.secBOverlap.Value=false;
            app.minBOverlap.Value=false;
            
        lenEpochValue = str2double(app.lenOverlap.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && value == 1
                app.lenOverlap.Value = ''; % Vymaže obsah
                app.msecBOverlap.Value = 0; % Nastaví na false
        end

            

        end

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(app, event)
            
            %[fileName, ~] = uigetfile ({'./Data/RawData/*.mat'},'Open File');
            app.fileText.Text='';
            strF=strcat(app.pathName,app.fileName);
            load(strF,'header')
            %disp(header)
            strFT=[{app.fileName}; {'--------------------------------'}];

            if ~exist('header','var')
                 strFT=[{app.paramPreProcess.fileName{app.listNum}}; {'--------------------------------'}];
                 str=['Sampling frequency: ',num2str(app.paramPreProcess.fileHeader{app.listNum}.sampleFreq)];
                 strFT=[strFT; {str}];
                 strFT=[strFT; {'--------------------------------'}];
            else
                if isfield(header,'sampleFreq')
                      str=['Sampling frequency: ',num2str(header.sampleFreq)];
                      if isfield(header,'sampleFreqUnit')
                          str=[str,' [',header.sampleFreqUnit,']'];
         
                      else
                          app.paramPreProcess.fileHeader{app.paramPreProcess.fileIndx}.sampleFreqUnit='Hz';
                         str=[str,' [Hz]'];
                     end
                     strFT=[strFT; {str}];
                      strFT=[strFT; {'--------------------------------'}];
                end
             end
            app.fileText.Text=strFT;
            
            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            %##%lenV=str2double(get(handles.lenEpoch,'String'));
            lenV = str2double(app.lenEpoch.Value);
            if app.samplB.Value==true
            if ~(isempty(lenV) || isnan(lenV))
                if isfloat(lenV) && lenV > 0
                    app.paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
                    app.paramPreProcess.fileHeader{iE}.lenEpochUnit = 'samples';
                    app.paramPreProcess.fileHeader{iE}.joinSeg=app.checkboxJoinSeg.Value;
                    %##%set(handles.textJoinSeg,'Visible','off');
                    %##%set(handles.checkboxJoinSeg,'Visible','off');
                    %##%app.textJoinSeg.Visible="off";
                    %##%app.checkboxJoinSeg.Visible="off";
            
                    %##%strFT=get(handles.fileText,'String');
                    strFT = app.fileText.Text;
                    if app.paramPreProcess.fileHeader{iE}.joinSeg
                        str='join disc. seg.: true';
                    else
                        str='join disc. seg.: false';
                    end
                    strFT=[strFT; {str}];
                    strFT=[strFT; {'--------------------------------'}];
                    %##%str=['Epoch length: ',get(handles.lenEpoch,'String'),' [samples]'];
                    str = ['Epoch length: ', app.lenEpoch.Value, ' [samples]'];
                    strFT=[strFT; {str}];
                    %##%set(handles.fileText,'String',strFT);
                    app.fileText.Text=strFT;
            
                    %##%set(handles.lenEpoch,'String','');
                    %##%set(handles.lenEpoch,'Visible','off');
                    %##%set(handles.lenOverlap,'Visible','on');
                    %##%set(handles.textEpoch,'String','Define overlap:');
            
                    %##%set(handles.msecB,'Visible','off');
                    %##%set(handles.secB,'Visible','off');
                    %##%set(handles.minB,'Visible','off');
                    %##%set(handles.samplB,'Value',1,'Enable','off');
            
            
            
                else
                    %##%set(handles.samplB,'Value',0);
                    app.samplB.Value=false;
                end
            end
            end

            if app.minB.Value==true
            if ~(isempty(lenV) || isnan(lenV))
                if isfloat(lenV) && lenV > 0
                    app.paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
                    app.paramPreProcess.fileHeader{iE}.lenEpochUnit = 'min';
                    app.paramPreProcess.fileHeader{iE}.joinSeg=app.checkboxJoinSeg.Value;
                    %##%set(handles.textJoinSeg,'Visible','off');
                    %##%set(handles.checkboxJoinSeg,'Visible','off');
                    %##%app.textJoinSeg.Visible="off";
                    %##%app.checkboxJoinSeg.Visible="off";
            
                    %##%strFT=get(handles.fileText,'String');
                    strFT = app.fileText.Text;
                    if app.paramPreProcess.fileHeader{iE}.joinSeg
                        str='join disc. seg.: true';
                    else
                        str='join disc. seg.: false';
                    end
                    strFT=[strFT; {str}];
                    strFT=[strFT; {'--------------------------------'}];
                    str = ['Epoch length: ', app.lenEpoch.Value, ' [min]'];
                    strFT=[strFT; {str}];
                    app.fileText.Text=strFT;
 
                else
                    app.minB.Value=false;
                end
            end
            end

            if app.msecB.Value==true
            if ~(isempty(lenV) || isnan(lenV))
                if isfloat(lenV) && lenV > 0
                    app.paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
                    app.paramPreProcess.fileHeader{iE}.lenEpochUnit = 'msec';
                    app.paramPreProcess.fileHeader{iE}.joinSeg = app.checkboxJoinSeg.Value;
                    %##%set(handles.textJoinSeg,'Visible','off');
                    %##%set(handles.checkboxJoinSeg,'Visible','off');
                    %#%app.textJoinSeg.Visible="off";
                    %#%app.checkboxJoinSeg.Visible="off";
            
                    %##%strFT=get(handles.fileText,'String');
                    strFT=app.fileText.Text;
                    if app.paramPreProcess.fileHeader{iE}.joinSeg
                        str='join disc. seg.: true';
                    else
                        str='join disc. seg.: false';
                    end
                    strFT=[strFT; {str}];
                    strFT=[strFT; {'--------------------------------'}];
                    str = ['Epoch length: ', app.lenEpoch.Value, ' [msec]'];
                    strFT=[strFT; {str}];
                    %##%set(handles.fileText,'String',strFT);
                    app.fileText.Text = strFT;
                    %##%set(handles.lenEpoch,'String','');
                    %##%set(handles.lenEpoch,'Visible','off');
                    %##%set(handles.lenOverlap,'Visible','on');
                    %##%set(handles.textEpoch,'String','Define overlap:');
                    %##%set(handles.msecB,'Value',0);
                    %##%set(handles.samplB,'Visible','off');
                    %#%app.lenEpoch.Value='';
                    %#%app.lenEpoch.Value="off";
                    %#%app.lenOverlap.Visible="on";
             
                    %#%app.textEpoch.Visible="on";
                    %#%app.msecB.Value="on";
                    %#%app.samplB.Visible="off";

            
            
                else
                    %##%set(handles.msecB,'Value',0);
                    app.msecB.Value=0;
                end
            end
            end

            if app.secB.Value==true
            if ~(isempty(lenV) || isnan(lenV))
                if isfloat(lenV) && lenV > 0
                    app.paramPreProcess.fileHeader{iE}.lenEpoch     = lenV;
                    app.paramPreProcess.fileHeader{iE}.lenEpochUnit = 'sec';
                    app.paramPreProcess.fileHeader{iE}.joinSeg = app.checkboxJoinSeg.Value;
                    %##%set(handles.textJoinSeg,'Visible','off');
                    %##%set(handles.checkboxJoinSeg,'Visible','off');
                    %#%app.textJoinSeg.Visible="off";
                    %#%app.checkboxJoinSeg.Visible="off";
            
                    %##%strFT=get(handles.fileText,'String');
                    strFT=app.fileText.Text;
                    if app.paramPreProcess.fileHeader{iE}.joinSeg
                        str='join disc. seg.: true';
                    else
                        str='join disc. seg.: false';
                    end
                    strFT=[strFT; {str}];
                    strFT=[strFT; {'--------------------------------'}];
                    str = ['Epoch length: ', app.lenEpoch.Value, ' [sec]'];
                    strFT=[strFT; {str}];
                    %##%set(handles.fileText,'String',strFT);
                    app.fileText.Text = strFT;
                    %##%set(handles.lenEpoch,'String','');
                    %##%set(handles.lenEpoch,'Visible','off');
                    %##%set(handles.lenOverlap,'Visible','on');
                    %##%set(handles.textEpoch,'String','Define overlap:');
                    %##%set(handles.msecB,'Value',0);
                    %##%set(handles.samplB,'Visible','off');
                    %#%app.lenEpoch.Value='';
                    %#%app.lenEpoch.Value="off";
                    %#%app.lenOverlap.Visible="on";
             
                    %#%app.textEpoch.Visible="on";
                    %#%app.msecB.Value="on";
                    %#%app.samplB.Visible="off";

            
            
                else
                    %##%set(handles.msecB,'Value',0);
                    app.secB.Value=0;
                end
            end
            end



            lenV2 = str2double(app.lenOverlap.Value);
            if app.msecBOverlap.Value==true
            if ~(isempty(lenV2) || isnan(lenV2))
                if checkCorrOver(app, lenV2,'msec',app.paramPreProcess.fileHeader{iE})
                    if isfloat(lenV2) && lenV2 >= 0
                        app.paramPreProcess.fileHeader{iE}.lenOverlap     = lenV2;
                        app.paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'msec';
            
                        strFT = app.fileText.Text;
                        str = ['Overlap length: ', app.lenOverlap.Value, ' [msec]'];
                        strFT=[strFT;  {'--------------------------------'}; {str}];
                        app.fileText.Text = strFT;
                        %%%% set handles
                        %##%handles = handles_set2(app, handles,paramPreProcess,iE);
                        %#%app = handles_set2(app, app.paramPreProcess, iE);
                    else
                        %##%set(handles.msecB,'Value',0);
                        app.msecBOverlap.Value=false;
                    end
                else
                    hE=errordlg('Overalp can''t be greater than epoch length');
                    uiwait(hE);
                    %##%set(handles.msecB,'Value',0);
                    %##%set(handles.lenOverlap,'String',[]);
                    app.msecBOverlap.Value=false;
                    app.lenOverlap.Value='';
                end
            end
            end
             if app.secBOverlap.Value==true
             if ~(isempty(lenV2) || isnan(lenV2))
                if checkCorrOver(app, lenV2,'sec',app.paramPreProcess.fileHeader{iE})
                    if isfloat(lenV2) && lenV2 >= 0
                        app.paramPreProcess.fileHeader{iE}.lenOverlap     = lenV2;
                        app.paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'sec';
            
                        strFT = app.fileText.Text;
                        str = ['Overlap length: ', app.lenOverlap.Value, ' [sec]'];
                        strFT=[strFT;  {'--------------------------------'}; {str}];
                        app.fileText.Text = strFT;
                        %%%% set handles
                        %##%handles = handles_set2(app, handles,paramPreProcess,iE);
                        %#%app = handles_set2(app, app.paramPreProcess, iE);
                    else
                        %##%set(handles.msecB,'Value',0);
                        app.secBOverlap.Value=false;
                    end
                else
                    hE=errordlg('Overalp can''t be greater than epoch length');
                    uiwait(hE);
                    %##%set(handles.msecB,'Value',0);
                    %##%set(handles.lenOverlap,'String',[]);
                    app.secBOverlap.Value=false;
                    app.lenOverlap.Value='';
                end
             end
             end

             if app.minBOverlap.Value==true
             if ~(isempty(lenV2) || isnan(lenV2))
                if checkCorrOver(app, lenV2,'min',app.paramPreProcess.fileHeader{iE})
                    if isfloat(lenV2) && lenV2 >= 0
                        app.paramPreProcess.fileHeader{iE}.lenOverlap     = lenV2;
                        app.paramPreProcess.fileHeader{iE}.lenOverlapUnit = 'min';
            
                        strFT = app.fileText.Text;
                        str = ['Overlap length: ', app.lenOverlap.Value, ' [min]'];
                        strFT=[strFT;  {'--------------------------------'}; {str}];
                        app.fileText.Text = strFT;
                        %%%% set handles
                        %##%handles = handles_set2(app, handles,paramPreProcess,iE);
                        %#%app = handles_set2(app, app.paramPreProcess, iE);
                    else
                        %##%set(handles.msecB,'Value',0);
                        app.minBOverlap.Value=false;
                    end
                else
                    hE=errordlg('Overalp can''t be greater than epoch length');
                    uiwait(hE);
                    %##%set(handles.msecB,'Value',0);
                    %##%set(handles.lenOverlap,'String',[]);
                    app.minBOverlap.Value=false;
                    app.lenOverlap.Value='';
                end
             end
             end
%%%%%%%%%%%%%%%%%%%%%%



             if ~isempty(app.corrFile.UserData) % Skontroluje, či UserData nie je prázdne
                iE = app.corrFile.UserData; % Získa hodnotu z UserData
            else
                iE = app.paramPreProcess.fileIndx; % Použije predvolený index
            end
            if app.checkRes.Value
                %##%set(handles.checkRes,'Enable','off');
                %#%app.checkRes.Enable="off";
                %##%set(handles.checkFilt,'Enable','off');
                %##%set(handles.checkNotchFilt,'Enable','off');
                %##%set(handles.pushOK1,'Enable','off');
            
                %##%set(handles.textRes,'Visible','on');
                %##%set(handles.newSF,'Visible','on');
                %#%app.textRes.Visible="on";
                %#%app.newSF.Visible="on";
                if isfield(app.paramPreProcess.fileHeader{iE},'sampleFreq')
                    str = ['New sampling freq. in ','[',app.paramPreProcess.fileHeader{iE}.sampleFreqUnit,']:'];
                else
                    str = 'Decimation factor (integer):';
                end
                %##%set(handles.textRes,'String',str)
                %##%disp(get(handles.corrFile,'UserData'))
                %#%app.textRes.Text = str;
                %disp(app.corrFile.UserData);
            else
                %##%strRFT = get(handles.fileTextR,'String');
                %#%app.textRes.Text='';
                %#%app.newSF.Visible="off";
                %#%app.textRes.Visible="off";
                
                %#%strRFT = app.fileTextR.Text;
                if isfield(app.paramPreProcess.fileHeader{iE},'new_sampleFreq')
                    app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'new_sampleFreq');
                    %paramPreProcess.fileHeader{iE}.new_sampleFreq = paramPreProcess.fileHeader{iE}.sampleFreq;
                    nstr='Re-sampling: no';
                elseif isfield(app.paramPreProcess.fileHeader{iE},'decimationFactor')
                    app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'decimationFactor');
                    nstr='Decimation: no';
                else
                    %#%nstr='Decimation: no';
                    nstr='Re-sampling: no';
                end
                %##%strRFT(1)={nstr};
                strRFT = nstr;   
                app.fileTextR.Text = strRFT;
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                %#%app.fileTextR.Text=strRFT;
            
            end
             %##%nsf=str2double(get(handles.newSF,'String'));
            nsf = str2double(app.newSF.Value);
            if isfloat(nsf) && nsf > 0
                %##%strRFT = get(handles.fileTextR,'String');
                strRFT = app.fileTextR.Text;
                if isfield(app.paramPreProcess.fileHeader{iE},'sampleFreq')
                    app.paramPreProcess.fileHeader{iE}.new_sampleFreq = nsf;
                    nstr=['New sampling frequency: ',num2str(app.paramPreProcess.fileHeader{iE}.new_sampleFreq), ...
                        ' [',app.paramPreProcess.fileHeader{iE}.sampleFreqUnit,']'];
                else
                    app.paramPreProcess.fileHeader{iE}.decimationFactor = nsf;
                    nstr=['Decimation factor: ',num2str(app.paramPreProcess.fileHeader{iE}.decimationFactor)];
                end
                %##%strRFT(1)={nstr};
                strRFT=nstr;
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                app.fileTextR.Text=strRFT;
                %##%set(handles.checkRes,'Enable','on','Value',1);
                %#%app.checkRes.Enable="on";
                %##%set(handles.checkFilt,'Enable','on');
                %##%set(handles.checkNotchFilt,'Enable','on');
                %##%set(handles.pushOK1,'Enable','on');
                %##%set(handles.textRes,'Visible','off');
                %##%set(handles.newSF,'Visible','off','String',[]);
            end

            if app.checkFilt.Value
                %##%set(handles.checkFilt,'Enable','off');
                %##%set(handles.checkNotchFilt,'Enable','off');
                %##%set(handles.checkRes,'Enable','off');
                %##%set(handles.pushOK1,'Enable','off');
                %#%app.checkFilt.Enable="off";
                %#%app.checkNotchFilt.Enable="off";
                %#%app.checkRes.Enable="off";
                %#%app.pushOK1.Enable="off";
            
                %#%[app.fileName, app.pathName] = uigetfile ({'./Filters/*.mat'},'Open a Filter File');
                %#%app.pathName=getRelPath(app.pathName);
            
                if app.fileName2
                    %%% load parameters
                    strF2=strcat(app.pathName2,app.fileName2);
                    load(strF2)
                    if exist('dM','var') && exist('fM','var')
                        %%%% define filter file, this also means filtering data .....
                        app.paramPreProcess.fileHeader{iE}.filterFile=strF2;
                        
                        %##%strRFT = get(handles.fileTextR,'String');
                        strRFT = app.fileTextR.Text;
                        
                        
                        if strcmp(dM.Response,'Bandstop')
                            nstr=['Filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass1),'-',num2str(dM.Fpass2), ...
                                '//',fM.FilterStructure,'//', '(',app.paramPreProcess.fileHeader{iE}.filterFile,')'];
                        else
                            nstr=['Filtering: ',dM.Response,'//','Fpass:',num2str(dM.Fpass), ...
                                '//',fM.FilterStructure,'//', '(',app.paramPreProcess.fileHeader{iE}.filterFile,')'];
                        end

                        %##%strRFT(3)={nstr};
                        strRFT=[strRFT; {'--------------------------------'}];
                        strRFT=[strRFT; {nstr}];
                        %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                        app.fileTextR.Text = strRFT;
                        %#%set(handles.checkFilt,'Enable','on','Value',1);
                        %#%set(handles.checkNotchFilt,'Enable','on');
                        %#%set(handles.checkRes,'Enable','on');
                        %#%set(handles.pushOK1,'Enable','on');
                    else
                        hE=errordlg('Filter does not contain compulsory structures f and d');
                        uiwait(hE);
                        %#%set(handles.checkFilt,'Enable','on','Value',0);
                        %#%set(handles.checkNotchFilt,'Enable','on');
                        %#%set(handles.checkRes,'Enable','on');
                        %#%set(handles.pushOK1,'Enable','on');
                    end
                else
                    %#%set(handles.checkFilt,'Enable','on','Value',0);
                    %#%set(handles.checkNotchFilt,'Enable','on');
                    %#%set(handles.checkRes,'Enable','on');
                    %#%set(handles.pushOK1,'Enable','on');
                end
            else
                if isfield(app.paramPreProcess.fileHeader{iE}, 'filterFile')
                    app.paramPreProcess.fileHeader{iE} = rmfield(app.paramPreProcess.fileHeader{iE}, 'filterFile');
                else
                    %disp('Field "filterFile" does not exist.');
                end
                %#%app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'filterFile');
                %##%strRFT = get(handles.fileTextR,'String');
                strRFT = app.fileTextR.Text;
                %##%strRFT(3)={'Filtering: no'};
                nstr = 'Filtering: no';
                strRFT=[strRFT; {'--------------------------------'}];
                strRFT=[strRFT; {nstr}];
                %#%set(handles.fileTextR,'Visible','on','String',strRFT);
                app.fileTextR.Text = strRFT;
            end

            if app.checkNotchFilt.Value==false
                %##%set(handles.checkNotchFilt,'Enable','off'); % ,'Value',0);
                %#%app.checkNotchFilt.Enable="off";
                 %##%set(handles.checkFilt,'Enable','off');
                %##%set(handles.checkRes,'Enable','off');
                %##%set(handles.pushOK1,'Enable','off');
            
                %##%set(handles.textNotch,'Visible','on');
                %##%set(handles.editNotch,'Visible','on');
                if isfield(app.paramPreProcess.fileHeader{iE}, 'notchFilter')
                    app.paramPreProcess.fileHeader{iE} = rmfield(app.paramPreProcess.fileHeader{iE}, 'notchFilter');
                else
                    %disp('Field "notchFilter" does not exist.');
                end
                %##%app.paramPreProcess.fileHeader{iE}=rmfield(app.paramPreProcess.fileHeader{iE},'notchFilter');
                %##%strRFT = get(handles.fileTextR,'String');
                strRFT=app.fileTextR.Text;
                strRFT=[strRFT; {'--------------------------------'}];
                strRFT=[strRFT;{'Notch Filtering: no'}];
                %##%set(handles.checkNotchFilt,'Enable','on','Value',0);
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                app.fileTextR.Text=strRFT;
            end

             nsf=str2double(app.editNotch.Value);
            if isfloat(nsf) && nsf > 0
                app.paramPreProcess.fileHeader{iE}.notchFilter = nsf;
                %##%strRFT = get(handles.fileTextR,'String');
                strRFT = app.fileTextR.Text;
                strRFT=[strRFT; {'--------------------------------'}];
                strRFT=[strRFT;{['Notch Filtering: ',app.editNotch.Value,'[Hz]']}];
                %##%set(handles.fileTextR,'Visible','on','String',strRFT);
                app.fileTextR.Text=strRFT;
                %##%set(handles.checkRes,'Enable','on');
                %##%set(handles.checkFilt,'Enable','on');
                %##%set(handles.checkNotchFilt,'Enable','on','Value',1);
                %##%set(handles.pushOK1,'Enable','on');
                %##%set(handles.textNotch,'Visible','off');
                %##%set(handles.editNotch,'Visible','off','String',[]);
            end


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            




            if app.corrFile.UserData
                iE = app.corrFile.UserData;
            else
                iE = app.paramPreProcess.fileIndx;
            end
            
            if app.checkRef.Value
                strRFT=app.fileTextR.Text;
                strRFT=[strRFT;{'--------------------------------'};{app.vektor};{'--------------------------------'}];
                app.fileTextR.Text=strRFT;
            else
                strRFT=app.fileTextR.Text;
                app.vektor='Re-referencing: no';
                strRFT=[strRFT;{'--------------------------------'};{app.vektor};{'--------------------------------'}];
                app.fileTextR.Text=strRFT;
            end
            

            if isfield(app.paramPreProcess.fileHeader{iE},'Xlabels2use')
                    if length(app.paramPreProcess.fileHeader{iE}.Xlabels2use) == length(app.paramPreProcess.fileHeader{iE}.Xlabels)
                       %##% strRFT = get(handles.fileTextR,'String');
                       strRFT = app.fileTextR.Text;
                        strRFT=[strRFT;{'Variables to use: all'}];
                        %#%strRFT=[strRFT;{' '}];
                        %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
                        %#%app.checkSelL.Enable="on";
                        %#%app.checkSelL.Visible="on";
                        %#%app.checkSelL.Value=0;
                    else
                        %##%strRFT = get(handles.fileTextR,'String');
                        strRFT=app.fileTextR.Text;
                        pStr = [];
                        %ppStr=paramPreProcess.fileHeader{iE}.Xlabels
                        for sI=1:length(app.paramPreProcess.fileHeader{iE}.Xlabels2use)
                            pStr=[pStr,regexprep(app.paramPreProcess.fileHeader{iE}.Xlabels2use{sI},'[^\w'']',''),','];
                        end
                        pStr=pStr(1:end-1);
                        strRFT=[strRFT;{['Variables to use: ',pStr]}];
                        
                        %%%strRFT=[strRFT;{pStr}];
                        %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',1);
                        %#%app.checkSelL.Enable="on";
                        %#%app.checkSelL.Visible="on";
                        %#%app.checkSelL.Value=1;
                    end
                else
                    %##%strRFT = get(handles.fileTextR,'String');
                    %##%strRFT(7)={'Variables to use: all'};
                    %##%strRFT(8)={' '};
                    %##%set(handles.checkSelL,'Enable','on','Visible','on','Value',0);
                    strRFT = app.fileTextR.Text;
                    strRFT=[strRFT;{'Variables to use: all'}];
                    %#%strRFT=[strRFT;{' '}];
                    %#%app.checkSelL.Enable="on";
                    %#%app.checkSelL.Visible="on";
                    %#%app.checkSelL.Value=0;
                    
            end
                if app.checkCompY.Value
                app.fileTextR.Text=strRFT;
                strRFT = app.fileTextR.Text;
                strRFT = [strRFT;{'--------------------------------'};app.vektor2];
                else
                app.fileTextR.Text=strRFT;
                strRFT = app.fileTextR.Text;
                app.vektor2={'Processing events: no'};
                strRFT = [strRFT;{'--------------------------------'};app.vektor2];
                end
                app.fileTextR.Text = strRFT;
                app.pushOK2.Visible="on";
                app.pushOK2.Enable= "on";
            
        end

        % Value changed function: secBOverlap
        function secBOverlapValueChanged(app, event)
            value = app.secBOverlap.Value;
            app.minBOverlap.Value=false;
            app.msecBOverlap.Value=false;
        lenEpochValue = str2double(app.lenOverlap.Value); % Konverzia na číslo

        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && value == 1
                app.lenOverlap.Value = ''; % Vymaže obsah
                app.secBOverlap.Value = 0; % Nastaví na false
        end
        end

        % Value changed function: minBOverlap
        function minBOverlapValueChanged(app, event)
            value = app.minBOverlap.Value;
            app.secBOverlap.Value=false;
            app.msecBOverlap.Value=false;
        lenEpochValue = str2double(app.lenOverlap.Value); % Konverzia na číslo
        if ~isnan(lenEpochValue) && lenEpochValue <= 0 && value == 1
                app.lenOverlap.Value = ''; % Vymaže obsah
                app.minBOverlap.Value = 0; % Nastaví na false
        end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            colormap(app.figure1, 'parula');
            app.figure1.Position = [1 1 827 543];
            app.figure1.Name = 'gui_preProcessRaw';
            app.figure1.SizeChangedFcn = createCallbackFcn(app, @figure1_ResizeFcn, true);
            app.figure1.HandleVisibility = 'callback';
            app.figure1.Tag = 'figure1';

            % Create topPanel
            app.topPanel = uipanel(app.figure1);
            app.topPanel.Enable = 'off';
            app.topPanel.Visible = 'off';
            app.topPanel.Position = [-14 -40 656 6];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.figure1);
            app.GridLayout.ColumnWidth = {'192x', '140x', '210x', '266x'};
            app.GridLayout.RowHeight = {'166x', '48x', '48x', '49x', '49x', '48x', '65x'};
            app.GridLayout.ColumnSpacing = 6.00000610351563;
            app.GridLayout.RowSpacing = 5.99999830457899;
            app.GridLayout.Padding = [6.00000610351563 5.99999830457899 6.00000610351563 5.99999830457899];

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.ScaleMethod = 'fill';
            app.Image.Layout.Row = [1 7];
            app.Image.Layout.Column = [1 4];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'eeg3.jpg');

            % Create loadFile
            app.loadFile = uibutton(app.GridLayout, 'push');
            app.loadFile.ButtonPushedFcn = createCallbackFcn(app, @loadFile_Callback, true);
            app.loadFile.HorizontalAlignment = 'left';
            app.loadFile.BackgroundColor = [1 1 1];
            app.loadFile.FontName = 'Consolas';
            app.loadFile.FontSize = 20;
            app.loadFile.FontWeight = 'bold';
            app.loadFile.Layout.Row = 4;
            app.loadFile.Layout.Column = 4;
            app.loadFile.Text = 'Add File ';

            % Create loadParam
            app.loadParam = uibutton(app.GridLayout, 'push');
            app.loadParam.ButtonPushedFcn = createCallbackFcn(app, @loadParam_Callback, true);
            app.loadParam.HorizontalAlignment = 'left';
            app.loadParam.BackgroundColor = [1 1 1];
            app.loadParam.FontName = 'Consolas';
            app.loadParam.FontSize = 20;
            app.loadParam.FontWeight = 'bold';
            app.loadParam.Layout.Row = 5;
            app.loadParam.Layout.Column = 4;
            app.loadParam.Text = 'Load Parameters ';

            % Create fileText
            app.fileText = uilabel(app.GridLayout);
            app.fileText.BackgroundColor = [1 1 1];
            app.fileText.VerticalAlignment = 'top';
            app.fileText.WordWrap = 'on';
            app.fileText.FontName = 'Consolas';
            app.fileText.FontWeight = 'bold';
            app.fileText.FontColor = [0.149 0.149 0.149];
            app.fileText.Visible = 'off';
            app.fileText.Layout.Row = 1;
            app.fileText.Layout.Column = [1 2];
            app.fileText.Text = '';

            % Create delFile
            app.delFile = uibutton(app.GridLayout, 'push');
            app.delFile.ButtonPushedFcn = createCallbackFcn(app, @delFile_Callback, true);
            app.delFile.HorizontalAlignment = 'left';
            app.delFile.BackgroundColor = [1 1 1];
            app.delFile.FontName = 'Consolas';
            app.delFile.FontSize = 20;
            app.delFile.FontWeight = 'bold';
            app.delFile.Visible = 'off';
            app.delFile.Layout.Row = 3;
            app.delFile.Layout.Column = 4;
            app.delFile.Text = 'Delete File';

            % Create corrFile
            app.corrFile = uibutton(app.GridLayout, 'push');
            app.corrFile.ButtonPushedFcn = createCallbackFcn(app, @corrFile_Callback, true);
            app.corrFile.HorizontalAlignment = 'left';
            app.corrFile.BackgroundColor = [1 1 1];
            app.corrFile.FontName = 'Consolas';
            app.corrFile.FontSize = 20;
            app.corrFile.FontWeight = 'bold';
            app.corrFile.Visible = 'off';
            app.corrFile.Layout.Row = 2;
            app.corrFile.Layout.Column = 4;
            app.corrFile.Text = 'Correct File';

            % Create fileTextR
            app.fileTextR = uilabel(app.GridLayout);
            app.fileTextR.BackgroundColor = [1 1 1];
            app.fileTextR.VerticalAlignment = 'top';
            app.fileTextR.WordWrap = 'on';
            app.fileTextR.FontName = 'Consolas';
            app.fileTextR.FontWeight = 'bold';
            app.fileTextR.Visible = 'off';
            app.fileTextR.Layout.Row = 1;
            app.fileTextR.Layout.Column = [3 4];
            app.fileTextR.Text = '';

            % Create pushFinishSelection
            app.pushFinishSelection = uibutton(app.GridLayout, 'push');
            app.pushFinishSelection.ButtonPushedFcn = createCallbackFcn(app, @pushFinishSelection_Callback, true);
            app.pushFinishSelection.HorizontalAlignment = 'left';
            app.pushFinishSelection.BackgroundColor = [1 1 1];
            app.pushFinishSelection.FontName = 'Consolas';
            app.pushFinishSelection.FontSize = 20;
            app.pushFinishSelection.FontWeight = 'bold';
            app.pushFinishSelection.Visible = 'off';
            app.pushFinishSelection.Layout.Row = 6;
            app.pushFinishSelection.Layout.Column = 4;
            app.pushFinishSelection.Text = 'File Selection - Done!';

            % Create Panel
            app.Panel = uipanel(app.GridLayout);
            app.Panel.BorderColor = [1 1 1];
            app.Panel.ForegroundColor = [0.149 0.149 0.149];
            app.Panel.HighlightColor = [1 1 1];
            app.Panel.Visible = 'off';
            app.Panel.BackgroundColor = [1 1 1];
            app.Panel.Layout.Row = [2 7];
            app.Panel.Layout.Column = [1 2];

            % Create textJoinSeg
            app.textJoinSeg = uilabel(app.Panel);
            app.textJoinSeg.HorizontalAlignment = 'center';
            app.textJoinSeg.VerticalAlignment = 'top';
            app.textJoinSeg.WordWrap = 'on';
            app.textJoinSeg.FontName = 'Consolas';
            app.textJoinSeg.FontSize = 14;
            app.textJoinSeg.FontWeight = 'bold';
            app.textJoinSeg.Visible = 'off';
            app.textJoinSeg.Position = [2 315 164 33];
            app.textJoinSeg.Text = 'Join Discontinous Segments';

            % Create checkboxJoinSeg
            app.checkboxJoinSeg = uicheckbox(app.Panel);
            app.checkboxJoinSeg.Visible = 'off';
            app.checkboxJoinSeg.Text = '';
            app.checkboxJoinSeg.FontSize = 10.6666666666667;
            app.checkboxJoinSeg.Position = [173 323 36 18];

            % Create textEpoch
            app.textEpoch = uilabel(app.Panel);
            app.textEpoch.HorizontalAlignment = 'center';
            app.textEpoch.VerticalAlignment = 'top';
            app.textEpoch.WordWrap = 'on';
            app.textEpoch.FontName = 'Consolas';
            app.textEpoch.FontSize = 14;
            app.textEpoch.FontWeight = 'bold';
            app.textEpoch.Visible = 'off';
            app.textEpoch.Position = [2 260 164 22];
            app.textEpoch.Text = 'Define epoch''s length';

            % Create lenEpoch
            app.lenEpoch = uieditfield(app.Panel, 'text');
            app.lenEpoch.ValueChangedFcn = createCallbackFcn(app, @lenEpoch_Callback, true);
            app.lenEpoch.HorizontalAlignment = 'center';
            app.lenEpoch.FontName = 'Consolas';
            app.lenEpoch.FontSize = 14;
            app.lenEpoch.Visible = 'off';
            app.lenEpoch.Position = [199 258 50 22];

            % Create samplB
            app.samplB = uicheckbox(app.Panel);
            app.samplB.ValueChangedFcn = createCallbackFcn(app, @samplB_Callback, true);
            app.samplB.Visible = 'off';
            app.samplB.Text = '# samples';
            app.samplB.FontName = 'Consolas';
            app.samplB.Position = [256 298 77 15];

            % Create msecB
            app.msecB = uicheckbox(app.Panel);
            app.msecB.ValueChangedFcn = createCallbackFcn(app, @msecB_Callback, true);
            app.msecB.Visible = 'off';
            app.msecB.Text = 'msec';
            app.msecB.FontName = 'Consolas';
            app.msecB.Position = [256 281 48 15];

            % Create secB
            app.secB = uicheckbox(app.Panel);
            app.secB.ValueChangedFcn = createCallbackFcn(app, @secB_Callback, true);
            app.secB.Visible = 'off';
            app.secB.Text = 'sec';
            app.secB.FontName = 'Consolas';
            app.secB.Position = [256 264 44 15];

            % Create minB
            app.minB = uicheckbox(app.Panel);
            app.minB.ValueChangedFcn = createCallbackFcn(app, @minB_Callback, true);
            app.minB.Visible = 'off';
            app.minB.Text = 'min';
            app.minB.FontName = 'Consolas';
            app.minB.Position = [256 247 42 15];

            % Create textOverlap
            app.textOverlap = uilabel(app.Panel);
            app.textOverlap.HorizontalAlignment = 'center';
            app.textOverlap.VerticalAlignment = 'top';
            app.textOverlap.WordWrap = 'on';
            app.textOverlap.FontName = 'Consolas';
            app.textOverlap.FontSize = 14;
            app.textOverlap.FontWeight = 'bold';
            app.textOverlap.Visible = 'off';
            app.textOverlap.Position = [2 203 164 22];
            app.textOverlap.Text = 'Define overlap';

            % Create lenOverlap
            app.lenOverlap = uieditfield(app.Panel, 'text');
            app.lenOverlap.ValueChangedFcn = createCallbackFcn(app, @lenOverlap_Callback, true);
            app.lenOverlap.HorizontalAlignment = 'center';
            app.lenOverlap.FontName = 'Consolas';
            app.lenOverlap.FontSize = 14;
            app.lenOverlap.Visible = 'off';
            app.lenOverlap.Position = [196 201 50 22];

            % Create msecBOverlap
            app.msecBOverlap = uicheckbox(app.Panel);
            app.msecBOverlap.ValueChangedFcn = createCallbackFcn(app, @msecBOverlapValueChanged, true);
            app.msecBOverlap.Visible = 'off';
            app.msecBOverlap.Text = 'msec';
            app.msecBOverlap.FontName = 'Consolas';
            app.msecBOverlap.Position = [256 222 48 15];

            % Create secBOverlap
            app.secBOverlap = uicheckbox(app.Panel);
            app.secBOverlap.ValueChangedFcn = createCallbackFcn(app, @secBOverlapValueChanged, true);
            app.secBOverlap.Visible = 'off';
            app.secBOverlap.Text = 'sec';
            app.secBOverlap.FontName = 'Consolas';
            app.secBOverlap.Position = [256 205 39 15];

            % Create checkRes
            app.checkRes = uicheckbox(app.Panel);
            app.checkRes.ValueChangedFcn = createCallbackFcn(app, @checkRes_Callback, true);
            app.checkRes.Visible = 'off';
            app.checkRes.Text = 'Resample Data? ';
            app.checkRes.FontName = 'Consolas';
            app.checkRes.FontSize = 14;
            app.checkRes.FontWeight = 'bold';
            app.checkRes.Position = [2 160 137 22];

            % Create checkFilt
            app.checkFilt = uicheckbox(app.Panel);
            app.checkFilt.ValueChangedFcn = createCallbackFcn(app, @checkFilt_Callback, true);
            app.checkFilt.Visible = 'off';
            app.checkFilt.Text = 'Filter Data? ';
            app.checkFilt.FontName = 'Consolas';
            app.checkFilt.FontSize = 14;
            app.checkFilt.FontWeight = 'bold';
            app.checkFilt.Position = [2 133 132 21];

            % Create checkNotchFilt
            app.checkNotchFilt = uicheckbox(app.Panel);
            app.checkNotchFilt.ValueChangedFcn = createCallbackFcn(app, @checkNotchFilt_Callback, true);
            app.checkNotchFilt.Visible = 'off';
            app.checkNotchFilt.Text = 'Apply Notch Filter ';
            app.checkNotchFilt.FontName = 'Consolas';
            app.checkNotchFilt.FontSize = 14;
            app.checkNotchFilt.FontWeight = 'bold';
            app.checkNotchFilt.Position = [2 104 164 18];

            % Create textRes
            app.textRes = uilabel(app.Panel);
            app.textRes.HorizontalAlignment = 'center';
            app.textRes.VerticalAlignment = 'top';
            app.textRes.WordWrap = 'on';
            app.textRes.FontName = 'Consolas';
            app.textRes.FontWeight = 'bold';
            app.textRes.Visible = 'off';
            app.textRes.Position = [199 153 71 28];
            app.textRes.Text = 'New sampl. freq. ? ';

            % Create newSF
            app.newSF = uieditfield(app.Panel, 'text');
            app.newSF.ValueChangedFcn = createCallbackFcn(app, @newSF_Callback, true);
            app.newSF.HorizontalAlignment = 'center';
            app.newSF.FontName = 'Consolas';
            app.newSF.Visible = 'off';
            app.newSF.Position = [280 160 53 22];

            % Create editNotch
            app.editNotch = uieditfield(app.Panel, 'text');
            app.editNotch.ValueChangedFcn = createCallbackFcn(app, @editNotch_Callback, true);
            app.editNotch.HorizontalAlignment = 'center';
            app.editNotch.FontName = 'Consolas';
            app.editNotch.Visible = 'off';
            app.editNotch.Position = [285 102 53 22];

            % Create textNotch
            app.textNotch = uilabel(app.Panel);
            app.textNotch.HorizontalAlignment = 'center';
            app.textNotch.VerticalAlignment = 'top';
            app.textNotch.WordWrap = 'on';
            app.textNotch.FontName = 'Consolas';
            app.textNotch.FontWeight = 'bold';
            app.textNotch.Visible = 'off';
            app.textNotch.Position = [199 94 87 30];
            app.textNotch.Text = 'Define notch freq. [Hz]';

            % Create checkSelL
            app.checkSelL = uicheckbox(app.Panel);
            app.checkSelL.ValueChangedFcn = createCallbackFcn(app, @checkSelL_Callback, true);
            app.checkSelL.Visible = 'off';
            app.checkSelL.Text = 'Select sub-variables? ';
            app.checkSelL.FontName = 'Consolas';
            app.checkSelL.FontSize = 14;
            app.checkSelL.FontWeight = 'bold';
            app.checkSelL.Position = [1 44 192 22];

            % Create checkRef
            app.checkRef = uicheckbox(app.Panel);
            app.checkRef.ValueChangedFcn = createCallbackFcn(app, @checkRef_Callback, true);
            app.checkRef.Visible = 'off';
            app.checkRef.Text = 'Data re-referencing? ';
            app.checkRef.FontName = 'Consolas';
            app.checkRef.FontSize = 14;
            app.checkRef.FontWeight = 'bold';
            app.checkRef.Position = [1 75 183 16];

            % Create checkCompY
            app.checkCompY = uicheckbox(app.Panel);
            app.checkCompY.ValueChangedFcn = createCallbackFcn(app, @checkCompY_Callback, true);
            app.checkCompY.Visible = 'off';
            app.checkCompY.Text = 'Process Events? ';
            app.checkCompY.FontName = 'Consolas';
            app.checkCompY.FontSize = 14;
            app.checkCompY.FontWeight = 'bold';
            app.checkCompY.Position = [1 27 161 16];

            % Create minBOverlap
            app.minBOverlap = uicheckbox(app.Panel);
            app.minBOverlap.ValueChangedFcn = createCallbackFcn(app, @minBOverlapValueChanged, true);
            app.minBOverlap.Visible = 'off';
            app.minBOverlap.Text = 'min';
            app.minBOverlap.FontName = 'Consolas';
            app.minBOverlap.Position = [256 189 39 15];

            % Create ApplyButton
            app.ApplyButton = uibutton(app.Panel, 'push');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.BackgroundColor = [1 1 1];
            app.ApplyButton.FontName = 'Consolas';
            app.ApplyButton.FontSize = 18;
            app.ApplyButton.FontWeight = 'bold';
            app.ApplyButton.FontColor = [0.3922 0.8314 0.0745];
            app.ApplyButton.Visible = 'off';
            app.ApplyButton.Position = [204 38 129 28];
            app.ApplyButton.Text = 'Apply';

            % Create pushOK2
            app.pushOK2 = uibutton(app.Panel, 'state');
            app.pushOK2.ValueChangedFcn = createCallbackFcn(app, @pushOK2_Callback, true);
            app.pushOK2.Visible = 'off';
            app.pushOK2.VerticalAlignment = 'top';
            app.pushOK2.Text = 'Done';
            app.pushOK2.BackgroundColor = [1 1 1];
            app.pushOK2.FontName = 'Consolas';
            app.pushOK2.FontSize = 18;
            app.pushOK2.FontWeight = 'bold';
            app.pushOK2.FontColor = [1 0 0];
            app.pushOK2.Position = [204 1 129 28];

            % Create ListBox
            app.ListBox = uilistbox(app.GridLayout);
            app.ListBox.Items = {''};
            app.ListBox.Visible = 'off';
            app.ListBox.Layout.Row = [2 7];
            app.ListBox.Layout.Column = 3;
            app.ListBox.Value = '';

            % Create pushSaveParam
            app.pushSaveParam = uibutton(app.GridLayout, 'push');
            app.pushSaveParam.ButtonPushedFcn = createCallbackFcn(app, @pushSaveParam_Callback, true);
            app.pushSaveParam.HorizontalAlignment = 'left';
            app.pushSaveParam.BackgroundColor = [1 1 1];
            app.pushSaveParam.FontName = 'Consolas';
            app.pushSaveParam.FontSize = 20;
            app.pushSaveParam.FontWeight = 'bold';
            app.pushSaveParam.Visible = 'off';
            app.pushSaveParam.Layout.Row = 3;
            app.pushSaveParam.Layout.Column = 4;
            app.pushSaveParam.Text = 'Save Parameters';

            % Create corrValues
            app.corrValues = uibutton(app.GridLayout, 'push');
            app.corrValues.ButtonPushedFcn = createCallbackFcn(app, @corrValues_Callback, true);
            app.corrValues.HorizontalAlignment = 'left';
            app.corrValues.BackgroundColor = [1 1 1];
            app.corrValues.FontName = 'Consolas';
            app.corrValues.FontSize = 20;
            app.corrValues.FontWeight = 'bold';
            app.corrValues.Visible = 'off';
            app.corrValues.Layout.Row = 4;
            app.corrValues.Layout.Column = 4;
            app.corrValues.Text = 'Correct Values';

            % Create pushFinish
            app.pushFinish = uibutton(app.GridLayout, 'push');
            app.pushFinish.ButtonPushedFcn = createCallbackFcn(app, @pushFinish_Callback, true);
            app.pushFinish.HorizontalAlignment = 'left';
            app.pushFinish.BackgroundColor = [1 1 1];
            app.pushFinish.FontName = 'Consolas';
            app.pushFinish.FontSize = 20;
            app.pushFinish.FontWeight = 'bold';
            app.pushFinish.Visible = 'off';
            app.pushFinish.Layout.Row = 6;
            app.pushFinish.Layout.Column = 4;
            app.pushFinish.Text = 'Finish !';

            % Create pushGoBack
            app.pushGoBack = uibutton(app.GridLayout, 'push');
            app.pushGoBack.ButtonPushedFcn = createCallbackFcn(app, @pushGoBack_Callback, true);
            app.pushGoBack.HorizontalAlignment = 'left';
            app.pushGoBack.BackgroundColor = [1 1 1];
            app.pushGoBack.FontName = 'Consolas';
            app.pushGoBack.FontSize = 19;
            app.pushGoBack.FontWeight = 'bold';
            app.pushGoBack.Visible = 'off';
            app.pushGoBack.Layout.Row = 5;
            app.pushGoBack.Layout.Column = 4;
            app.pushGoBack.Text = {'Go Back (to File Select.)'; ''};

            % Create repFile
            app.repFile = uibutton(app.GridLayout, 'push');
            app.repFile.ButtonPushedFcn = createCallbackFcn(app, @repFile_Callback, true);
            app.repFile.HorizontalAlignment = 'left';
            app.repFile.BackgroundColor = [1 1 1];
            app.repFile.FontName = 'Consolas';
            app.repFile.FontSize = 19;
            app.repFile.FontWeight = 'bold';
            app.repFile.Visible = 'off';
            app.repFile.Layout.Row = 5;
            app.repFile.Layout.Column = 4;
            app.repFile.Text = 'Add File(exisit. param.) ';

            % Create pushGenSet
            app.pushGenSet = uibutton(app.GridLayout, 'push');
            app.pushGenSet.ButtonPushedFcn = createCallbackFcn(app, @pushGenSet_Callback, true);
            app.pushGenSet.HorizontalAlignment = 'left';
            app.pushGenSet.BackgroundColor = [1 1 1];
            app.pushGenSet.FontName = 'Consolas';
            app.pushGenSet.FontSize = 20;
            app.pushGenSet.FontWeight = 'bold';
            app.pushGenSet.Visible = 'off';
            app.pushGenSet.Layout.Row = 2;
            app.pushGenSet.Layout.Column = 4;
            app.pushGenSet.Text = 'Pre-Process Data';

            % Create pushDone
            app.pushDone = uibutton(app.GridLayout, 'push');
            app.pushDone.ButtonPushedFcn = createCallbackFcn(app, @pushDone_Callback, true);
            app.pushDone.HorizontalAlignment = 'left';
            app.pushDone.BackgroundColor = [1 1 1];
            app.pushDone.FontName = 'Consolas';
            app.pushDone.FontSize = 20;
            app.pushDone.FontWeight = 'bold';
            app.pushDone.FontColor = [1 0 0];
            app.pushDone.Visible = 'off';
            app.pushDone.Layout.Row = 5;
            app.pushDone.Layout.Column = 4;
            app.pushDone.Text = 'Done ';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui_preProcessRaw_App_exported(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.figure1)

                % Execute the startup function
                runStartupFcn(app, @(app)gui_preProcessRaw_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.figure1)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure1)
        end
    end
end