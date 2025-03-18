function  [Y_hat,Yt_hat,B]=KPCR_cent(P_X,P_Xt,D,Y,Yt) 

  %%% Kernel Principal Component Regression - centralized regression model 
  %%%
  %%% Inputs  
    %     P_X  : projected training data points onto the first p principal componets  (number of samples  x p) 
    %     P_Xt : projected testing  data points onto the first p principal componets  (number of samples  x p) 
    %     D    : (at least) first p ordered (maximal first) eigenvalues of the centralized training data kernel matrix
    %     Y    : zero mean training outputs (number of samples  x dim) 
    %     Yt   : zero mean testing  outputs (number of samples  x dim) 
    % 
    %     Outputs: 
    %      
    %     Y_hat  : predicted training outputs (number of samples  x dim)   
    %     Yt_hat : predicted testing  outputs (number of samples  x dim)      
    %     B      : matrix (or vector) of regression coefficients (p x dim)     
     
   [n,p]=size(P_X);
   D=D(1:p)'; %%% only the first p-eigenvalues are used 
  
   B=diag(1./D)*P_X'*Y; 
   Y_hat=P_X*B;
   Yt_hat=P_Xt*B;
  