function hF = plotNPLS(res,param)

%param.smoothFac = 10; 
smoothMethod = 'moving'; % 'rloess'

switch param.genMethod
    case 'NPLS'
        hF={'fig_nplsTrain','fig_nplsTest'};
    case 'KPLS'
        hF={'fig_kplsTrain','fig_kplsTest'};
    otherwise 
        hF={'fig_Train','fig_Test'}; 
end

cstring='brgcmk'; 
lenColor=length(cstring); 

yMin=min(res.Ytrain) - 0.5;
yMax=max(res.Ytrain) + 0.5;

fS=strcat(param.pathName,param.fileName); 
load(fS,'header'); 
if header.fileHeader{1}.lenOverlap > 0
    switch header.fileHeader{1}.lenOverlapUnit
        case 'sec'
            epochInSec = header.fileHeader{1}.lenOverlap;
        case 'msec'
            epochInSec = header.fileHeader{1}.lenOverlap/1000;
        case 'min'
            epochInSec = header.fileHeader{1}.lenOverlap*60;
    end
else
    switch header.fileHeader{1}.lenEpochUnit
        case 'sec'
            epochInSec = header.fileHeader{1}.lenEpoch;
        case 'msec'
            epochInSec = header.fileHeader{1}.lenEpoch/1000;
        case 'min'
            epochInSec = header.fileHeader{1}.lenEpoch*60;
    end
end
clear header


%%%% this is standard basic plot of train and test results for NPLS
pS=ceil(param.numFactors/3);

%%% train
figure('Name',hF{1});
for i=1:param.numFactors
    if pS == 1
        subplot(pS,param.numFactors,i)
    else
        subplot(pS,3,i)
    end 
    timeX=([1:length(res.ypred(:,i))]*epochInSec)/60;
    plot(timeX,smooth(res.Ytrain,param.smoothFac,smoothMethod),'r:');
    hold on 
    sm_ypred=smooth(res.ypred(:,i),param.smoothFac,smoothMethod);
    %%%% plot file in color 
    if isfield(res,'YtrainFileInd')        
        fU=unique(res.YtrainFileInd); 
        for f=1:length(fU)
            ii=find(res.YtrainFileInd == fU(f));                 
            plot(timeX(ii),sm_ypred(ii),[cstring(mod(f,lenColor)+1)]);
        end 
    else 
       plot(timeX,sm_ypred); 
    end 

    plot([0 length(res.Ytrain)],[mean(res.Ytrain) mean(res.Ytrain)],'k:');    
    str=['Train (',param.genMethod,'): # of atoms:',int2str(i)];
    title(str);
    
    axis([0 timeX(end) yMin yMax]);
    if isfield(res,'sessionLenTrain')
        for j=1:length(res.sessionLenTrain)
            xIn = sum(res.sessionLenTrain(1:j));
            plot([xIn xIn],[yMin,yMax],'k:');
        end
    end
end   

%%% test
figure('Name',hF{2});
for i=1:param.numFactors
    if pS == 1
        subplot(pS,param.numFactors,i)
    else
        subplot(pS,3,i)
    end
    timeX=([1:length(res.ypred_test(:,i))]*epochInSec)/60;    
    sm_ypred=smooth(res.ypred_test(:,i),param.smoothFac,smoothMethod);    
    if isfield(res,'YtestFileInd')        
        fU=unique(res.YtestFileInd); 
        for f=1:length(fU)
            ii=find(res.YtestFileInd == fU(f)); 
            plot(timeX(ii),sm_ypred(ii),[cstring(mod(f,lenColor)+1)]);     
            hold on 
           % plot([timeX(ii(end)) timeX(ii(end))],[min(sm_ypred)*2 max(sm_ypred)]*2,'k:');
        end 
    else 
       plot(timeX,sm_ypred); 
       hold on 
    end     
    xlabel('time [min]')
    if length(unique(res.Ytest)) > 1
        plot(timeX,res.Ytest,'r:');
        plot([0 timeX(end)],[mean(res.Ytest) mean(res.Ytest)],'k:');
    end
    str=['Test (',param.genMethod,'): # of atoms:',int2str(i)];
    title(str);
    axis([0 timeX(end) yMin yMax]);
    if isfield(res,'sessionLenTest')
        for j=1:length(res.sessionLenTest)
            xIn = sum(res.sessionLenTest(1:j));
            plot([xIn xIn],[yMin,yMax],'k:');
        end
    end
end

