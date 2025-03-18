function [dErr]=artEpoch2Vect(datE)

%%%% set error epochs
artTresh = 0; %%% here you can define how many timepoints within an epoch
%%% need to be assignd as an artifact to assign the whole
%%% epoch as an artifact

dErr{1}.artifact = [];
if iscell(datE)
    if isstruct(datE{1})
        dErr{1}.artifact = zeros(size(datE{1}.var{1}.E,1),length(datE{1}.var));
        sE=sum(datE{1}.var{1}.E');
        ii= sE > artTresh;
        dErr{1}.artifact(ii,1)= 1;
        for j=2:length(datE{1}.var)
            sE=sum(datE{1}.var{j}.E');
            ii = sE > 0;  %%% here I check if the electrode is involved !!!
            dErr{1}.artifact(ii,j)= 1;
        end
        %%%%% add first column
        dErr{1}.artifact=[sum(dErr{1}.artifact,2), dErr{1}.artifact]; %%%% compress to one
    else
        dErr{1}.artifact = zeros(size(datE{1},1),1);
        sE=sum(datE{1}');
        ii= sE > artTresh;
        dErr{1}.artifact(ii)= 1;
    end
else
    if isstruct(datE)
        dErr{1}.artifact = zeros(size(datE.var{1}.E,1),length(datE.var));
        sE=sum(datE.var{1}.E');
        ii= sE > artTresh;
        dErr{1}.artifact(ii,1)= 1;
        for j=2:length(datE.var)
            sE=sum(datE.var{j}.E');
            ii = sE > 0;  %%% here I check if the electrode is involved !!!
            dErr{1}.artifact(ii,j)= 1;
        end
        %%%%% add first column
%         sE=sum(dErr{1}.artifact,2);
%         ii=find(sE < 5); %%%  allow 5 electrodes to be bad 
%         sE(ii)=0; 
        dErr{1}.artifact=[sum(dErr{1}.artifact,2), dErr{1}.artifact]; %%%% compress to one
    else
        dErr{1}.artifact = zeros(size(datE,1),1);
        sE=sum(datE');
        ii= sE > artTresh;
        dErr{1}.artifact(ii)= 1;
    end
end

 
