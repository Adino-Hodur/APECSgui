% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [hF,res]=runApp(param)

hW = waitbar(0,'Please wait .... training the model ....') ;
nWbar = 2; 

%%% handle for figure to close after finish 
hF = []; 

%%%% load data 
fN=strcat(param.pathName,param.fileName); 
load(fN); 

%%%%% select electrode pairs
%%%%%%% if electrode-pairs decide which to use; e.g. the case of coherence
if isfield(param,'origXlabels')
    param=selectPairs(param,hW);
end

%%%%% select only subest of channels  ....
if exist('datErr','var')
    [datX,datErr] = selSubData(param,datX,datErr);
else
    [datX] = selSubData(param,datX);
end
    

%%%% preprocess bin, process bins and select only specific ranges 
%switch param.binProcess 
%   case {'Avg','RelAvg','RelSpect'}
        [datX]=processBin(param,datX);
%end 

%%%%% remove noisy EEG channels 
if isfield(param,'errorType') || isfield(param,'remArtifact')
    [datX,datY,datErr]=removeNoise(datErr,datX,datY,param);
end

%%%% create Y matrix
%%%% mozno tu staci jeden switch ..... podmienka length(datX{1}.trainClass)
% %%%% > 1 je asi splnene aj pre NPLS KPLS ....? 
% switch param.genMethod %%%% for 2D case
%     case {'PCA','PARAFAC'}
%         if length(datX{1}.trainClass) > 1
% %             if isfield(param,'classLabel')
% %                 res.Ytrain = [];
% %                 res.Ytest  = [];
% %                 for c=1:param.numClass
% %                     res.Ytrain = [res.Ytrain ; datY.trainClass{c}(:,1)]; % the first column, so far binary only !!!
% %                     res.Ytest  = [res.Ytest  ; datY.testClass{c}(:,1)];  % the first column, so far binary only !!!
% %                 end
% %             else
%                 [res.Ytrain, res.Ytest]  = constY(datX{1},datY,param);
%  %           end
%         end
%     case {'NPLS','KPLS'}
% %         if isfield(param,'classLabel')
% %             res.Ytrain = [];
% %             res.Ytest  = [];
% %             for c=1:param.numClass
% %                 res.Ytrain = [res.Ytrain ; datY.trainClass{c}(:,1)]; % the first column, so far binary only !!!
% %                 res.Ytest  = [res.Ytest  ; datY.testClass{c}(:,1)];  % the first column, so far binary only !!!
% %             end
% %         else
%             [res.Ytrain, res.Ytest]  = constY(datX{1},datY,param);
% %       end
% end
[res.Ytrain, res.Ytest]  = constY(datX{1},datY,param);

%%%%%% center data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(param.centerData,'yes') | ~strcmp(param.centerData,'000')
    switch param.genMethod %%%% for 2D case
        case {'PCA','KPLS','PARAFAC','NPLS'}
            %[datX,datY,res.meanX,res.meanY] = do_center(datX,datY);
            [datX,res.meanX] = do_centerX(datX,param);
            %%%% center Y
            res.meanY=mean(res.Ytrain);
            res.Ytrain=res.Ytrain-res.meanY;
            res.Ytest=res.Ytest-res.meanY;
            %             if isfield(param,'classLabel') %%% center the first column only
            %                 [datY] = do_centerY(datY,res.meanY);
            %             end
            
    end
end

%%%%% Scale/normalize data if required %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(param,'scaleData')
    datX=do_scaleX(datX,param);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Average epochs indexed by 'paramNpls.workload', average is given by the
% %%% rate nEpochs=round(paramNpls.time / param.numSecsPerEpoch)
% if isfield(param,'avgEpochs')
%     [datX] = avg_sel_epochs(datX,param);
% end 
   

%%%% merging file class indexes 
if isfield(datY,'trainClassInd')
    res.YtrainFileInd = []; 
    res.YvalFileInd = [];
    for c=1:length(datY.trainClassInd)
        res.YtrainFileInd = [res.YtrainFileInd ; datY.trainClassInd{c}];   
        res.YvalFileInd = [res.YvalFileInd ; datY.valClassInd{c}];       
    end
end

if isfield(datY,'testClassInd')    
    res.YtestFileInd = [];
    for c=1:length(datY.testClassInd)        
        res.YtestFileInd  = [res.YtestFileInd  ; datY.testClassInd{c}];
    end
end

switch param.genMethod
    case 'PCA'
        %%% if more than one class merge them together, but keep Ylabels
