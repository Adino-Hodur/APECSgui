function [Y_hat,Yt_hat,B]=PCR_cent(X,Xt,Y,Yt,n_pc)

%%%  (linear) Principal Component Regression 
    %%%
    %%% Inputs  
    %     X  : training data points  (number of samples  x dimension)
    %     Xt : testing  data points  (number of samples  x dimension)
    %
    %     n_pc : number of principal componets onto which data are projected 
    %     Y    : training outputs (number of samples  x dim) 
    %     Yt   : testing  outputs (number of samples  x dim) 
    % 
    %     Outputs: 
    %      
    %     Y_hat  : predicted training outputs (number of samples  x dim)   
    %     Yt_hat : predicted testing  outputs (number of samples  x dim)      
    %     B      : matrix (or vector) of regression coefficients (p x dim)                                                        
    
    
[n,dim]=size(X);
[nt,dim]=size(Xt);

%%%% centering 
mX=mean(X);
mY=mean(Y);
for i=1:dim
    X(:,i)=X(:,i)-mX(i);
    Xt(:,i)=Xt(:,i)-mX(i);
end 
Y=Y-mY;
Yt=Yt-mY;

%%%%%%% PC extraction 
[u,D,W] = svd(X);
D = diag(D);
totalvar = sum(D);
Exp = 100*D/totalvar;
clear u 
%%%%% PC projection 
D=D(1:n_pc)';
D=D.^2;
W=W(:,1:n_pc);
P_X=X*W;
P_Xt=Xt*W; 

clear X Xt 

%%%% PCR 
B=diag(1./D)*P_X'*Y; 
Y_hat=P_X*B;
Yt_hat=P_Xt*B;
