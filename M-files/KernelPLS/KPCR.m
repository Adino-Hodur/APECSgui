function  [Y_hat,Yt_hat,B]=KPCR(P_X,P_Xt,D,Y,Yt) 

  %%% Kernel Principal Component Regression 
  %%%
  %%% Inputs  
    %     P_X  : projected training data points onto the first p principal componets  (number of samples  x p) 
    %     P_Xt : projected testing  data points onto the first p principal componets  (number of samples  x p) 
    %     D    : (at least) first p ordered (maximal first) eigenvalues of the centralized training data kernel matrix
    %     Y    : training outputs (number of samples  x dim) 
    %     Yt   : testing  outputs (number of samples  x dim) 
    % 
    %     Outputs: 
    %      
    %     Y_hat  : predicted training outputs (number of samples  x dim)   
    %     Yt_hat : predicted testing  outputs (number of samples  x dim)      
    %     B      : matrix (or vector) of regression coefficients (p x dim)     
     
   [n,p]=size(P_X);
   [nt,p]=size(P_Xt);
 
    
   %%% only the first p-eigenvalues are used  
   D=D(1:p)'; 
   
   %%% adding bias term 
   P_X=[ones(n,1) P_X];    
   P_Xt=[ones(nt,1) P_Xt];
   D=[n D];

   B=diag(1./D)*P_X'*Y; 
   Y_hat=P_X*B;
   Yt_hat=P_Xt*B;
  