%         if length(datX{1}.trainClass) > 1
%             if isfield(param,'classLabel')
%                 res.Ytrain = [];
%                 res.Ytest  = [];
%                 for c=1:param.numClass
%                     res.Ytrain = [res.Ytrain ; datY.trainClass{c}(:,1)]; % the first column, so far binary only !!! 
%                     res.Ytest  = [res.Ytest  ; datY.testClass{c}(:,1)];  % the first column, so far binary only !!! 
%                 end
%             else
%                 [res.Ytrain, res.Ytest]  = constY(datX{1},datY,param);
%             end
%             %%%%% merge X now
%             [datX{1} datY]=mergeClass(datX{1},datY);
%         end
        res.Xtrain = datX{1}.trainClass;
        res.Xtest  = datX{1}.testClass;
        
        %%%% this is how pcacov works
        [u,latent,coeff] = svd(cov(res.Xtrain));
        latent = diag(latent);
        res.eigValues = latent(1:param.numFactors);
        totalvar = sum(latent);
        res.expVarPCA = 100*res.eigValues/totalvar;
        res.Xfactors{2} = coeff(:,1:param.numFactors);
        clear coeff u latent
        res.Xfactors{1} = res.Xtrain* res.Xfactors{2};
        if ~isempty(res.Xtest)
            res.Xtest_tempAtom = res.Xtest * res.Xfactors{2};
        end
        
    case 'PARAFAC'
        %%% if more than one class merge them together, but keep Ylabels
