function [dY,classLabel,dErr,perC] = setExp2_Art(datY,datE)


dY = ones(size(datY,1),1);
classLabel = 1;

%%%% define artifacts !!! 

%%%% set error epochs
artTresh = 0; %%% here you can define how many timepoints within an epoch
%%% need to be assignd as an artifact to assign the whole
%%% epoch as an artifact


dErr{1}.artifact = zeros(size(datE{1},1),1);

for i=1:size(datE{1}.var,1);
    xR=datE{1}.var(i,:);
    if find(xR==2)
        dErr{1}.artifact(i,1)= 2;
    else
        if find(xR==1)
            dErr{1}.artifact(i,1)= 1;
        end
    end 
end 

% sE=sum(datE{1}');
% ii= sE > artTresh;
% dErr{1}.artifact(ii)= 1;



ii=find(dErr{1}.artifact==0);
perC=(length(ii)/size(dErr{1}.artifact,1))*100;
strI=['Percentage of epochs kept: ',num2str(perC)];
disp(strI)
