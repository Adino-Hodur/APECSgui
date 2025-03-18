% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [hF,res1]=reRunPARAFAC(res1,param)


res=res1; %%% keep original res for saving  

param.reRunPARAFAC.Om = 2; %%% parameter for nmodel 

hW = waitbar(0,'Please wait .... training the model ....') ;
nWbar = 2; 

%%% handle for figure to close after finish 
hF = []; 

fN=strcat(param.pathName,param.fileName); 
if isunix || ismac %%% change all \ to /
    fN(strfind(fN,'\'))='/';
end
load(fN); 

switch param.genMethod       
    case 'PARAFAC' 
%X0=res1.Xtrain; 
        if (param.reRunPARAFAC.parafacPrctRemove == 2)
            res1.Xfactors=res1.Xfactors1;
            res1.Xtrain=res1.Xtrain1;
            if isfield(res1,'Xval1')
                res1.Xval=res1.Xval1;
            end
            if isfield(res1,'Xtest1')
                res1.Xtest=res1.Xtest1;
            end
            if isfield(res1,'Xval_tempAtom1')
                res1.Xval_tempAtom=res1.Xval_tempAtom1;
            end 
            if isfield(res1,'Xtest_tempAtom1')               
                res1.Xtest_tempAtom=res1.Xtest_tempAtom1;
            end 
        end
        if isfield(res1,'Xfactors1') && (param.reRunPARAFAC.parafacPrctRemove == 0)
            fieldN=fieldnames(res1); 
            for j=1:length(fieldN) 
                if fieldN{j}(end)=='1'
                    res1=rmfield(res1,fieldN{j});
                end 
            end             
        end
        
        %%% remove ATOMS 
        %%% -----------
        switch  param.reRunPARAFAC.projectType
            case 'spatial'
                disp('spatial')
                modeN=2; 
                if length(param.var2use)~= size(res1.Xfactors{modeN},1)
                    error('PARAFAC mode 2 is not spatial mode!!!')
                end 
                Q=res1.Xfactors{modeN}(:,param.reRunPARAFAC.atomsRemove);
                Pm=eye(size(Q,1))-Q*pinv(Q); 
                res1.Xtrain = nmodeproduct(res1.Xtrain,Pm,modeN);
                res1.Xtest  = nmodeproduct(res1.Xtest,Pm,modeN);
            case 'allmodes'
                if strcmpi(param.reRunPARAFAC.keepResiduals,'yes')
                    for i=1:length(res1.Xfactors)
                        remXfactors{i} = res1.Xfactors{i}(:,param.reRunPARAFAC.atomsRemove);
                    end
                    X1 = nmodel(remXfactors,[],param.reRunPARAFAC.Om);
                    %%% test
                    if isfield(res1,'Xtest_tempAtom')
                        testXfactors{1}=res1.Xtest_tempAtom(:,param.reRunPARAFAC.atomsRemove);
                        testXfactors{2}=remXfactors{2};
                        testXfactors{3}=remXfactors{3};
                        X1t=nmodel(testXfactors,[],param.reRunPARAFAC.Om);
                    end
                end
                
                keepAtoms = setdiff(1:param.numFactors,param.reRunPARAFAC.atomsRemove);
                for i=1:length(res1.Xfactors)
                    res1.Xfactors{i} = res1.Xfactors{i}(:,keepAtoms);
                end
                switch param.reRunPARAFAC.keepResiduals
                    case 'yes'
                        dimX=size(X1);
                        for d1=1:dimX(1)
                            for d2=1:dimX(2)
                                for d3=1:dimX(3)
                                    res1.Xtrain(d1,d2,d3)= res1.Xtrain(d1,d2,d3)- X1(d1,d2,d3); %%% X - X1
                                end
                            end
                        end
                        if isfield(res1,'Xtest_tempAtom')
                            %%% test set
                            dimX=size(X1t);
                            for d1=1:dimX(1)
                                for d2=1:dimX(2)
                                    for d3=1:dimX(3)
                                        res1.Xtest(d1,d2,d3)= res1.Xtest(d1,d2,d3)- X1t(d1,d2,d3); %%% X - X1
                                    end
                                end
                            end
                        end
                    case 'no'  %%% computed from kept atoms
                        res1.Xtrain= nmodel(res1.Xfactors,[],param.reRunPARAFAC.Om);
                        %%%% test set
                        if isfield(res1,'Xtest_tempAtom')
                            testXfactors{1}=res1.Xtest_tempAtom(:,keepAtoms);
                            testXfactors{2}=res1.Xfactors{2};
                            testXfactors{3}=res1.Xfactors{3};
                            res1.Xtest=nmodel(testXfactors,[],param.reRunPARAFAC.Om);
                        end
                end
        end
        
%nX=res1.Xtrain; 
%%if strcmpi(param.reRunPARAFAC.keepResiduals,'no')
%    X1=nX;
%%end
%save tmp X0 nX X1
        %%% center data  
        
        if strcmp(param.reRunPARAFAC.centerData,'yes')
           [res1]=do_center(res1); 
           if isfield(res1,'meanX')
               %%% here I  need to adjust meanX_remAtoms somehow               
           end 
        end 
     
        [res1.Xfactors,res1.it,res1.err]= parafac(res1.Xtrain,param.reRunPARAFAC.numFactors, ... 
                                                  param.reRunPARAFAC.parafacOpt,param.reRunPARAFAC.parafacConst);
        disp('First PARAFAC done .... ')
        
        res1 = getParafacCharact(res1.Xtrain,res1,[]);
        
        if param.reRunPARAFAC.parafacPrctRemove
            ii=find(res1.varian{1} <= prctile(res1.varian{1},100-param.reRunPARAFAC.parafacPrctRemove)  &  ...
                res1.lev{1} <= prctile(res1.lev{1},100-param.reRunPARAFAC.parafacPrctRemove));
            res1.Xtrain1=res1.Xtrain(ii,:,:);
            if isfield(res1,'YtrainFileInd')
                res1.YtrainFileInd1=res1.YtrainFileInd(ii,:,:);
            end
            %datY.trainClass1{1} = datY.trainClass{1}(ii,1);
            [res1.Xfactors1,res1.it1,res1.err1,res1.Corcondia1]= parafac(res1.Xtrain1,param.reRunPARAFAC.numFactors, ...
                param.reRunPARAFAC.parafacOpt,param.reRunPARAFAC.parafacConst);
        end
        delete temp.mat
        
        fprintf('################################ \n'); 
        fprintf('Core consitency, 1st run: %2.2f  \n', res1.Corcondia); 
        if isfield(res1,'Corcondia1') 
            fprintf('Core consitency, 2st run: %2.2f  \n', res1.Corcondia1); 
        end 
        
        waitbar(1/nWbar,hW)
        
        %%%%% est. test temporal atom if exist
        if ~isempty(res1.Xtest)
            % computations take place here
            res1.Xtest_tempAtom = PARAFAC_tempAtomEst(res1.Xfactors,res1.Xtest,param.reRunPARAFAC.parafacConst(1));
            if isfield(res1,'Xfactors1')
                res1.Xtest_tempAtom1 = PARAFAC_tempAtomEst(res1.Xfactors1,res1.Xtest,param.reRunPARAFAC.parafacConst(1));
            end
        end
end

%%% --- begin modifications ---
% saving after plot

% if ~isempty(param.reRunPARAFAC.resultsName)
%     save(param.reRunPARAFAC.resultsName,'res','res1','param');
% end

%%% --- end modification ---

close(hW)

%%%% here I need to change some of the first level param by param.reRunPARAFAC for plotting 
paramTMP = param; 
paramTMP.numFactors = param.reRunPARAFAC.numFactors; 
paramTMP.parafacPrctRemove =  param.reRunPARAFAC.parafacPrctRemove;
paramTMP.atomsRemoved = true; 
%paramTMP.centerData =  param.reRunPARAFAC.centerData;

if isfield(param,'plotFileName')
    plotStr=['[hF] = ',param.plotFileName(1:end-2),'(res1,paramTMP);'];
    eval(plotStr);
else
    hF=managePlots(paramTMP,res1,fN);
end

%%% --- begin modifications ---
% saving after ploting

if strfind(param.fileName,'data_')
    pozF=strfind(param.fileName,'_');
    strFile=strcat('./Results/removedAtoms_res',param.genMethod,param.fileName(pozF(1):end));
else
    strFile=strcat('./Results/removedAtoms_res',param.genMethod);
end

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
    'Save results as ...',strFile);
pathName=getRelPath(pathName);

% --- not sure if it is relevant somewhere
global paramRunApp
% ----------------------------

if pathName
    if fName
        param.reRunPARAFAC.resultsName = strcat(pathName,fName);
        paramRunApp.reRunPARAFAC.resultsName = strcat(pathName,fName);
    else
        param.reRunPARAFAC.resultsName = [];
        paramRunApp.reRunPARAFAC.resultsName = [];
    end
end

if ~isempty(param.reRunPARAFAC.resultsName)
    save(param.reRunPARAFAC.resultsName,'res','res1','param');
end

%%% --- end modifications ---


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [res]=do_center(res)

%%%% train
dimX = size(res.Xtrain);
X = [];
for d1=1:dimX(1)
    pX(1:dimX(2),1:dimX(3))= res.Xtrain(d1,:,:);
    X(d1,:)=reshape(pX',[1 dimX(2)*dimX(3)]);
end
res.meanX_remAtoms=mean(X);
for d1=1:dimX(1)
    X(d1,:)=X(d1,:)-res.meanX_remAtoms;
    res.Xtrain(d1,1:dimX(2),1:dimX(3))=reshape(X(d1,:),[dimX(3),dimX(2)])';
end

%%%% val part
if isfield(res,'Xval')
    dimX = size(res.Xval);
    X = [];
    for d1=1:dimX(1)
        pX(1:dimX(2),1:dimX(3))= res.Xval(d1,:,:);
        X(d1,:)=reshape(pX',[1 dimX(2)*dimX(3)]);
    end
    for d1=1:dimX(1)
        X(d1,:)=X(d1,:)-res.meanX_remAtoms;
        res.Xval(d1,1:dimX(2),1:dimX(3))=reshape(X(d1,:),[dimX(3),dimX(2)])';
    end
end
    
%%%% test part
if isfield(res,'Xtest')
    dimX = size(res.Xtest);
    X = [];
    for d1=1:dimX(1)
        pX(1:dimX(2),1:dimX(3))= res.Xtest(d1,:,:);
        X(d1,:)=reshape(pX',[1 dimX(2)*dimX(3)]);
    end
    for d1=1:dimX(1)
        X(d1,:)=X(d1,:)-res.meanX_remAtoms;
        res.Xtest(d1,1:dimX(2),1:dimX(3))=reshape(X(d1,:),[dimX(3),dimX(2)])';
    end
end

function mnX=getMean(X,addMnX)

dimX = size(X);
tX = [];
for d1=1:dimX(1)
    pX(1:dimX(2),1:dimX(3))= X(d1,:,:);    
    tX(d1,:)=reshape(pX',[1 dimX(2)*dimX(3)]);
    tX(d1,:)=tX(d1,:) + addMnX;
end
mnX=mean(tX);