%         if length(datX{1}.trainClass) > 1
%             if isfield(param,'classLabel')
%                 res.Ytrain = [];
%                 res.Ytest  = [];
%                 for c=1:param.numClass
%                     res.Ytrain = [res.Ytrain ; datY.trainClass{c}(:,1)]; % the first column, so far binary only !!! 
%                     res.Ytest  = [res.Ytest  ; datY.testClass{c}(:,1)];  % the first column, so far binary only !!! 
%                 end
%             else
%                 [res.Ytrain, res.Ytest]  = constY(datX{1},datY,param);
%             end
%             %%%%% merge X now
%             [datX{1} datY]=mergeClass(datX{1},datY);
%         end
        
        res.Xtrain = constNwayMatrix(datX{1}.trainClass,param);
        res.Xtest  = constNwayMatrix(datX{1}.testClass,param);
        
        
        %         if strcmp(param.centerData,'yes')
        %             %%%% centering through electrodes only , drift on electrode out
        %             [res.Xtrain,trMeans, trSc]=nprocess(res.Xtrain,[1 0 0],[0 0 0]);
        %             [res.Xtest]=nprocess(res.Xtest,[1 0 0],[0 0 0],trMeans,trSc,1);
        %         end
        
        %%% need this new figure otherwise PARAFAC plots to waitbar 
        [res.Xfactors,res.it,res.err]= parafac(res.Xtrain,param.numFactors,param.parafacOpt,param.parafacConst);
        disp('First PARAFAC done .... ')
        
        res = getParafacCharact(res.Xtrain,res,[]);
        
        if param.parafacPrctRemove
            ii=find(res.varian{1} <= prctile(res.varian{1},100-param.parafacPrctRemove)  &  res.lev{1} <= prctile(res.lev{1},100-param.parafacPrctRemove));
            res.Xtrain1=res.Xtrain(ii,:,:);
            if isfield(res,'YtrainFileInd')
                res.YtrainFileInd1=res.YtrainFileInd(ii,:,:);
            end
            %datY.trainClass1{1} = datY.trainClass{1}(ii,1);
            [res.Xfactors1,res.it1,res.err1,res.Corcondia1]= parafac(res.Xtrain1,param.numFactors,param.parafacOpt,param.parafacConst);
        end
        delete temp.mat
        
        fprintf('################################ \n'); 
        fprintf('Core consitency, 1st run: %2.2f  \n', res.Corcondia); 
        if isfield(res,'Corcondia1') 
            fprintf('Core consitency, 2st run: %2.2f  \n', res.Corcondia1); 
        end 
        
        waitbar(1/nWbar,hW)
        
        %%%%% est. test temporal atom if exist
        if ~isempty(res.Xtest)
            % computations take place here
            res.Xtest_tempAtom = PARAFAC_tempAtomEst(res.Xfactors,res.Xtest,param.parafacConst(1));
            if isfield(res,'Xfactors1')
                res.Xtest_tempAtom1 = PARAFAC_tempAtomEst(res.Xfactors1,res.Xtest,param.parafacConst(1));
            end
        end
        
    case 'NPLS'
        %%%%% construct N-way matrices for train and test
        res.Xtrain = constNwayMatrix(datX{1}.trainClass,param);
        res.Xtest  = constNwayMatrix(datX{1}.testClass,param);
                        
        [res.Xfactors,res.Yfactors,res.Core,res.B,res.ypred,res.ssx,res.ssy,res.reg] = npls(res.Xtrain,res.Ytrain,param.numFactors);
        %%%% compute predition on testing part
        for pF=1:param.numFactors
            [res.ypred_test(:,pF),res.T_test] = npred (res.Xtest,pF,res.Xfactors,res.Yfactors,res.Core,res.B);
            waitbar(pF/param.numFactors,hW)
        end
        
    case 'KPLS'
        %%%%% construct mdatrices for train and test
        res.Xtrain=[];res.Xtest=[];
        for c=1:length(datX{1}.trainClass)
            res.Xtrain=[res.Xtrain ; datX{1}.trainClass{c}];
        end
        for c=1:length(datX{1}.testClass)
            res.Xtest=[res.Xtest ; datX{1}.testClass{c}];
        end
        
        if strcmp(param.kernelFcn,'Linear')
            [res.Xfactors,res.Yfactors,res.Core,res.B,res.ypred,res.ssx,res.ssy,res.reg] = npls(res.Xtrain,res.Ytrain,param.numFactors);
            %%%% compute predition on testing part
            for pF=1:param.numFactors
                [res.ypred_test(:,pF),res.T_test] = npred (res.Xtest,pF,res.Xfactors,res.Yfactors,res.Core,res.B);
            end
        else %%%% KPLS
            %%% construct kernel functions
            res.K=Kernel(res.Xtrain, ...
                param.kernelFcn(1),param.kernelFcnParam(1),param.kernelFcnParam(2));
            res.K_test=Kernel_Test(res.Xtrain,res.Xtest, ...
                param.kernelFcn(1),param.kernelFcnParam(1),param.kernelFcnParam(2));
            %%% center Gramm matrices
            n =size(res.K,1);
            nt=size(res.K_test,1);
            M=eye(n)-ones(n,n)/n;
            Mt=ones(nt,n)/n;
            res.K_test = (res.K_test - Mt*res.K)*M;
            res.K=M*res.K*M;
            %%%% remove mean Y
            res.meanY = mean(res.Ytrain);
            for mi=1:size(res.Ytrain,1)
                res.Ytrain(mi,:)=res.Ytrain(mi,:) - res.meanY;
            end
            for mi=1:size(res.Ytest,1)
                res.Ytest(mi,:)=res.Ytest(mi,:) - res.meanY;
            end
            %for f=1:param.numFactors
            [B,res.T,res.U]=KerSIMPLS1(res.K,res.Ytrain,param.numFactors);
            for f=1:param.numFactors
                pB=res.U(:,1:f)*inv(res.T(:,1:f)'*res.K*res.U(:,1:f))*res.T(:,1:f)'*res.Ytrain;
                res.ypred(:,f)      = res.K*pB + res.meanY;
                res.ypred_test(:,f) = res.K_test*pB + res.meanY;
            end
        end
end

% --- begin modifications ---
% moved after plots

% if ~isempty(param.resultsName)
%     save(param.resultsName,'res','param');
% end

% --- end modifications ---

close(hW)

if isfield(param,'plotFileName')
    plotStr=['[hF] = ',param.plotFileName(1:end-2),'(res,param);'];
    eval(plotStr);
else
    hF=managePlots(param,res,fN);
end

% --- begin modifications ---
% saving after plotting

if strfind(param.fileName,'data_')
    pozF=strfind(param.fileName,'_');
    strFile=strcat('./Results/res',param.genMethod,param.fileName(pozF(1):end));
else
    strFile=strcat('./Results/res',param.genMethod);
end

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
    'Save results as ...',strFile);
pathName=getRelPath(pathName);

% --- not sure if it is relevant somewhere
global paramRunApp
% --------

if pathName
    if fName
        param.resultsName = strcat(pathName,fName);
        paramRunApp.resultsName = strcat(pathName,fName);
    else
        param.resultsName = [];
        paramRunApp.resultsName = [];
    end
end

if ~isempty(param.resultsName)
    save(param.resultsName,'res','param');
end

