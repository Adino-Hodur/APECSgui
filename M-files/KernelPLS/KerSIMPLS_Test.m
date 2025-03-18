function [Tt] = KerSIMPLS_Test(K,Kt,T,Q,Y);

 %%% Kernel SIMPLS _ test    
 %%%
 %%% Inputs  
    %     K    : training kernel (Gram) matrix (number of samples  x number of samples) 
    %     Kt   : testing  kernel (Gram) matrix
    %     T    : latent vectors (components) 
    %     Q    : matrix of weights from KerSIMPLS
    %     Y    : training outputs (number of samples  x dim) 
    
       
    %     T    : matrix of test set latent vectors (number of samples x Fac)  



[n,Fac]=size(T);
In=eye(n);

Tt=[];


for i=1:Fac   
   
   if i > 1 
     t=Kt*(A*(Y*Q(:,i)));  
   else 
     t=(Kt*Y)*Q(:,i);     
   end   
       
   Tt=[Tt t];  
      
   %%% deflation 
   Tp=T(:,1:i);
   TK=Tp'*K; 
   iTKT=inv(TK*Tp);
   A=(In-Tp*iTKT*TK);
   
     
end       


