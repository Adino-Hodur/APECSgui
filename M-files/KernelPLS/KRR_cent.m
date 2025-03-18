function [Y_hat,Yt_hat,B]=KRR_cent(X,Xt,Y,Yt,reg,type,par1,par2)

%%%  Kernel Ridge Regression - centralized version 
    %%%
    %%% Inputs  
    %     X  : training data points  (number of samples  x dimension)
    %     Xt : testing  data points  (number of samples  x dimension)
    %
    %     reg  : regularization parameter 
    %     Y    : training outputs (number of samples  x dim) 
    %     Yt   : testing  outputs (number of samples  x dim) 
    %
    %                                                     par1    par2 
    %     type:  'G' Gaussian   Kernel  exp((|x-y|^2)/w)   w       0 
    %            'P' Polynomial Kernel  (<x,y>+c)^a:       a       c     
    %
    %     Outputs: 
    %      
    %     Y_hat  : predicted training outputs (number of samples  x dim)   
    %     Yt_hat : predicted testing  outputs (number of samples  x dim)      
    %     B      : matrix (or vector) of regression coefficients (p x dim)                                                        
    
    
[n,dim]=size(X);
[nt,dim]=size(Xt);

%%%% centering - outputs 
mY=mean(Y);
Y=Y-mY;
Yt=Yt-mY;

%%% training data kernel matrix construction  
K=Kernel(X,type,par1,par2);

%%% testing data kernel matrix construction 
Kt=Kernel_Test(X,Xt,type,par1,par2);

%%% centering of K 
M=eye(n)-ones(n,n)/n;
cen_K=M*K*M;
%%% centering of Kt 
Mt=ones(nt,n)/n;
cen_Kt = (Kt - Mt*K)*M; 

if (reg~=0)
     aI=eye(n)/reg;
     B=inv(cen_K+aI)*Y;
   else
     B=pinv(cen_K)*Y;
end    

%%%% KRR 
Y_hat=cen_K*B;
Yt_hat=cen_Kt*B;