% --- end modifications ---


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [datX datY] = mergeClass(datX, datY) 
trC = []; valC = []; tstC = [];
trY = []; valY = []; tstY = []; 
trYi = []; valYi = []; tstYi = [];
for c=1:length(datX.trainClass)
    trC   = [trC   ; datX.trainClass{c}];
    valC  = [valC  ; datX.valClass{c}];
    trY   = [trY   ; datY.trainClass{c}];
    valY  = [valY  ; datY.valClass{c}];
    trYi  = [trYi  ; datY.trainClassInd{c}];
    valYi = [valYi ; datY.valClassInd{c}];    
    if length(datX.testClass) >=c 
        tstC  = [tstC  ; datX.testClass{c}];
        tstY  = [tstY  ; datY.testClass{c}];
        tstYi = [tstYi ; datY.testClassInd{c}];
    end
end
datX.trainClass = trC;
datX.valClass   = valC;
datX.testClass  = tstC;
datY.trainClass = trY;
datY.valClass   = valY;
datY.testClass  = tstY;
datY.trainClassInd = trYi;
datY.valClassInd   = valYi;
datY.testClassInd  = tstYi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ytrain,Ytest] = constY(datX,datY,param) 

classLabel=[-1 1]; %%% so far max 2 classes  -2 2 -3 3];      


%%%%% training
Ytrain = [];
for i=1:param.numClass
    Ytrain = [Ytrain ; ones(size(datX.trainClass{i},1),1)*classLabel(i)];
end

%%%%% testing
if isfield(param,'classLabel')
    Ytest  = [];
    for i=1:param.numClass
        Ytest = [Ytest ; ones(size(datX.testClass{i},1),1)*classLabel(i)];
    end
else
    %%%% testing
    %%% here I have only one class becouse class labels are not present !!!!
    %%% if there is file index I use to separate otherwise I keep all the same
    %%% equal to
    %%% %%%% if more then one column in this implenetation I take the first
    if length(datX.testClass) ==1
        Ytest = zeros(size(datX.testClass{1},1),1);
        unC=unique(datY.testClassInd{1});
        if length(unC) == param.numClass
            for i=1:param.numClass
                ii = datY.testClassInd{1} == unC(i);
                Ytest(ii,1)= classLabel(i);
            end
        else
            % Ytest=datY.testClass{1}(:,1); %%%% keep the same
            Ytest(:,1)=1;
        end
    else
        error('more then one test class .... not implemented yet ...');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [datX]=do_scaleX(datX)
%%%% scale X data
for m=1:length(datX)
    pX = []; 
    for c=1:length(datX{m}.trainClass) 
      pX = [pX ; datX{m}.trainClass{c}];  
    end
    % scaleX{m}=mean(pX); 
    for c=1:length(datX{m}.trainClass) 
        for i=1:size(datX{m}.trainClass{c},1)
           datX{m}.trainClass{c}(i,:)=datX{m}.trainClass{c}(i,:) - sqrt(sum(datX{m}.trainClass{c}(i,:).^2));  
        end 
    end 
    if isfield(datX{m},'valClass')
        for c=1:length(datX{m}.valClass)
            for i=1:size(datX{m}.valClass{c},1)
                datX{m}.valClass{c}(i,:)=datX{m}.valClass{c}(i,:) - sqrt(sum(datX{m}.valClass{c}(i,:).^2));  
            end
        end
    end
    if isfield(datX{m},'testClass')
        for c=1:length(datX{m}.testClass)
            for i=1:size(datX{m}.testClass{c},1)
                datX{m}.testClass{c}(i,:)=datX{m}.testClass{c}(i,:) - sqrt(sum(datX{m}.testClass{c}(i,:).^2));  
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [datX,meanX]=do_centerX(datX,param)

switch param.centerData
    case {'100','yes'}
        for m=1:length(datX)
            pX = [];
            for c=1:length(datX{m}.trainClass)
                pX = [pX ; datX{m}.trainClass{c}];
            end
            meanX{m}=mean(pX);
        end 
    case '110'
        n3=length(param.fLinesInd2use);
        n2=length(param.var2use);
        for m=1:length(datX)
            pX = [];
            for c=1:length(datX{m}.trainClass)
                pX = [pX ; datX{m}.trainClass{c}];
            end
            for i=1:n3
                mX(i)=mean(mean(pX(:,[i:n3:end]))); 
            end
            meanX{m}=repmat(mX,1,n2);
        end 
    otherwise 
        error(['Centering type :',param.centerData,' is not implemented yet'])
