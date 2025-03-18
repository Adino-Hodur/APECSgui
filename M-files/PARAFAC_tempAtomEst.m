function [C]= PARAFAC_tempAtomEst(A,X,typeConst,fact) 


%%%% aby sa to rovnalo Xtrain tak tam musom dat fact = []; 
%%%% t.z. zoberie vsetky , inak dekompozicia len cez jeden factor  


%%%% X must be concateneted spectra of all electrode in a row that is
%%%% [spectraFZ,  spectraPZ, etc. .....]; 



if nargin < 4 
    fact = [1:size(A{2},2)]; 
end 

[d1 d2 d3] = size(X);

h = waitbar(0,'Please wait...projecting test points ... ');
for i=1:d1  
    pX=squeeze(X(i,:,:))';
    X2(:,i)=reshape(pX,d2*d3,1);  
    waitbar(i / d1)
end
close(h)

P = krb(A{2}(:,fact),A{3}(:,fact)); 
PP=P'*P;
 
switch typeConst
    case 0
        %XP=P'*X2;
        C = [X2'*P*inv(PP)];
    case 2 %%% nonnegatvity 
        %         %% slover version by a column
%                 C=[];
%                 for n=1:size(X2,2)
%                     XP=P'*X2(:,n);
%                     b = fastnnls(PP,XP);
%                     C=[C ; b'];
%                 end
        %% faster version
        C=nonneg(X2',P');
    otherwise
        error('Test set projection routine is not implemented for the used constraint')
end



