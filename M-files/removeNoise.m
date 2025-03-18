function [datX,datY,datE]=removeNoise(datE,datX,datY,param)

noiseVarLevel = 1.e-10; 
%for f=1:length(datE)
f=1; %%% at the moment works for one modality only 

%%%% first remove artifacts and then also delete 'timeEpochVariance' where artifcts are observed
if isfield(param,'remArtifact')
    if strcmp(param.remArtifact,'yes')
        %%% train class
        for c=1:length(datX{f}.trainClass)
            if ~isempty(datX{f}.trainClass{c})
                ii=find(datE{f}.artifact.trainClass{c}(:,1) == 0); %% no artifacts
                datX{f}.trainClass{c}=datX{f}.trainClass{c}(ii,:);
                datY.trainClass{c}=datY.trainClass{c}(ii,:);
                datY.trainClassInd{c}=datY.trainClassInd{c}(ii,:);
                if isfield(datE{1},'timeEpochVariance')
                    datE{1}.timeEpochVariance.trainClass{c}=datE{1}.timeEpochVariance.trainClass{c}(ii,:);
                end
            end
        end
        %%% val class
        for c=1:length(datX{f}.valClass)
            if ~isempty(datX{f}.valClass{c})
                ii=find(datE{f}.artifact.valClass{c}(:,1) == 0); %% no artifacts
                datX{f}.valClass{c}=datX{f}.valClass{c}(ii,:);
                datY.valClass{c}=datY.valClass{c}(ii,:);
                datY.valClassInd{c}=datY.valClassInd{c}(ii,:);
                if isfield(datE{1},'timeEpochVariance')
                    datE{1}.timeEpochVariance.valClass{c}=datE{1}.timeEpochVariance.valClass{c}(ii,:);
                end
            end
        end
        %%% test class
        for c=1:length(datX{f}.testClass)
            if ~isempty(datX{f}.testClass{c})
                ii=find(datE{f}.artifact.testClass{c}(:,1) == 0); %% no artifacts
                datX{f}.testClass{c}=datX{f}.testClass{c}(ii,:);
                datY.testClass{c}=datY.testClass{c}(ii,:);
                datY.testClassInd{c}=datY.testClassInd{c}(ii,:);
                if isfield(datE{1},'timeEpochVariance')
                    datE{1}.timeEpochVariance.testClass{c}=datE{1}.timeEpochVariance.testClass{c}(ii,:);
                end
            end
        end
    end
    
    
    %%% now remove possible variance epochs, i.e. flat line EEG 
    if isfield(datE{1},'timeEpochVariance')
        ansQ = false; 
        for c=1:length(datX{f}.trainClass)
            if ~isempty(datX{f}.trainClass{c})
                %%% zero-variance artifacts index
                ii=find(sum(datE{f}.timeEpochVariance.trainClass{c}' <= noiseVarLevel) == 1); %%% no artifact 
                %%%% remove these epochs
                if ~isempty(ii) && ~ansQ
                    remE = remEpochs; 
                    ansQ = true; 
                    iR=ones(size(datE{f}.timeEpochVariance.trainClass{c},1),1); 
                    iR(ii)=0; 
                end 
                if ~isempty(ii) && remE
                    disp('Removing train-class epoch-zero-variance'); 
                    datX{f}.trainClass{c}=datX{f}.trainClass{c}(iR,:);
                    datY.trainClass{c}=datY.trainClass{c}(iR,:);
                    datY.trainClassInd{c}=datY.trainClassInd{c}(iR,:);
                    datE{1}.timeEpochVariance.trainClass{c}=datE{1}.timeEpochVariance.trainClass{c}(iR,:);
                end
            end
        end
        %%% validation 
        for c=1:length(datX{f}.valClass)
            if ~isempty(datX{f}.valClass{c})
                %%% zero-variance artifacts index
                ii=find(sum(datE{f}.timeEpochVariance.valClass{c}' <= noiseVarLevel) == 1);
                %%%% remove these epochs
                if ~isempty(ii) && ~ansQ
                    remE = remEpochs; 
                    ansQ = true; 
                    iR=ones(size(datE{f}.timeEpochVariance.valClass{c},1),1); 
                    iR(ii)=0; 
                end 
                if ~isempty(ii) && remE
                    disp('Removing val-class epoch-zero-variance'); 
                    datX{f}.valClass{c}=datX{f}.valClass{c}(iR,:);
                    datY.valClass{c}=datY.valClass{c}(iR,:);
                    datY.valClassInd{c}=datY.valClassInd{c}(iR,:);
                    datE{1}.timeEpochVariance.valClass{c}=datE{1}.timeEpochVariance.valClass{c}(iR,:);
                end
            end
        end
        %%% test class 
        for c=1:length(datX{f}.testClass)
            if ~isempty(datX{f}.testClass{c})
                %%% zero-variance artifacts index
                ii=find(sum(datE{f}.timeEpochVariance.testClass{c}' <= noiseVarLevel) == 1);
                %%%% remove these epochs
                if ~isempty(ii) && ~ansQ
                    remE = remEpochs; 
                    ansQ = true; 
                    iR=ones(size(datE{f}.timeEpochVariance.testClass{c},1),1); 
                    iR(ii)=0; 
                end 
                if ~isempty(ii) && remE
                    disp('Removing test-class epoch-zero-variance'); 
                    datX{f}.testClass{c}=datX{f}.testClass{c}(iR,:);
                    datY.testClass{c}=datY.testClass{c}(iR,:);
                    datY.testClassInd{c}=datY.testClassInd{c}(iR,:);
                    datE{1}.timeEpochVariance.testClass{c}=datE{1}.timeEpochVariance.testClass{c}(iR,:);
                end
            end
        end
   end 
    
end




%%% this represent the older version where we set percentile levels on
%%% epoch variance 
% if isfield(param,'errorType')
%     switch param.errorType
%         case 'timeEpochVariance' %%% this removes from train and val sets only
%             if param.errorType2use(1) > 0  || param.errorType2use(2) < 100
%                 tmpX=[];
%                 for c=1:length(datE{f}.timeEpochVariance.trainClass)
%                     tmpX=[tmpX ; datE{f}.timeEpochVariance.trainClass{c}];
%                     if ~isempty(datE{f}.timeEpochVariance.valClass{c})
%                         tmpX=[tmpX ; datE{f}.timeEpochVariance.valClass{c}];
%                     end
%                 end
%                 if param.errorType2use(1) > 0
%                     varInRangeL=prctile(tmpX,param.errorType2use(1));
%                 end
%                 if param.errorType2use(2) < 100
%                     varInRangeU=prctile(tmpX,param.errorType2use(2));
%                 end
%                 
%                 clear tmpX
%                 %%%%% all train classe(s)
%                 for c=1:length(datX{f}.trainClass)
%                     if ~isempty(datX{f}.trainClass{c})
%                         [nS nV]=size(datE{f}.timeEpochVariance.trainClass{c});
%                         indN=ones(nS,1);
%                         for i=1:nV
%                             tV = datE{f}.timeEpochVariance.trainClass{c}(:,i) ;
%                             if exist('varInRangeL','var') && exist('varInRangeU','var')
%                                 ii = find(tV < varInRangeL(i) | tV > varInRangeU(i));
%                             elseif exist('varInRangeL','var')
%                                 ii = find(tV < varInRangeL(i));
%                             elseif exist('varInRangeU','var')
%                                 ii = find(tV > varInRangeU(i));
%                             end
%                             if ~isempty(ii)
%                                 indN(ii) = 0;
%                             end
%                         end
%                         datE{f}.timeEpochVariance.trainClass{c} = datE{f}.timeEpochVariance.trainClass{c}(indN==1,:);
%                         datX{f}.trainClass{c} = datX{f}.trainClass{c}(indN==1,:);
%                         datY.trainClass{c} = datY.trainClass{c}(indN==1,:);
%                         if isfield(datY,'trainClassInd')
%                             datY.trainClassInd{c} = datY.trainClassInd{c}(indN==1,:);
%                         end
%                     end
%                 end
%                 %%%% all val classes
%                 for c=1:length(datX{f}.valClass)
%                     if ~isempty(datX{f}.valClass{c})
%                         [nS nV]=size(datE{f}.timeEpochVariance.valClass{c});
%                         indN=ones(nS,1);
%                         for i=1:nV
%                             tV = datE{f}.timeEpochVariance.valClass{c}(:,1) ;
%                             if exist('varInRangeL','var') && exist('varInRangeU','var')
%                                 ii = find(tV < varInRangeL(i) || tV > varInRangeU(i));
%                             elseif exist('varInRangeL','var')
%                                 ii = find(tV < varInRangeL(i));
%                             elseif exist('varInRangeU','var')
%                                 ii = find(tV > varInRangeU(i));
%                             end
%                             if exist('ii','var') &&  ~isempty(ii)
%                                 indN(ii) = 0;
%                             end
%                         end
%                         datE{f}.timeEpochVariance.valClass{c} = datE{f}.timeEpochVariance.valClass{c}(indN==1,:);
%                         datX{f}.valClass{c} = datX{f}.valClass{c}(indN==1,:);
%                         datY.valClass{c} = datY.valClass{c}(indN==1,:);
%                         if isfield(datY,'valClassInd')
%                             datY.valClassInd{c} = datY.valClassInd{c}(indN==1,:);
%                         end
%                     end
%                 end
%                 %             %%%%% all test classe(s)
%                 %             for c=1:length(datX{f}.testClass)
%                 %                 if ~isempty(datX{f}.testClass{c})
%                 %                     [nS nV]=size(datE{f}.timeEpochVariance.testClass{c});
%                 %                     indN=ones(nS,1);
%                 %                     for i=1:nV
%                 %                         tV = datE{f}.timeEpochVariance.testClass{c}(:,1) ;
%                 %                         if exist('varInRangeL','var') && exist('varInRangeU','var')
%                 %                             ii = find(tV < varInRangeL(i) || tV > varInRangeU(i));
%                 %                         elseif exist('varInRangeL','var')
%                 %                             ii = find(tV < varInRangeL(i));
%                 %                         elseif exist('varInRangeU','var')
%                 %                             ii = find(tV > varInRangeU(i));
%                 %                         end
%                 %                         if exist('ii','var') &&  ~isempty(ii)
%                 %                             indN(ii) = 0;
%                 %                         end
%                 %                     end
%                 %                     datE{f}.timeEpochVariance.testClass{c} = datE{f}.timeEpochVariance.testClass{c}(indN==1,:);
%                 %                     datX{f}.testClass{c} = datX{f}.testClass{c}(indN==1,:);
%                 %                     datY.testClass{c} = datY.testClass{c}(indN==1,:);
%                 %                     if isfield(datY,'testClassInd')
%                 %                         datY.testClassInd{c} = datY.testClassInd{c}(indN==1,:);
%                 %                     end
%                 %                 end
%                 %             end
%             end
%     end
% end

% end %%% end f loop

function remE = remEpochs 
choice = questdlg(sprintf('Epochs with zero-variance are detected. \n Would you like to remove them?'), ...
    'Zero-variance epochs', ...
    'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        remE = true; 
    case 'No'
        remE = false; 
end
