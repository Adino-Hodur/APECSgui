function [B,T,U] = KerSIMPLS1(K,y,Fac);

 %%% Kernel SIMPLS  - single output     
 %%%
 %%% Inputs  
    %     K    : kernel (Gram) matrix (number of samples  x number of samples) 
    %     y    : training outputs (number of samples  x 1) 
    %     Fac  : number of latent vectors (components)  to extract 
    %
    %
    %     Outputs: 
    %     B      : matrix of dual-form regression coefficients (number of samples x 1)     
    %     T,U    : matrix of latent vectors (number of samples x Fac)  


[n,n]=size(K); 
In=eye(n);
T=[];U=[];

iK=K;
iY=y;


 for i=1:Fac      
   if (i == 1) 
       t = iK * iY;
       t = t / norm(t)  ;
       T  = [T , t];
       u = (iY * (iY' * t));
       u = u / norm(u); 
       U = [U ,   u  ];       
       
    else 
       %%% deflation  
       iY = iY- t * (t' * iY);
       iK = iK -t * (t' * iK);
       
       t  = iK * iY;  
       t = t / norm(t);
       T = [T , t];  
       u = (iY * (iY' * t));
       u = u / norm(u); 
       U = [U ,   u  ];             
       
   end   
 end       

 
B=U*inv(T'*K*U)*T'*y;
