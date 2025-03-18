function [dY,classLabel,dErr,perC] = setECEO_Art(datY,datE)


dY = ones(size(datY,1),1);
classLabel = 1;

%%%% define artifacts !!! 

%%%% set error epochs
artTresh = 0; %%% here you can define how many timepoints within an epoch
%%% need to be assignd as an artifact to assign the whole
%%% epoch as an artifact

%%% index artifacts
    %   1 (no power in 4s) 
    %   2 (no variance per sequemt)
    %   3 (too high amplitude)
    %   4 (sweat artifact absolute)
    %   6 (muscle artifact absolute)
    %   8 (eye movement artifact)
    %   5 & 7  muscle & sweat artefacts WITH 2 sec SHIFT 
    %   10 %%% more than 110 uV

%%%%% define artifact not tu use 
notArt=[1 2 4 5 6 7 8 10]; 

if ~isempty(notArt)
    for i=1:length(datE.var)
        for a=1:length(notArt)
           [rW,cL]=find(datE.var{i}.E==notArt(a));
           if ~isempty(rW)
               datE.var{i}.E(rW,cL)=0;
           end 
        end
    end
end



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
        sE1=sum(dErr{1}.artifact,2);
        dErr{1}.artifact=[sE1, dErr{1}.artifact]; %%%% compress to one
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
        sE1=sum(dErr{1}.artifact,2);
        dErr{1}.artifact=[sE1, dErr{1}.artifact]; %%%% compress to one
    else
        dErr{1}.artifact = zeros(size(datE,1),1);
        sE=sum(datE');
        ii= sE > artTresh;
        dErr{1}.artifact(ii)= 1;
    end
end


if exist('sE1','var')
    ii=find(sE1==0);
    perC=(length(ii)/size(dErr{1}.artifact,1))*100;
    strI=['Percentage of epochs kept: ',num2str(perC)];
    disp(strI)
end 