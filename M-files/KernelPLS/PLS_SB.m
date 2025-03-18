function [T,W]=PLS_SB(X,Y,Fac)

  %%% Partial Least Squares - SB mode   
  %%%  
  %%%
  %%% Inputs  
    %     X    : block A matrix (number of samples  x dim1) - zero mean !
    %     Y    : block B matrix (number of samples  x dim2) - zero mean !
    %     Fac  : number of latent vectors (components)  to extract 
    
    %     Outputs: 
    %     T    : matrix of latent vectors (number of samples x Fac)  
    %     W    : loadings  
   
        
[n,d1]=size(X);
[n,d2]=size(Y);
for i=1:d1
   X(:,i)=X(:,i)-mean(X(:,i));
end 
for i=1:d2
   Y(:,i)=Y(:,i)-mean(Y(:,i));
end


XY=X'*Y; 

[W,S,V]=svds(XY,Fac);


T=X*W; 
