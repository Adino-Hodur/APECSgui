function [datX,datErr] = selSubData(param,datX,datErr)

if nargin < 3
    datErr = [];
else
    if isfield(datErr{1},'artifact')
        if size(datErr{1}.artifact.trainClass{1},2) > 1
            selSubArt=true;
        else
            selSubArt=false; %%%% only one label common for all channels
        end
    end
end 

selSub = zeros(1,length(param.multiWay)); 

%%%%% Define index for sub-variables (Xlabels) 
indxF{1} = param.var2use;

% 
% 
% for i=1:length(param.multiWay)
%     if (length(indxF{i}) ~= param.multiWay(i))
%         selSub(i)=true; 
%     else 
%         selSub(i)=false; 
%     end 
% end 

if (length(indxF{1}) ~= param.multiWay(1))
    selSub(1)=true;
else
    selSub(1)=false;
end



if sum(selSub) %%%%  need to select a sub-set        
    switch length(param.multiWay)
        case 1
            lenSeg =  length(fLines);
        case 2
            lenSeg =  param.multiWay(2);
    end
    indA=[]; 
    for i1=1:length(indxF{1})
        bg = (indxF{1}(i1)-1) * lenSeg + 1;
        en = bg + lenSeg - 1;
        ind = bg : en ;
       % ind = ind (indxF{2});
        indA = [indA ind];
    end
    %%%% train & val 
    for s=1:length(datX{1}.trainClass)
        if ~isempty(datX{1}.trainClass{s})
            datX{1}.trainClass{s} = datX{1}.trainClass{s}(:,indA); 
            if ~isempty(datErr) %%% dat Err exist 
                if isfield(datErr{1},'artifact')
                    if selSubArt %%% artifact for every electrode
                        datErr{1}.artifact.trainClass{s} = datErr{1}.artifact.trainClass{s}(:,[1 (param.var2use+1)]);
                        %%% need to make correction if the electrode(s) where
                        %%% artifact was present is removed
                        datERR{1}.artifact.trainClass{s}(:,1)=sum(datErr{1}.artifact.trainClass{s}(:,2:end)');
                    end
                end 
                if isfield(datErr{1},'timeEpochVariance')
                    datErr{1}.timeEpochVariance.trainClass{s} = datErr{1}.timeEpochVariance.trainClass{s}(:,param.var2use);
                end
            end 
        end
        if ~isempty(datX{1}.valClass{s})
            datX{1}.valClass{s} = datX{1}.valClass{s}(:,indA);
            if ~isempty(datErr) %%% dat Err exist 
                if isfield(datErr{1},'artifact')
                    if selSubArt %%% artifact for every electrode
                        datErr{1}.artifact.valClass{s} = datErr{1}.artifact.valClass{s}(:,[1 (param.var2use+1)]);
                        %%% need to make correction if the electrode(s) where
                        %%% artifact was present is removed
                        datERR{1}.artifact.valClass{s}(:,1)=sum(datErr{1}.artifact.valClass{s}(:,2:end)');
                    end
                end 
                if isfield(datErr{1},'timeEpochVariance')
                    datErr{1}.timeEpochVariance.valClass{s} = datErr{1}.timeEpochVariance.valClass{s}(:,param.var2use);
                end
            end 
        end
    end
    %%%% test 
    for s=1:length(datX{1}.testClass)
        if ~isempty(datX{1}.testClass{s})
            datX{1}.testClass{s} = datX{1}.testClass{s}(:,indA);
            if ~isempty(datErr) %%% dat Err exist 
                if isfield(datErr{1},'artifact')
                    if selSubArt %%% artifact for every electrode
                        datErr{1}.artifact.testClass{s} = datErr{1}.artifact.testClass{s}(:,[1 (param.var2use+1)]);
                        %%% need to make correction if the electrode(s) where
                        %%% artifact was present is removed
                        datERR{1}.artifact.testClass{s}(:,1)=sum(datErr{1}.artifact.testClass{s}(:,2:end)');
                    end
                end 
                if isfield(datErr{1},'timeEpochVariance')
                    datErr{1}.timeEpochVariance.testClass{s} = datErr{1}.timeEpochVariance.testClass{s}(:,param.var2use);
                end
            end 
        end
    end        
end 
