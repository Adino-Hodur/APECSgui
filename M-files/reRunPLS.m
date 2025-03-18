% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [hF,res1]=reRunPLS(res1,param)


res=res1; %%% keep original res for saving  

fN=strcat(param.pathName,param.fileName); 
if isunix || ismac %%% change all \ to /
    fN(strfind(fN,'\'))='/';
end
load(fN); 


%%% remove old regression params.
hW = waitbar(0,'Please wait .... training the model ....') ;
hF = []; 

switch param.genMethod
    case 'NPLS'
        runType='A'; 
     case 'KPLS'
        if strcmp(param.kernelFcn,'Linear')
            runType='A';
        else
            runType='B';  
        end   
end


%%%% remove scores 
switch runType
    case 'A'
        res1=rmfield(res1,'Core');
        res1=rmfield(res1,'B');
        res1=rmfield(res1,'ssx');
        res1=rmfield(res1,'ssy');
        res1=rmfield(res1,'reg');
        res1=rmfield(res1,'ypred');
        res1=rmfield(res1,'ypred_test');
        [T]=fac2let(res.Xfactors);
        %dS=setdiff([1:param.numFactors],param.reRunPLS.atomsRemove);
        dS=param.reRunPLS.atomsKeep;
        res1.T=T(:,dS);
        res1.T_test=res.T_test(:,dS);
        
        %%%%
        for nS=1:length(res1.Xfactors)
            res1.Xfactors{nS}=res1.Xfactors{nS}(:,dS);
        end
        for nS=1:length(res1.Yfactors)
            res1.Yfactors{nS}=res1.Yfactors{nS}(:,dS);
        end
        
        for pF=1:length(dS)
            pT=res1.T(:,1:pF);pTst=res1.T_test(:,1:pF);
            B=inv(pT'*pT)*pT'*res.Ytrain;
            res1.ypred(:,pF)=pT*B;
            res1.ypred_test(:,pF)=pTst*B;
            res1.B{pF}=B;
            waitbar(pF/length(dS),hW)
        end
    case 'B'
        res1=rmfield(res1,'ypred');
        res1=rmfield(res1,'ypred_test');
        %dS=setdiff([1:param.numFactors],param.reRunPLS.atomsRemove);
        dS=param.reRunPLS.atomsKeep;
        res1.T=res.T(:,dS);
        res1.U=res.U(:,dS);
        for f=1:length(dS)
            pB=res1.U(:,1:f)*inv(res1.T(:,1:f)'*res1.K*res1.U(:,1:f))*res1.T(:,1:f)'*res1.Ytrain;
            res1.ypred(:,f)      = res1.K*pB + res1.meanY;
            res1.ypred_test(:,f) = res1.K_test*pB + res1.meanY;
        end
end


%%% --- begin modifications ---
% save after plot

% if ~isempty(param.reRunPLS.resultsName)
%     save(param.reRunPLS.resultsName,'res','res1','param');
% end

%%% --- end modifications ---

close(hW)

%%%% here I need to change some of the first level param by param.reRunPARAFAC for plotting 
paramTMP = param; 
paramTMP.numFactors = length(dS); 
%paramTMP.parafacPrctRemove =  param.reRunPARAFAC.parafacPrctRemove;
paramTMP.atomsRemoved = true; 
%paramTMP.centerData =  param.reRunPARAFAC.centerData;

if isfield(param,'plotFileName')
    plotStr=['[hF] = ',param.plotFileName(1:end-2),'(res1,paramTMP);'];
    eval(plotStr);
else
    hF=managePlots(paramTMP,res1,fN);
end

%%% --- begin modifications ---
% save after plot

if strfind(param.fileName,'data_GenerateSets_')
    strFile=strcat('./Results/removedAtoms_res',param.genMethod,'_',param.fileName(19:end));
else
    strFile=strcat('./Results/removedAtoms_res',param.genMethod);
end

[fName, pathName] = uiputfile( {'*.mat','MATLAB File'}, ...
    'Save results as ...',strFile);
pathName=getRelPath(pathName);

% --- not sure if it is relevant somewhere
global paramRunApp
% ----------------

if pathName
    if fName
        param.reRunPLS.resultsName = strcat(pathName,fName);
        paramRunApp.reRunPLS.resultsName = strcat(pathName,fName);
    else
        param.reRunPLS.resultsName = [];
        paramRunApp.reRunPLS.resultsName = [];
    end
end

if ~isempty(param.reRunPLS.resultsName)
    save(param.reRunPLS.resultsName,'res','res1','param');
end


%%% --- end modifications


