function hF = plot_sepSpectraCent(res, param)

hF={'fig_spectSel1'};


pWin  = length(param.var2use);

switch param.binProcess
    case {'none','RelSpect'}
        fL    = param.fLines(param.fLinesInd2use);
        lenFL = length(fL);
    case {'Avg','RelAvg'}
        fL    = 1: length(param.freqIn2use);
        lenFL = length(fL);
end
        

cstring='grbcmk';
lenColor=length(cstring);

pS=ceil(pWin/5);

figure('Name',hF{1});

if isfield(res,'Ytrain')
    [trI]=unique(res.Ytrain);
    [tsI]=unique(res.Ytest);
    for c=1:length(trI)
        iTr{c}= res.Ytrain==trI(c);
    end
    for c=1:length(tsI)
        iTs{c}= res.Ytest==tsI(c);
    end
else
    trI=1;tsI=1; %%% just one class for train / test
    iTr{1}=1:size(res.Xtrain,1);
    if ~isempty(res.Xtest)
        iTs{1}=1:size(res.Xtest,1);
    end
end

modal=length(size(res.Xtrain));

indM= 1;

for i=1:pWin
    if pS == 1
        subplot(pS,pWin,i)
    else
        subplot(pS,5,i)
    end
    
    switch param.binProcess
        case {'none','RelSpect'}
            lenF=length(param.fLinesInd2use);
        case {'Avg','RelAvg'}
            lenF=length(param.freqIn2use);
    end
    
    %%%% if centering need to add mean  
    bg1 = (i-1)*lenF + 1; en1 = bg1 + lenF -1;
    addMnX = zeros(1,lenF); 
    if isfield(param,'reRunPARAFAC') % isfield(param,'atomsRemoved') 
        if strcmpi(param.reRunPARAFAC.centerData,'yes') && strcmpi(param.centerData,'no')
            addMnX=res.meanX_remAtoms(bg1:en1);            
        end
        if strcmpi(param.reRunPARAFAC.centerData,'yes') && strcmpi(param.centerData,'yes')
           %%%% not sure what to do here addMnX=res.meanX_remAtoms(bg1:en1);            
        end
    elseif strcmpi(param.centerData,'yes')
        addMnX= addMnX + res.meanX{1}(bg1:en1);
    end
    %addMnX= addMnX + res.meanX{1}(bg1:en1);
    
    switch modal
        case 3
%             if length(trI)==1
%                 %pV = mean(squeeze(res.Xtrain(iTr1,i,:)) + addMnX);
%                 pV = mean(bsxfun(@plus,squeeze(res.Xtrain(iTr1,i,:)),addMnX));
%                 mn(indM)=min(pV);mx(indM)=max(pV);
%                 indM=indM+1;
%                 plot(fL, pV,'');
%                 hold on
%                 if length(tsI)==1 && ~isempty(res.Xtest)
%                     %pV = mean(squeeze(res.Xtest(iTs1,i,:)) + addMnX);
%                     pV = mean(bsxfun(@plus,squeeze(res.Xtest(iTs1,i,:)),addMnX));
%                     mn(indM)=min(pV);mx(indM)=max(pV);
%                     indM=indM+1;
%                     plot(fL, pV,'r:');
%                 end
%                 axis([fL(1) fL(end) min(mn) max(mx)]);
%                 mn=[];mx=[];indM=1;
%             else
                for c=1:length(trI)
                    %pV = mean(squeeze(res.Xtrain(iTr{c},i,:)) + addMnX);
                    pV = mean(bsxfun(@plus,squeeze(res.Xtrain(iTr{c},i,:)),addMnX));
                    mn(indM)=min(pV);mx(indM)=max(pV);
                    indM=indM+1;
                    plot(fL, pV,[cstring(mod(c,lenColor)+1)]);
                    hold on
                end
                for c=1:length(tsI)
                    if  ~isempty(res.Xtest)
                        %pV = mean(squeeze(res.Xtest(iTs{c},i,:)) + addMnX);
                        pV = mean(bsxfun(@plus,squeeze(res.Xtest(iTs{c},i,:)),addMnX));
                        mn(indM)=min(pV);mx(indM)=max(pV);
                        indM=indM+1;
                        plot(fL, pV,[cstring(mod(c,lenColor)+1),':']);
                    end
                end
                axis([fL(1) fL(end) min(mn) max(mx)]);
                mn=[];mx=[];indM=1;
%            end
        case 2
            bg = (i-1)*lenFL +1; en = bg+lenFL - 1;
%             if length(trI)==1
%                 %pV = mean(res.Xtrain(iTr1,bg:en));
%                 pV = mean(bsxfun(@plus,res.Xtrain(iTr1,bg:en),addMnX));
%                 mn(indM)=min(pV);mx(indM)=max(pV);
%                 indM=indM+1;
%                 plot(fL, pV,'');
%                 hold on
%                 if length(tsI)==1 && ~isempty(res.Xtest)
%                     %pV = mean(squeeze(res.Xtest(iTs1,i,:)) + addMnX);
%                     pV = mean(bsxfun(@plus,squeeze(res.Xtest(iTs1,bg:en)),addMnX));
%                     mn(indM)=min(pV);mx(indM)=max(pV);
%                     indM=indM+1;
%                     plot(fL, pV,'r:');
%                 end
%             else
                for c=1:length(trI)
                    pV = mean(bsxfun(@plus,res.Xtrain(iTr{c},bg:en),addMnX));
                    mn(indM)=min(pV);mx(indM)=max(pV);
                    indM=indM+1;
                    plot(fL, pV,[cstring(mod(c,lenColor)+1)]);
                    hold on
                end
                for c=1:length(tsI)
                    if  ~isempty(res.Xtest)
                        pV = mean(bsxfun(@plus,res.Xtest(iTs{c},bg:en),addMnX));
                        mn(indM)=min(pV);mx(indM)=max(pV);
                        indM=indM+1;
                        plot(fL, pV,[cstring(mod(c,lenColor)+1),':']);
                    end
                end
%            end
            axis([fL(1) fL(end) min(mn) max(mx)]);
            mn=[];mx=[];indM=1;
    end
    
    ii=find(rem(fL,5)==0);
    set(gca,'Xtick',fL(ii),'XminorTick','on');
    % axis([fL(1) fL(end) min(mn) max(mx)]);
    if isfield(param,'Xlabels2use')
        title(param.Xlabels2use{i})
        xlabel('Hz')
        ylabel('log-power')
    else
        title(param.Xlabels{i})
        xlabel('Hz')
        ylabel('log-power')
    end
    if i==pWin
        if length(trI)==1
            legend('train class','test class');
        else
            for c=1:length(trI)
                strL{c}=['train class', num2str(c)];
            end
            if length(tsI) == 1
                if ~isempty(res.Xtest)
                    strL{end+1}='test class';
                end
            else
                for c=1:length(tsI)
                    if ~isempty(res.Xtest)
                        strL{end+1}=['test class', num2str(c)];
                    end
                end
            end
            legend(strL);
        end        
    end        
end