end 
switch param.centerData
    case {'100','110','yes'}
        for m=1:length(datX)
            for c=1:length(datX{m}.trainClass)
                for i=1:size(datX{m}.trainClass{c},1)
                    datX{m}.trainClass{c}(i,:)=datX{m}.trainClass{c}(i,:) - meanX{m};
                end
            end
            if isfield(datX{m},'valClass')
                for c=1:length(datX{m}.valClass)
                    for i=1:size(datX{m}.valClass{c},1)
                        datX{m}.valClass{c}(i,:)=datX{m}.valClass{c}(i,:) - meanX{m};
                    end
                end
            end
            if isfield(datX{m},'testClass')
                for c=1:length(datX{m}.testClass)
                    for i=1:size(datX{m}.testClass{c},1)
                        datX{m}.testClass{c}(i,:)=datX{m}.testClass{c}(i,:) - meanX{m};
                    end
                end
            end
        end
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [datY]=do_centerY(datY,meanY)
%
%
% %%%%  center Y dat 
% for c=1:length(datY.trainClass)
%     for i=1:size(datY.trainClass{c},1)
%         datY.trainClass{c}(i,1)=datY.trainClass{c}(i,1) - meanY;
%     end
% end
% if isfield(datY,'valClass')
%     for c=1:length(datY.valClass)
%         for i=1:size(datY.valClass{c},1)
%             datY.valClass{c}(i,1)=datY.valClass{c}(i,1) - meanY;
%         end
%     end
% end
% if isfield(datY,'testClass')
%     for c=1:length(datY.testClass)
%         for i=1:size(datY.testClass{c},1)
%             datY.testClass{c}(i,1)=datY.testClass{c}(i,1) - meanY;
%         end
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function param=selectPairs(param,hW)

newL=zeros(1,length(param.Xlabels));
for k=1:length(param.Xlabels)
    tI1=regexpi(param.Xlabels2use,{param.Xlabels{k}(1:3)});
    tI2=regexpi(param.Xlabels2use,{param.Xlabels{k}(5:end)});
    inD=sum(~cellfun('isempty',tI1))+sum(~cellfun('isempty',tI2));
    if inD==2
        newL(k)=1;
    end
end
param.var2use     = find(newL==1);
param.Xlabels2use = param.Xlabels(param.var2use);
if isempty(param.Xlabels2use)
    hE = errordlg('Error: Selected rule deselcts all electrode pairs');
    uiwait(hE)
    close(hW)
    error('Error: Skipping application module');
    gui_runApp; 
end



lenL=length(param.Xlabels2use);
newL=zeros(1,lenL);
%%% interhemispheric pairs only
%if isfield(param,'useInter')
    if param.useInter
        for k=1:lenL
            tI   = regexpi(param.Xlabels2use{k}(1:3),'\d');
            if ~isempty(tI)
                if ~rem(str2double(param.Xlabels2use{k}(tI(end))),2)
                    tI   = regexpi(param.Xlabels2use{k},'\d');
                    if ~isempty(tI)
                        if rem(str2double(param.Xlabels2use{k}(tI(end))),2)
                            newL(k)=1;
                        end
                    end
                else
                    tI   = regexpi(param.Xlabels2use{k},'\d');
                    if ~isempty(tI)
                        if ~rem(str2double(param.Xlabels2use{k}(tI(end))),2)
                            newL(k)=1;
                        end
                    end
                end
            end
        end
        param.var2use     = param.var2use(newL==1);
        param.Xlabels2use = param.Xlabels(param.var2use);
        if isempty(param.Xlabels2use)
            hE = errordlg('Error: Selected rule deselcts all electrode pairs');
            uiwait(hE)
            close(hW)
            error('Error: Skipping application module');
            gui_runApp; 
        end
    end
%end

lenL=length(param.Xlabels2use);
newL=ones(1,lenL);
%%% remove selfpairs pairs  
%if isfield(param,'useSelPairs')
if param.useSelfPairs==false
    for k=1:lenL
        tI   = regexpi(param.Xlabels2use{k}(1:3),param.Xlabels2use{k}(5:end));
        if ~isempty(tI)
            newL(k)=0;
        end
    end
    
    param.var2use     = param.var2use(newL==1);
    param.Xlabels2use = param.Xlabels(param.var2use);
    if isempty(param.Xlabels2use)
        hE = errordlg('Error: Selected rule deselcts all electrode pairs');
        uiwait(hE)
        close(hW)
        error('Error: Skipping application module');
        gui_runApp; 
    end
end






