function [B,T,U] = KerPLS_eig(K,Y,Fac,show);

 %%% Kernel Partial Least Squares Regression - nonlinear version of Rannar's kernel PLS regression 
 %%%                                           based on K*Y*Y' matrix    
 %%%
 %%% Inputs  
    %     K    : kernel (Gram) matrix (number of samples  x number of samples) 
    %     y    : training outputs (number of samples  x dimY) 
    %     Fac  : number of score vectors (components, latent vectors)  to extract 
    %     show : 1 - print number of iterations needed (default) / 0 - do not print 
    %
    %     Outputs: 
    %     B      : matrix of regression coefficients (number of samples x dimY)     
    %     T,U    : matrix of latent vectors (number of samples x Fac)  


if ~exist('show')==1
  show=1;
end

%%%% max number of iterations  
maxit=20;
%%%% criterion for stopping 
crit=1e-8;

[n,n]=size(K);
Ie=eye(n);
T=[];
U=[];

Kres=K;
Yres=Y;
Ky=Yres*Yres';

for num_lv=1:Fac
    
  KY=Kres*Ky;   
  %%%% NIPALS for the extraction of t from KY (or you may use svds)    
  %initialization 
  t=randn(n,1);tgl=t+2;it=0;
  
  while (norm(t-tgl)/norm(t))>crit & (it<maxit)   
      tgl=t;
      it=it+1;
      
      t=KY*tgl;
      t=t/norm(t);
  end

  u=Yres*(Yres'*t);   
  T=[T t];
  U=[U u];
  tt=t*t';
  
  %%% deflation procedures  
  Kres=Kres-t*(t'*Kres);
  Yres=Yres-t*(t'*Yres);
  Ky=Yres*Yres';
  
  if show~=0
     disp(' ') 
     fprintf('number of iterations: %g',it);
     disp(' ')
  end
        
end   

B=U*inv(T'*K*U)*T'*Y;
