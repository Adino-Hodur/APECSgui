function res2edf(paramEDF) %%% fNameRes,fNameEpoch,fNameFeatures,fOut)

%addpath(genpath('/Users/rosipal/MATLAB/EDF-Handling/'))

fNameRes      = [paramEDF.pathName,paramEDF.fileName];
fNameFeatures = [paramEDF.pathNameF,paramEDF.fileNameF];
%fOut          = [paramEDF.pathNameS,paramEDF.fNameS];
%%%% paremeters for re-scaling factors, reg. pred, etc.
reScale=false; %%% to rescale factor score before saving to EDF true / false 
minS = -100;
maxS =  100;


%load(fNameRes)
load(fNameFeatures,'header')
headerF = header;
clear header

for f=1:length(paramEDF.fileNameE)
    fNameEpoch    = [paramEDF.pathNameE,paramEDF.fileNameE{f}];
    fOut          = [paramEDF.pathNameS,paramEDF.fNameS{f}(1:end-4),'.edf'];
    %%% epochs file
    load(fNameEpoch)
    headerE = header;
    
    %%%% load results .... this is needed to upload each time 
    load(fNameRes)
    
    
    
    if headerE.lenOverlap == 0
        %%% features file
%         load(fNameFeatures,'header')
%         headerF = header;
%         clear header
        
        hW = waitbar(0,'Please wait .... Generating features....!!!') ;
        switch headerF.featureType
            case 'psd'
                %%%% generate spectral features
                [datXf] = genSpectra(datX,headerF);
            case 'coherence'
                [datXf] = genCoherence(datX,headerF);
            case 'ar'
        end
        close(hW)
        
        %%% select subset of data
        datXf{1}.testClass{1} = datXf{1}.X;
        datXf{1}.trainClass = [];
        datXf{1}.valClass   = [];
        datXf{1}  = rmfield(datXf{1},'X');
        [datXf]   = selSubData(param,datXf);
        
        
        %%%% preprocess bin
        %switch param.binProcess
        %    case 'Avg'
        [datXf]=processBin(param,datXf);
        %end
        
        % %%%%% remove noisy EEG channels
        % if isfield(param,'errorType') || isfield(param,'remArtifact')
        %     [datXf,datY,datErr]=removeNoise(datErr,datXf,datY,param);
        % end
        
        
        
        %%%%%% center data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(param.centerData,'yes')
            switch param.genMethod %%%% for 2D case
                case {'PCA','PARAFAC','NPLS','KPLS'}
                    for i=1:size(datXf{1}.testClass{1},1)
                        datXf{1}.testClass{1}(i,:)=datXf{1}.testClass{1}(i,:) - res.meanX{1};
                    end
            end
        end
        
        
        hW = waitbar(0,'Please wait .... projecting data to model ....') ;
        switch param.genMethod
            case 'NPLS'
                Xtest  = constNwayMatrix(datXf{1}.testClass,param);
                for pF=1:paramEDF.numNPLS2use
                    [ypred_test(:,pF),T_test] = npred (Xtest,pF,res.Xfactors,res.Yfactors,res.Core,res.B);
                    waitbar(pF/param.numFactors,hW)
                end
            case 'PARAFAC'
                Xtest  = constNwayMatrix(datXf{1}.testClass,param);
                if exist('res1','var') %%%% re-runPARAFAC - atoms removal
                    Xtest = reRunParafac(param,res,res1,Xtest);
                    if strcmp(param.reRunPARAFAC.centerData,'yes')
                        [Xtest]=do_centerReRun(Xtest,res1);
                        if isfield(res1,'meanX')
                            %%% here I  need to adjust meanX_remAtoms somehow
                        end
                    end
                    res=res1;
                end
                if isfield(paramEDF,'fac2use')
                    for f=1:length(res.Xfactors)
                        res.Xfactors{f}=res.Xfactors{f}(:,paramEDF.fac2use);
                    end
                end
                %%%% define which constraint to use 
                if exist('res1','var') %%%% re-runPARAFAC - atoms removal
                    parafacConst1=param.reRunPARAFAC.parafacConst(1);
                else
                    parafacConst1=param.parafacConst(1);
                end
                %%% compute test time scores 
                Xtest_tempAtom = PARAFAC_tempAtomEst(res.Xfactors,Xtest,parafacConst1);
                if isfield(res,'Xfactors1')
                    if isfield(paramEDF,'fac2use')
                        for f=1:length(res.Xfactors1)
                            res.Xfactors1{f}=res.Xfactors1{f}(:,paramEDF.fac2use);
                        end
                    end
                    Xtest_tempAtom1 = PARAFAC_tempAtomEst(res.Xfactors1,Xtest,parafacConst1);
                end
        end
        close(hW)
        
        %%%% now reconstruct back to continous !!!
        X = [];
        dimX = size(datX{1}.chan{1}.X);
        for i=1:length(headerE.Xlabels)
            X = [X , reshape(datX{1}.chan{i}.X',dimX(1)*dimX(2),1)];
        end
        
        chLabel = headerE.Xlabels; %%% all channels
        if isfield(param,'Xlabels2use')
            labels2use=param.Xlabels2use;
        else
            labels2use=param.Xlabels;
        end
        %     for i=1:length(labels2use) %% %add star to used channels
        %         ch = find(strcmp(chLabel,labels2use{i})==1);
        %         chLabel{ch}(end+1) = '*';
        %     end
        for i=1:length(chLabel) %% %add star to used channels
            if isempty(find(strcmp(labels2use,chLabel{i})==1))
                chLabel{i}(end+1) = '*';
            end
        end
        
        lenEpoch = headerE.sampleFreq*headerE.lenEpoch;
        
        
        switch param.genMethod
            case 'NPLS'
                S = zeros(size(X,1),paramEDF.numNPLS2use);
                for i=1:size(T_test,1)
                    bg =(i-1)*lenEpoch +1;
                    en = bg + lenEpoch -1;
                    for j=1:paramEDF.numNPLS2use
                        S(bg:en,j) = T_test(i,j);
                    end
                end
                if reScale
                    S = reScaleCol(S,minS,maxS);
                end
                for j=1:paramEDF.numNPLS2use
                    chLabel{end+1}= ['FS',int2str(j)];
                end
                X = [X , S];
                R = zeros(size(X,1),paramEDF.numNPLS2use);
                for i=1:size(ypred_test,1)
                    bg =(i-1)*lenEpoch +1;
                    en = bg + lenEpoch -1;
                    for j=1:paramEDF.numNPLS2use
                        R(bg:en,j) = ypred_test(i,j);
                    end
                end
                if reScale
                    R = reScaleCol(R,minS,maxS);
                end
                X = [X , R];
                for j=1:paramEDF.numNPLS2use
                    chLabel{end+1}= ['Reg',int2str(j)];
                end
            case 'PARAFAC'
                if isfield(paramEDF,'fac2use')
                    numFactors = length(paramEDF.fac2use);
                else
                    if isfield(param,'reRunPARAFAC')
                        numFactors = param.reRunPARAFAC.numFactors;
                    else
                        numFactors = param.numFactors;
                    end
                end
                S = zeros(size(X,1),numFactors);
                for i=1:size(Xtest_tempAtom,1)
                    bg =(i-1)*lenEpoch +1;
                    en = bg + lenEpoch -1;
                    for j=1:numFactors
                        S(bg:en,j) = Xtest_tempAtom(i,j);
                    end
                end
                if reScale
                    S = reScaleCol(S,minS,maxS);
                end
                X = [X , S];
                for j=1:numFactors
                    if isfield(paramEDF,'fac2use')
                        chLabel{end+1}= ['FSrun1_',int2str(paramEDF.fac2use(j))];
                    else
                        chLabel{end+1}= ['FSrun1_',int2str(j)];
                    end
                end
                if exist('Xtest_tempAtom1','var')
                    S = zeros(size(X,1),numFactors);
                    for i=1:size(Xtest_tempAtom1,1)
                        bg =(i-1)*lenEpoch +1;
                        en = bg + lenEpoch -1;
                        for j=1:numFactors
                            S(bg:en,j) = Xtest_tempAtom1(i,j);
                        end
                    end
                    if reScale
                        S = reScaleCol(S,minS,maxS);
                    end
                    X = [X , S];
                    for j=1:numFactors
                        if isfield(paramEDF,'fac2use')
                            chLabel{end+1}= ['FSrun2_',int2str(paramEDF.fac2use(j))];
                        else
                            chLabel{end+1}= ['FSrun2_',int2str(j)];
                        end
                    end
                end
        end
        
        if isfield(param,'remArtifact')
            chLabel{end+1}= 'Artifact';
            if (size(datErr{1}.artifact,2)-1) == length(datX{1}.chan)
                tE =  datErr{1}.artifact(:,1);
            elseif  size(datErr{1}.artifact,2) == length(datX{1}.chan)
                tE = sum(datErr{1}.artifact,2);
                ii = tE > 0;
                tE(ii) = 1;
            else
                hE = errordlg('Error s.t. wrong with artifacts .... They won''t be saved!!!', 'Artifact structure error');
                uiwait(hE)
            end
            if exist('tE','var')
                E = zeros(size(X,1),1);
                for i=1:length(tE)
                    bg =(i-1)*lenEpoch +1;
                    en = bg + lenEpoch -1;
                    E(bg:en,1) = tE(i);
                end 
                if reScale
                    E = reScaleCol(E,0,maxS);
                end
                X = [X , E];
            end
        end
        
        %%%%% saving to EDF %%%%%%
        %%% 1
        % header.patientID local patient identification data:  [patientID Sex(F or M) Birthdate (dd-MMM-yyyy) Name_name] default [X X X X]
        % example: NNN-0001 M 01-JAN-2000 Ivanov_Ivav_Ivanovich
        % or:
        % header.patient   structure of cells whith patient ID:
        % header.patient.ID     patient code, default XX
        % header.patient.Sex    Sex(F or M), default X
        % header.patient.BirthDate birthdate in dd-MMM-yyyy format using the English 3-character abbreviations of the month in capitals default 01-JAN-2000
        % header.patient.Name    patient name, defaul X
        
        
        %%% 2
        % header.recordID local recording identification data:  [Startdate dd-MMM-yyyy recordID technician_code equipment_code] default [Startdate X X X X]
        % example: Startdate 02-MAR-2002 PSG-1234/2002 Petrov_7180 Telemetry03
        % or:
        % header.record structure of cells whith record ID:
        % header.record.ID   hospital administration code of the investigation, default X
        % eader.record.Tech    code specifying the responsible investigator or technician , default X
        % header.record.Eq  code specifying the used equipment, default X
        
        %%% 3
        %    startdate of recording (dd.mm.yy)
        %    header.StartDate  , default = 01.01.00
        %%% 4
        %    starttime of recording (hh.mm.ss)
        %    header.StartTime  , default = 00.00.00
        % 5  header.duration        signal block duration in seconds, default =1
        headerEDF.labels = chLabel;       % - structure of cells with name of channels, by default there will be a numbering of channels
        % 7  header.transducer    - transducer type  or structure of cells with transducer type of channels, default=' '
        % 8  header.units         - physical dimension or structure of cells with  physical dimension of channels, default=' '
        % 9  header.prefilt       - prefiltering or structure of cells with prefiltering of channels, default=' ' -  HP:0.1Hz LP:75Hz N:50Hz
        %%% 10 Annotation
        headerEDF.annotation.event    =[]; % structure of cells whith event name
        headerEDF.annotation.duration =[]; %  vector with event duration (seconds)
        headerEDF.annotation.starttime=[]; %  vector with event startime  (seconds)
        
        headerEDF.samplerate = headerE.sampleFreq;
        
        SaveEDF(fOut,X,headerEDF);
        
        % clear res res1 param 
        
    else
        hE = errordlg('Error !!! ... At the moment the code is implemented for 0 overlap only','Overlap error');
        uiwait(hE);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [datX]=do_center(datX,meanX)

%%%% center X data

if isfield(datX{m},'testClass')
    for c=1:length(datX{m}.testClass)
        for i=1:size(datX{m}.testClass{c},1)
            datX{m}.testClass{c}(i,:)=datX{m}.testClass{c}(i,:) - meanX{m};
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = reScaleCol(x,a,b)

if nargin<2
    a = 0;
end
if nargin<3
    b = 1;
end

for i=1:size(x,2)
    m = min(x(:,i));
    M = max(x(:,i));
    
    if M-m<eps
        x(:,i) = x(:,i);
    elseif m==0
        c=a; 
        k=(b-c)/M; 
        x(:,i) = k * x(:,i) + c;
    else
        c = (b*m-a*M)/(m-M);
        k = (a - c)/m;
        x(:,i) = k * x(:,i) + c;
    end
end


%%%%% remove Atoms - parafac re-run !!!
function Xtest = reRunParafac(param,res,res1,Xtest)
%%% project the first PARAFAC (run1 or run2)
if isfield(param.reRunPARAFAC,'whichRun') && (param.reRunPARAFAC.whichRun==2)
    Xfactors=res.Xfactors1;
    Xtest_tempAtom = PARAFAC_tempAtomEst(Xfactors,Xtest,param.reRunPARAFAC.parafacConst(1));
else
    Xfactors=res.Xfactors;
    Xtest_tempAtom = PARAFAC_tempAtomEst(Xfactors,Xtest,param.reRunPARAFAC.parafacConst(1));
end

%%%%%
if strcmpi(param.reRunPARAFAC.keepResiduals,'yes')
    for i=1:length(Xfactors)
        remXfactors{i} = Xfactors{i}(:,param.reRunPARAFAC.atomsRemove);
    end
    %%% test
    testXfactors{1}=Xtest_tempAtom(:,param.reRunPARAFAC.atomsRemove);
    testXfactors{2}=remXfactors{2};
    testXfactors{3}=remXfactors{3};
    X1t=nmodel(testXfactors,[],param.reRunPARAFAC.Om);
end

keepAtoms = setdiff(1:param.numFactors,param.reRunPARAFAC.atomsRemove);
for i=1:length(Xfactors)
    Xfactors{i} = Xfactors{i}(:,keepAtoms);
end
switch param.reRunPARAFAC.keepResiduals
    case 'yes'
        %%% test set
        dimX=size(X1t);
        for d1=1:dimX(1)
            for d2=1:dimX(2)
                for d3=1:dimX(3)
                    Xtest(d1,d2,d3)= Xtest(d1,d2,d3)- X1t(d1,d2,d3); %%% X - X1
                end
            end
        end     
    case 'no'  %%% computed from kept atoms
        %%%% test set
        testXfactors{1}=Xtest_tempAtom(:,keepAtoms);
        testXfactors{2}=res1.Xfactors{2};
        testXfactors{3}=res1.Xfactors{3};
        Xtest=nmodel(testXfactors,[],param.reRunPARAFAC.Om);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xtest]=do_centerReRun(Xtest,res)

dimX = size(Xtest);
X = [];
for d1=1:dimX(1)
    pX(1:dimX(2),1:dimX(3))= Xtest(d1,:,:);
    X(d1,:)=reshape(pX',[1 dimX(2)*dimX(3)]);
end
for d1=1:dimX(1)
    X(d1,:)=X(d1,:) - res.meanX_remAtoms;
    Xtest(d1,1:dimX(2),1:dimX(3))=reshape(X(d1,:),[dimX(3),dimX(2)])';
end


