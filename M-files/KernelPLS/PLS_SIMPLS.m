function [B,T,U,R]= PLS_SIMPLS(X,Y,Fac);

  %%% Partial Least Squares - de Jong's  SIMPLS algorithm
  %%%  
  %%%
  %%% Inputs  
    %     X    : block A matrix (number of samples  x dim1) - zero mean !
    %     Y    : block B matrix (number of samples  x dim2) - zero mean !
    %     Fac  : number of latent vectors (components)  to extract 
    
    %     Outputs: 
    %     B      : matrix of regression coefficients  
    %     T,U    : matrix of latent vectors (number of samples x Fac)  
    
   
   
   
[n,d]=size(X);       

U=[];V=[];
T=[];Q=[];
R=[];P=[];


%%%% SIMPLS

S=X'*Y; 

for i=1:Fac 
    
    [r,s,q1]=svds(S,1);   %%% X weights   
    %[q,s]=eigs(S'S,1);   %%% if you do [q,s]=eigs(S'S,1) instead ; Y weights   
    %r=S*q;          
    
    t=X*r;             %%% X scores 
    norT(i,i)=1/norm(t);
    t=t*norT(i,i);
                   
    p=X'*t;          %%% X loadings  X = T*P' + E 
    q=Y'*t;          %%% Y weights 
    
    u=Y*q;           %%% Y scores 
    u=u/norm(u); 
    
    v=p;  
    
    if i > 1          
        v = v - V*(V'*p);    %%% orthogonalize v to previous loadings
    %    u = u - T*(T'*u);    %%% orthogonalize u to previous t values 
    end 
    
    v=v/sqrt(v'*v);
    S =  S - v * (v' * S);  %%% deflate S    
           
    
    P=[P p];Q=[Q q];
    T=[T t];U=[U u];
    R=[R r];V=[V v];
    
end     


B=R*norT*Q'; 
