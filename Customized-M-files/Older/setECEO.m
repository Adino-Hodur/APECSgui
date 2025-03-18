function [dY,classLabel] = setECEO(datY)


dY = ones(size(datY,1),1);
classLabel = 1;

% %%%% set error epochs
% artTresh = 0; %%% here you can define how many timepoints within an epoch
% %%% need to be assignd as an artifact to assign the whole
% %%% epoch as an artifact,

% dErr{1}.artifact = [];
% if isstruct(datE{1})
%     dErr{1}.artifact = zeros(size(datE{1}.var{1}.E,1),length(datE{1}.var));
%     sE=sum(datE{1}.var{1}.E');
%     ii= sE > artTresh;
%     dErr{1}.artifact(ii,1)= 1;
%     for j=2:length(datE{1}.var)
%         sE=sum(datE{1}.var{j}.E');
%         ii = sE > 0;  %%% here I check if the electrode is involved !!! 
%         dErr{1}.artifact(ii,j)= 1;
%     end  
% else
%     dErr{1}.artifact = zeros(size(datE{1},1),1);
%     sE=sum(datE{1}');
%     ii= sE > artTresh;
%     dErr{1}.artifact(ii)= 1;
% end
