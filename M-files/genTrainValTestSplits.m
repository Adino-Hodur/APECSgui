function    genTrainValTestSplits(param)


fUseDatY        = false;
missingYError   = false; 

nClass=param.numClass;

hW = waitbar(0,'Please wait... creating the file  ... ');
for f=1:param.fileIndx
    fN=strcat(param.pathName{f},param.fileName{f});
    load(fN)
    
    %%%% check if datErr is still not channel based 
    fieldN =fieldnames(datErr{1});
    for fi=1:length(fieldN)
        if strcmp(fieldN{fi},'var')
            eval(['isCellF=iscell(datErr{1}.',fieldN{fi},');'])
            if isCellF
                msgbox('Merging  var errors to a single vector .....');
                eval(['lenF=length(datErr{1}.',fieldN{fi},');'])
                errM=[];
                for j=1:lenF
                    eval(['tE=datErr{1}.',fieldN{fi},'{j}.E;']);
                    errM=[errM,tE];
                end
                errM=sum(errM,2);
                errM(errM~=0)=1;
                eval(['datErr{1}.',fieldN{fi},'=errM;'])
            else
                eval(['isMat=size(datErr{1}.',fieldN{fi},',2);'])
                if isMat > 1
                    errM=[];
                    eval(['errM=sum(datErr{1}.',fieldN{fi},',2);'])
                    errM(errM~=0)=1;
                    eval(['datErr{1}.',fieldN{fi},'=errM;'])
                end
            end
        end
    end

    %%%% if classLabels you need to have datY
    if isfield(param,'classLabel')
        if length(unique(param.classLabel)) == 1            
            moreClassLabels = false;
        else
            fUseDatY = true;
            moreClassLabels = true; 
        end
    end
    if ~exist('datY','var') && fUseDatY
        if ~missingYError
            strMissingY={'File was not generated and saved becouse Y matrix with labels is missing in:'};
        end
        if ~sum(strcmp(strMissingY(1:end),param.fileName{f}))
            strMissingY=[strMissingY; param.fileName{f}];
        end
        missingYError=true;
    end
    
    
    if ~missingYError
        
        %%%% change datY class labels to follow param.classLabel
        if isfield(param,'classLabel')
            pY = nan(length(datY(:,1)),1);
            for c=1:length(param.classLabel)
                ii=[];
                for c1=1:length(param.classN{c})
                    ii=[ii ; find(datY(:,1) == param.classN{c}(c1))];
                end
                pY(ii)=param.classLabel(c);
            end
            %datY_origLabels=datY;
            %datY(:,1)=pY;
            datY=[pY datY]; 
        end 
        
        %%%% get number of sampels
        %%% here I assume the same number of samples in each modality datX{#}
        ffN=fieldnames(datX{1});
        if length(ffN) ~= 1
            error('There must be just one fieldname within a modality datX{#}. ...')
        else           
            nSamples = size(datX{1}.X,1); 
            if exist('datY','var')
                if nSamples ~= size(datY,1)
                    error('nSamples is not equal the length of datY')
                end
            end
        end
        
        %%%% resfuffle data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if param.reshuffle(f)
            if exist('datErr','var')
                errVarName=fieldnames(datErr{1}); 
            end 
            if isfield(param,'classLabel')
                for cl=1:length(param.classLabel)
                    ii=find(datY(:,1) == param.classLabel(cl)); 
                    pI=ii(randperm(length(ii))); 
                    datX{1}.X(ii,:)=datX{1}.X(pI,:);
                    %datY(ii,:)=datY(pI,:); %%% index Y is not changed 
                    if exist('errVarName','var')
                        for e=1:length(errVarName)
                            if ~strcmpi(errVarName{e},'excludeLaplacian')
                                strE=['datErr{1}.',errVarName{e},'(ii,:)=datErr{1}.',errVarName{e},'(pI,:);'];
                                eval(strE);
                            end
                        end 
                    end 
                end 
            else 
                pI=randperm(size(datY,1)); 
                datX{1}.X = datX{1}.X(pI,:);
                datY = datY(pI,:);
                if exist('errVarName','var')
                    for e=1:length(errVarName)
                        if ~strcmpi(errVarName{e},'excludeLaplacian')
                            strE=['datErr{1}.',errVarName{e},'=datErr{1}.',errVarName{e},'(pI,:);'];
                            eval(strE);
                        end
                    end
                end
            end 
        end  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        per=zeros(3,nClass);
        perS=false;segS=false;
        for c=1:nClass
            %%%% percentage
            if isfield(param.trainSet{f},'perClass')
                if length(param.trainSet{f}.perClass) >= c
                    per(1,c) =  param.trainSet{f}.perClass(c);
                    perS = true;
                end
            end
            if isfield(param.valSet{f},'perClass')
                if length(param.valSet{f}.perClass) >= c
                    per(2,c) =  param.valSet{f}.perClass(c);
                    perS=true;
                end
            end
            if isfield(param.testSet{f},'perClass')
                if length(param.testSet{f}.perClass) >= c
                    per(3,c) =  param.testSet{f}.perClass(c);
                    perS=true;
                end
            end
            if ~sum(per) %%% try segments if percentage []
                if isfield(param.trainSet{f},'segClass')
                    segS=true;
                    if size(param.trainSet{f}.segClass,1) >= c
                        seg{1}.class{c} =  param.trainSet{f}.segClass(c,:);
                    else
                        seg{1}.class{c}=[];
                    end
                end
                if isfield(param.valSet{f},'segClass')
                    segS=true;
                    if size(param.valSet{f}.segClass,1) >= c
                        seg{2}.class{c} =  param.valSet{f}.segClass(c,:);
                    else
                        seg{2}.class{c}=[];
                    end
                end
                if isfield(param.testSet{f},'segClass')
                    segS=true;
                    if size(param.testSet{f}.segClass,1) >= c
                        seg{3}.class{c} =  param.testSet{f}.segClass(c,:);
                    else
                        seg{3}.class{c}=[];
                    end
                end
            end
        end
        %%%%%
        if perS %%% needs to be more positive
            if isfield(param,'classLabel') && (length(unique(param.classLabel)) == 1)
                %%%% there are lebels but the same label for all classes
                %%%% select all data of this labels and run the code
                %%%% corresponding to no-labels
                ii=find(datY(:,1)==param.classLabel(1));
                datX{1}.X=datX{1}.X(ii,:);
                datY = datY(ii,:); %%% vsuvka
                fieldN =fieldnames(datErr{1});
                for fi=1:length(fieldN)
                    eval(['datErr{1}.',fieldN{fi},'=datErr{1}.',fieldN{fi},'(ii,:);']);
                end
            end
            if isfield(param,'classLabel')
                bgShift=1; %%% this is for classLabel & ~moreClassLabels
                for c=1:nClass
                    indY =  find(datY(:,1) == param.classLabel(c));
                    if isempty(indY)
                        onePerc = 0;
                    else
                        onePerc = length(indY)/100;
                    end
                    if (per(1,c) ~=0) && (floor(per(1,c)*onePerc) ~=0)
                        if moreClassLabels
                            train{c}.ind = indY([1 : floor(per(1,c)*onePerc)]);
                        else
                            train{c}.ind = indY([bgShift : bgShift + floor(per(1,c)*onePerc) - 1]);
                            bgShift = length(train{c}.ind)+1;
                        end
                        bg = length(train{c}.ind)+1;
                    else
                        train{c}.ind=[];
                        bg = 1;
                    end
                    if (per(2,c) ~=0) && (floor(per(2,c)*onePerc) ~=0)
                        if moreClassLabels
                            val{c}.ind   = indY([bg : (bg + floor(per(2,c)*onePerc) -1 )]);
                        else
                            val{c}.ind = indY([bgShift : bgShift + floor(per(2,c)*onePerc) - 1]);
                            bgShift = length(val{c}.ind)+1;
                        end
                        bg = length(val{c}.ind) + length(train{c}.ind) + 1;
                    else
                        val{c}.ind=[];
                    end
                    if (per(3,c) ~=0) && (floor(per(3,c)*onePerc) ~=0)
                        if moreClassLabels
                            test{c}.ind   = indY([bg : (bg + floor(per(3,c)*onePerc) -1 )]);
                        else
                            test{c}.ind = indY([bgShift : bgShift + floor(per(3,c)*onePerc) - 1]);
                            bgShift = length(test{c}.ind)+1;
                        end
                    else
                        test{c}.ind=[];
                    end
                end
            else
                bg=1;
                onePerc=size(datY,1)/100;
                for c=1:nClass
                    if (per(1,c) ~=0) && (floor(per(1,c)*onePerc) ~=0)
                        train{c}.ind = [bg : (bg + floor(per(1,c)*onePerc) -1 )];
                        bg = bg + length(train{c}.ind);
                    else
                        train{c}.ind=[];
                    end
                end
                for c=1:nClass
                    if (per(2,c) ~=0) && (floor(per(2,c)*onePerc) ~=0)
                        val{c}.ind   = [bg : (bg + floor(per(2,c)*onePerc) -1 )];
                        bg = bg + length(val{c}.ind);
                    else
                        val{c}.ind=[];
                    end
                end
                if (per(3,1) ~=0) && (floor(per(3,1)*onePerc) ~=0)
                    test{1}.ind   = [bg : (bg + floor(per(3,1)*onePerc) -1 )];
                else
                    test{1}.ind=[];
                end
            end
            if ~isfield(param,'classLabel') || ~moreClassLabels
                test=test(1);
            end
            datOneFileX = getDataX(datX,train,val,test,nClass);
            if exist('datErr','var')
                datOneFileErr = getDataErr(datErr,train,val,test,nClass);
            end
            if exist('datY','var')
                datOneFileY = getDataY(datY,train,val,test,nClass,f);
            end
            %           end
        elseif segS
            %%%%% tu je chyba ak overlap 0 .... ?
            if param.fileHeader{f}.lenOverlap
                switch param.fileHeader{f}.lenOverlapUnit
                    case 'msec'
                        stp= 1000/param.fileHeader{f}.lenOverlap;
                        switch param.fileHeader{f}.timeUnit                                                           
                            case 'min'
                                stp=60*stp;
                            case 'hour'
                                stp=60*60*stp;
                        end
                    case 'sec'
                        stp= 60/param.fileHeader{f}.lenOverlap;
                        switch param.fileHeader{f}.timeUnit
                            case 'hour'
                                stp=60*stp;
                        end
                    case 'min'
                        stp= 60/param.fileHeader{f}.lenOverlap;
                end
            else
                switch param.fileHeader{f}.lenEpochUnit
                    case 'msec'
                        stp= 1000/param.fileHeader{f}.lenEpoch;
                        switch param.fileHeader{f}.timeUnit
                            case 'min'
                                stp=60*stp;
                            case 'hour'
                                stp=60*60*stp;
                        end
                    case 'sec'
                        stp= 60/param.fileHeader{f}.lenEpoch;
                        switch param.fileHeader{f}.timeUnit
                            case 'hour'
                                stp=60*stp;
                        end
                    case 'min'
                        stp= 60/param.fileHeader{f}.lenEpoch;
                end
            end            
            for c=1:nClass
                if  ~isempty(seg{1}.class{c})
                    if seg{1}.class{c}(1)==0
                        bg = 1;
                    else
                        bg = ceil (stp*seg{1}.class{c}(1)) + 1;
                    end
                    en = min(floor(stp*seg{1}.class{c}(2)),nSamples);
                    if isfield(param,'classLabel') %&& moreClassLabels 
                        train{c}.ind =  find(datY(bg:en,1) == param.classLabel(c)) + bg - 1;
                    else
                        train{c}.ind =  (bg:en);
                    end
                else
                    train{c}.ind=[];
                end
                if  ~isempty(seg{2}.class{c})
                    if seg{2}.class{c}(1)==0
                        bg = 1;
                    else
                        bg = ceil (stp*seg{2}.class{c}(1)) + 1;
                    end
                    en = min(floor(stp*seg{2}.class{c}(2)),nSamples);
                    if isfield(param,'classLabel') %&& moreClassLabels
                        val{c}.ind =  find(datY(bg:en,1) == param.classLabel(c)) + bg - 1;
                    else
                        val{c}.ind =  (bg:en);
                    end
                else
                    val{c}.ind=[];
                end
                if  ~isempty(seg{3}.class{c})
                    if seg{3}.class{c}(1)==0
                        bg = 1;
                    else
                        bg = ceil (stp*seg{3}.class{c}(1)) + 1;
                    end
                    en = min(floor(stp*seg{3}.class{c}(2)),nSamples);
                    if isfield(param,'classLabel') %&& moreClassLabels
                        test{c}.ind =  find(datY(bg:en,1) == param.classLabel(c)) + bg -1;
                    else
                        test{c}.ind =  (bg:en);
                    end
                else
                    test{c}.ind=[];
                end
            end
            if ~isfield(param,'classLabel') || ~moreClassLabels %%% just one set for all classes 
                test=test(1);
            end
            datOneFileX = getDataX(datX,train,val,test,nClass);
            if exist('datErr','var')
                datOneFileErr = getDataErr(datErr,train,val,test,nClass);
            end
            if exist('datErr','var')
                datOneFileErr = getDataErr(datErr,train,val,test,nClass);
            end
            if exist('datY','var')
                datOneFileY = getDataY(datY,train,val,test,nClass,f);
            end
        else
            hE=errordlg(['S.t. wrong with ',param.fileName{f},'... neither percentage nor time segment selected !!!'],'Error while creating file ...');
            uiwait(hE); 
            close(hW); 
            return
        end
        train=[];test=[];val=[]; %%%% clear indexes
        %%%% add to datX and datY
        if f == 1 %%% first fileper
            DatX = datOneFileX;
            if exist('datOneFileErr','var')
                DatErr = datOneFileErr;
            end
            if exist('datOneFileY','var')
                DatY = datOneFileY;
            end
        else
            DatX = addFileDatX(DatX,datOneFileX);
            if exist('datOneFileErr','var')
                DatErr = addFileDatErr(DatErr,datOneFileErr);
            end
            if exist('datOneFileY','var')
                DatY = addFileDatY(DatY,datOneFileY,f);
            end
        end
        if exist('datErr','var')
            clear datX datY datErr datOneFileX datOneFileErr datOneFileY 
        else
            clear datX datY datOneFileX datOneFileY
        end
    end %%% endf if missingYError
    waitbar(f / param.fileIndx)
end %%% end f
close(hW)

%%%% check consistency

outStruct.consTesting = checkConsitency(DatX,param);

if missingYError
    outStruct.missingStr = strMissingY;
end
outStruct.missingY   = missingYError; 
outStruct.useY       = fUseDatY;

%%%% saving data
datX=DatX; 
datY=DatY; 
clear DatX DatY
if exist('DatErr','var')
    datErr=DatErr;
    clear DatErr
end

%%%%% remove the first column of indexes [-1 1]is classLabel
if isfield(param,'classLabel')
    if isfield(datY,'trainClass')
        for c=1:length(datY.trainClass)
            datY.trainClass{c}=datY.trainClass{c}(:,2:end);
        end
    end
    if isfield(datY,'valClass')
        for c=1:length(datY.valClass)
            datY.valClass{c}=datY.valClass{c}(:,2:end);
        end
    end
    if isfield(datY,'testClass')
        for c=1:length(datY.testClass)
            datY.testClass{c}=datY.testClass{c}(:,2:end);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if outStruct.missingY
    hE=errordlg(outStruct.missingStr,'Error - missing Y matrix');
    uiwait(hE);
elseif ~outStruct.consTesting.consTrainVal && ~outStruct.consTesting.consTest
    if ~isempty(param.fileNameGenSet)
        str=strcat(param.pathNameGenSet,param.fileNameGenSet);
        header = param;
        %%%% add sizes
        for cl=1:header.numClass
            header.XtrainSize{cl}=size(datX{1}.trainClass{cl});
            header.XvalSize{cl}=size(datX{1}.valClass{cl});
            header.YtrainSize{cl}=size(datY.trainClass{cl});
            header.YvalSize{cl}=size(datY.valClass{cl});
        end
        for cl=1:length(datX{1}.testClass)
            header.XtestSize{cl}=size(datX{1}.testClass{cl});
            header.YtestSize{cl}=size(datY.testClass{cl});
        end
        if exist('datErr','var')
            if isfield(datErr{1},'artifact')
                header.artifactLabel = true;
            end
            if isfield(datErr{1},'excludeLaplacian')
                header.excludeLaplacian = datErr{1}.excludeLaplacian;
            end
            
            % SPECIAL CONDITIONAL: prevents file corruption for batch.
            if isfield(param, 'receipt')
                save(str,'datX','datY','datErr','header');
            else
                save(str,'datX','datY','datErr','header', '-v7.3');
            end
            
        else
            save(str,'datX','datY','header','-v7.3');
        end
        % SPECIAL CONDITIONAL: never opens msgbox in batch.
        if ~isfield(param, 'receipt')
            hM=msgbox('Great !!! File was generated and saved.','File saved');
            uiwait(hM);
        end
    else
        hM=msgbox('File was not saved. File name missing!','File not saved','error');
        uiwait(hM);
    end
elseif outStruct.consTesting.consTrainVal
    str=[{'File not saved becouse of train-val set(s) inconsitancy!!!'};outStruct.consTesting.strTrainVal];
    hM=msgbox(str,'Class inconsistancy','error');
    uiwait(hM);
elseif ~outStruct.consTesting.consTrainVal && outStruct.consTesting.consTest
    str=[{'Test set(s) inconsistancy!!!'};outStruct.consTesting.strTest;{'----------------------'}; ...
        {'SAVE DATA ANYWAY?'}];
    hC=questdlg(str,'Test set(s) inconsitancy','yes','no','no');
    switch hC
        case 'yes'
            str=strcat(param.pathNameGenSet,param.fileNameGenSet);
            header = param;
            %%%% add sizes
            for cl=1:header.numClass
                header.XtrainSize{cl}=size(datX{1}.trainClass{cl});
                header.XvalSize{cl}=size(datX{1}.valClass{cl});
                header.YtrainSize{cl}=size(datY.trainClass{cl});
                header.YvalSize{cl}=size(datY.valClass{cl});
            end
            for cl=1:length(datX{1}.testClass)
                header.XtestSize{cl}=size(datX{1}.testClass{cl});
                header.YtestSize{cl}=size(datY.testClass{cl});
            end
            if exist('datErr','var')
                if isfield(datErr{1},'artifact')
                    header.artifactLabel = true;
                end
                if isfield(datErr{1},'excludeLaplacian')
                    header.excludeLaplacian = datErr{1}.excludeLaplacian;
                end
                save(str,'datX','datY','datErr','header');
            else
                save(str,'datX','datY','header');
            end
            hM=msgbox('Great !!! File was generated and saved.','File saved');
            uiwait(hM);
    end
    
end

   
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = getDataX(X,train,val,test,nClass)

elemX  = length(X); 

for i=1:elemX
    fN=fieldnames(X{i});
    if length(fN) ~= 1
        error('There must be just one fieldname within a modality datX{#}.  ...')
    else
        fN=fN{1}; %%% this will move from cell to string 
        str = strcat('pX = X{',int2str(i),'}.',fN,';');        
        eval(str);
        for c = 1:nClass
            if ~isempty(train{c}.ind)                
                dat{i}.trainClass{c}= pX(train{c}.ind,:);
            else                
                dat{i}.trainClass{c} = [];
            end
        end
        for c = 1:nClass
            if ~isempty(val{c}.ind)
                dat{i}.valClass{c}= pX(val{c}.ind,:);
            else
                dat{i}.valClass{c} = [];
            end
        end
        for c = 1:nClass
            if length(test)>=c
                if ~isempty(test{c}.ind)
                    dat{i}.testClass{c}= pX(test{c}.ind,:);
                else
                    dat{i}.testClass{c} = [];
                end
            end
        end
    end
end

function dat = getDataErr(X,train,val,test,nClass) 

elemX  = length(X); 

for i=1:elemX
    fNames=fieldnames(X{i});
    for f=1:length(fNames)
        if ~strcmpi(fNames{f},'excludeLaplacian')
            fN=fNames{f};
            eval(['pX = X{',int2str(i),'}.',fN,';']);
            for c = 1:nClass
                if ~isempty(train{c}.ind)
                    trainClass{c}= pX(train{c}.ind,:);
                else
                    trainClass{c} = [];
                end
            end
            for c = 1:nClass
                if ~isempty(val{c}.ind)
                    valClass{c}= pX(val{c}.ind,:);
                else
                    valClass{c} = [];
                end
            end
            for c = 1:nClass
                if length(test)>=c
                    if ~isempty(test{c}.ind)
                        testClass{c}= pX(test{c}.ind,:);
                    else
                        testClass{c} = [];
                    end
                end
            end
            str=strcat('dat{i}.',fN,'.trainClass = trainClass;');
            eval(str);
            str=strcat('dat{i}.',fN,'.valClass = valClass;');
            eval(str);
            str=strcat('dat{i}.',fN,'.testClass = testClass;');
            eval(str);
        else
            dat{i}.excludeLaplacian=X{i}.excludeLaplacian;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function datY = getDataY(Y,train,val,test,nClass,f)

for c = 1:nClass
    if ~isempty(train{c}.ind)
        datY.trainClass{c}    = Y(train{c}.ind,:);
        datY.trainClassInd{c} = ones(length(train{c}.ind),1)*f; 
    else
        datY.trainClass{c}    = [];
        datY.trainClassInd{c} = [];         
    end
    if ~isempty(val{c}.ind)
        datY.valClass{c}    = Y(val{c}.ind,:);
        datY.valClassInd{c} = ones(length(val{c}.ind),1)*f; 
    else
        datY.valClass{c}    = [];
        datY.valClassInd{c} = []; 
    end
    if length(test)>=c
        if ~isempty(test{c}.ind)
            datY.testClass{c}     = Y(test{c}.ind,:);
            datY.testClassInd{c} = ones(length(test{c}.ind),1)*f; 
        else
            datY.testClass{c}    = [];
            datY.testClassInd{c} = []; 
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = addFileDatX(dat,tmpDat)

elemX = length(dat); 

for i=1:elemX 
    nClass = length(dat{i}.trainClass); 
    if nClass ~= length(tmpDat{i}.trainClass)
        error('Error while merging data X: different sizes of classes ....') 
    else 
            for c=1:nClass                
                dat{i}.trainClass{c}= ... 
                    [dat{i}.trainClass{c}; tmpDat{i}.trainClass{c}]; 
                dat{i}.valClass{c}= ... 
                    [dat{i}.valClass{c}; tmpDat{i}.valClass{c}];
                if length(tmpDat{i}.testClass) >= c
                    dat{i}.testClass{c}= ...
                        [dat{i}.testClass{c}; tmpDat{i}.testClass{c}];
                end
            end 
    end 
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = addFileDatErr(dat,tmpDat)

elemX = length(dat); 

for i=1:elemX
    fNames=fieldnames(dat{i});
    for f=1:length(fNames)
        if ~strcmpi(fNames{f},'excludeLaplacian')
            fN=fNames{f};
            str=strcat('trainClass=dat{i}.',fN,'.trainClass;');
            eval(str);
            str=strcat('valClass=dat{i}.',fN,'.valClass;');
            eval(str)
            str=strcat('testClass=dat{i}.',fN,'.testClass;');
            eval(str)
            str=strcat('tmp_trainClass=tmpDat{i}.',fN,'.trainClass;');
            eval(str);
            str=strcat('tmp_valClass=tmpDat{i}.',fN,'.valClass;');
            eval(str)
            str=strcat('tmp_testClass=tmpDat{i}.',fN,'.testClass;');
            eval(str)
            
            nClass = length(trainClass);
            
            if nClass ~= length(tmp_trainClass) %#ok<USENS>
                error('Error while merging data X: different sizes of classes ....')
            else
                for c=1:nClass
                    trainClass{c}= ...
                        [trainClass{c}; tmp_trainClass{c}];
                    valClass{c}= ...
                        [valClass{c}; tmp_valClass{c}];
                    if length(tmp_testClass) >= c
                        testClass{c}= ...
                            [testClass{c}; tmp_testClass{c}];
                    end
                end
            end
            str=strcat('dat{i}.',fN,'.trainClass=trainClass;');
            eval(str);
            str=strcat('dat{i}.',fN,'.valClass=valClass;');
            eval(str)
            str=strcat('dat{i}.',fN,'.testClass=testClass;');
            eval(str)
        else   
            dat{i}.excludeLaplacian=unique([dat{i}.excludeLaplacian tmpDat{i}.excludeLaplacian]);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dat = addFileDatY(dat,tmpDat,f)

nClass = length(dat.trainClass);
%%%% this runs only one-time 
if ~isfield(dat,'trainClassInd')
    for c=1:nClass
        dat.trainClassInd{c} = [];
        dat.valClassInd{c}   = [];
        if length(tmpDat.testClass) >=c
            dat.testClassInd{c} =[];
        end
    end
end

if  nClass ~= length(tmpDat.trainClass);
    error('Error while merging data X: different sizes of classes ....')
else
    for c=1:nClass
        dat.trainClass{c}    = [dat.trainClass{c}   ; tmpDat.trainClass{c}]; 
        if ~isempty(tmpDat.trainClass{c})
            dat.trainClassInd{c} = [dat.trainClassInd{c}; ones(size(tmpDat.trainClass{c},1),1)*f];
        end
        dat.valClass{c}      = [dat.valClass{c}     ; tmpDat.valClass{c}];
        if ~isempty(tmpDat.valClass{c})
            dat.valClassInd{c}   = [dat.valClassInd{c}  ; ones(size(tmpDat.valClass{c},1),1)*f];
        end
        if length(tmpDat.testClass) >=c
            dat.testClass{c}    = [dat.testClass{c}    ; tmpDat.testClass{c}];
            if ~isempty(tmpDat.testClass{c})
                dat.testClassInd{c} = [dat.testClassInd{c} ; ones(size(tmpDat.testClass{c},1),1)*f];
            end
        end
    end
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  res = checkConsitency(dat,param) 

fGlobal     = false; %%% train & val sets  consistent 
fGlobalTst  = false; %%% test set consistent  
elemX = length(dat);

strTst={'----------------------'};
strTV ={'----------------------'};

if isfield(param,'classLabel')
    if length(unique(param.classLabel)) == 1        
        moreClassLabels = false;
    else        
        moreClassLabels = true;
    end
end


for i=1:elemX
    fC=false;
    fCtst=false;  
    %nClass = length(dat{i}.train{1}.class);  
    nClass = length(dat{i}.trainClass);        
    strP   = strcat('Inconsistancy for modality:',int2str(i));     
    strP1  = strcat('Number of classes: ',int2str(nClass));     
    strTst = [strTst; {strP} ; {strP1} ; {'The following sets are empty:'}];   
    strTV  = [strTV ; {strP} ; {strP1} ; {'The following sets are empty:'}];   
      
    indEmp=zeros(2,nClass); 
    if isfield(param,'classLabel')
        indEmpTst = zeros(1,nClass);
    else
        indEmpTst = zeros(1,1);
    end
    for c=1:nClass
%         if isempty(dat{i}.train{1}.class{c})
%             indEmp(1,c)=1;
%         end
%         if isempty(dat{i}.val{1}.class{c})
%             indEmp(2,c)=1;
%         end
        if isempty(dat{i}.trainClass{c})
            indEmp(1,c)=1;
        end
        if isempty(dat{i}.valClass{c})
            indEmp(2,c)=1;
        end
    end
    if isfield(param,'classLabel') && moreClassLabels
        for c=1:nClass
%             if isempty(dat{i}.test{1}.class{c})
%                 indEmpTst(1,c)=1;
%             end
            if isempty(dat{i}.testClass{c})
                indEmpTst(1,c)=1;
            end
        end
    else
%         if isempty(dat{i}.test{1}.class{1})
%             indEmpTst(1,1)=1;
%         end
        if isempty(dat{i}.testClass{1})
            indEmpTst(1,1)=1;
        end
    end
    %%%% train
    if ~((sum(indEmp(1,:)) == nClass) || (sum(indEmp(1,:)) == 0))
        fC = true ; 
        ii=find(indEmp(1,:) == 1);
        str=strcat('train set - ');
        for j=1:length(ii)
            str=strcat(str,' class',int2str(ii(j)),',');
        end
        str=str(1:end-1);  
        strTV=[strTV ; str]; 
    end
    %%%% val
    if ~((sum(indEmp(2,:)) == nClass) || (sum(indEmp(2,:)) == 0))
        fC = true ; 
        ii=find(indEmp(2,:) == 1);
        str=strcat('val set - ');
        for j=1:length(ii)
            str=strcat(str,' class',int2str(ii(j)),',');
        end
        str=str(1:end-1);  
        strTV=[strTV ; str]; 
    end
    %%% test 
    if isfield(param,'classLabel') && moreClassLabels
        if ~((sum(indEmpTst(1,:)) == nClass) || (sum(indEmpTst(1,:)) == 0))
            fCtst = true ;
            ii=find(indEmp(3,:) == 1);
            str=strcat('test set - ');
            for j=1:length(ii)
                str=strcat(str,' class',int2str(ii(j)),',');
            end
            str=str(1:end-1);
            strTst=[strTst ; str];
        end
    else
        if indEmpTst(1,1) == 1
            fCtst = true ;
            str=strcat('test set is empty');          
            strTst=[strTst ; str];
        end   
    end
     
    if fC
        fGlobal=true; 
        strTV=[strTV; {'----------------------'}];       
    end    
    if fCtst
        strTst=[strTst; {'----------------------'}];          
        fGlobalTst = true;
    end
end 

res.consTrainVal = fGlobal; 
res.strTrainVal  = strTV; 
res.consTest     = fGlobalTst;
res.strTest      = strTst;  



