function [T,U,C,Q] = KerSIMPLS(K,Y,Fac);

 %%% Kernel SIMPLS    
 %%%
 %%% Inputs  
    %     K    : kernel (Gram) matrix (number of samples  x number of samples) 
    %     Y    : training outputs (number of samples  x dim) 
    %     Fac  : number of latent vectors (components)  to extract 
    %
    %     Outputs: 
    %     C      : matrix of regression coefficients (number of components x dimY)     
    %     T,U    : matrix of latent vectors (number of samples x Fac)  
    %     Q      : matrix of weights for T  (dimY x Fac  


[n,n]=size(K); 

In=eye(n);
T=[];
U=[];
Q=[];


KY=K*Y;

iSS=Y'*KY;
SS=iSS;

for i=1:Fac   
   
   [q,s]=eigs(SS,1);
      
   if i > 1 
     A=(In-KT*iTKT*T');  
     t=A*(K*(Y*q));  
   else 
     t=KY*q;     
   end   
   normT(i,i)=1/norm(t);
   t=t*normT(i,i);
   
   c=Y'*t;          %%% Y weights 
   u=Y*c; 
   u=u/norm(u);
   
   %if (i > 1 )
   %   u = u - T*(T'*u); %%% orthogonalize u to previous t values    
   %end    
   
   T=[T t];  
   U=[U u];
   Q=[Q,q];  
   
   %%% deflation 
   KT=K*T; 
   iTKT=inv(T'*KT);
   SS=iSS-Y'*KT*iTKT*KT'*Y;               
     
end   

Q=Q*normT; 

C=T'*Y; 

