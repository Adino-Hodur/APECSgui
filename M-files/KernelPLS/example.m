function example 

%%%% example of approximation of the clean sinc function 

%%% X Y training  inputs/outputs ; Xt Yt testing  inputs/outputs,  
X=[-10:0.2:10]';
Xt=[-10:0.25:10]';
for i=1:length(X)
    if X(i) ~=0
       cY(i,1)=sin(abs(X(i)))/abs(X(i));
    else    
       cY(i,1)=1;
    end    
end        
for i=1:length(Xt)
    if Xt(i) ~=0
       cYt(i,1)=sin(abs(Xt(i)))/abs(Xt(i));
    else    
       cYt(i,1)=1;
    end   
end    
[n,dimX]=size(X);
[nt,dimX]=size(Xt);

Y=cY+randn(length(cY),1)*0.05;
Yt=cYt+randn(length(cYt),1)*0.05;


num_of_PC=25;
%%% KPCA  : Gaussian kernel of width 1 ;
[P_X,P_Xt,W,D]=KPCA(X,Xt,num_of_PC,'G',1,0); 


%%% EM_KPCA  : Gaussian kernel of width 1 ; 
[emP_X,emP_Xt,emD]=EM_KPCA(X,Xt,num_of_PC,'G',1,0); 

% figure(5)
% plot(D(1:num_of_PC)-sqrt(emD),'r')
% title('Difference among eigenvalues extracted by KPCA and EM-KPCA')  
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% 1)  KPCR - not centralized model %%%%
  [Y_hat,Yt_hat,B]=KPCR(P_X,P_Xt,D,Y,Yt); 
  %%% KPCR - using components extracted by EM_KPCA 
  [emY_hat,emYt_hat,B]=KPCR(emP_X,emP_Xt,emD,Y,Yt); 
  %%% Plotting 
  % training  
  figure(1)
  plot(cY,'k'); 
  hold on 
  plot(Y_hat,'r');
  plot(emY_hat,'');
  title('Results on KPCR using components extracted by KPCA and EM-KPCA - train set ')  
  % testing    
  figure(2)
  plot(cYt,'k');
  hold on 
  plot(Yt_hat,'r');
  plot(emYt_hat,'');
  title('Results on KPCR using components extracted by KPCA and EM-KPCA - test set ')  
  MSE=mean((cY-Y_hat).^2);
  MSEt=mean((cYt-Yt_hat).^2);
  emMSE=mean((cY-emY_hat).^2);
  emMSEt=mean((cYt-emYt_hat).^2);
  

  disp('*****************************************');
  disp('MSE train KPCR: ');disp(MSE);
  disp('MSE test  KPCR: ');disp(MSEt);
  disp('MSE train emKPCR: ');disp(emMSE);
  disp('MSE test  emKPCR: ');disp(emMSEt)
  disp('*****************************************');


%   %%% Plotting 
%   % training  
%   figure(3)
%   plot(Y,'k'); 
%   hold on 
%   plot(Y_hat,'r');
%   title('Difference between KPCR, KPLS and KRR - train set ')  
%   % testing    
%   figure(4)
%   plot(Yt,'k');
%   hold on 
%   plot(Yt_hat,'r');
%   title('Difference between KPCR, KPLS and KRR - test set ')  
%   MSE=mean((Y-Y_hat).^2);
%   MSEt=mean((Yt-Yt_hat').^2);
%   disp('*****************************************');
%   disp('MSE train KPCR: ');disp(MSE);
%   disp('MSE test  KPCR: ');disp(MSEt);
%   disp('*****************************************');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% 2)  KPCR - centralized model %%%%
mn=mean(Y);
Y=Y-mn;
Yt=Yt-mn;
[Y_hat,Yt_hat,B]=KPCR_cent(P_X,P_Xt,D,Y,Yt); 
Y_hat=Y_hat+mn;
Yt_hat=Yt_hat+mn;

%%% Plotting 
% training 
figure(3)
plot(cY,'k'); 
hold on 
plot(Y_hat,'b');
title('Results using (centralized) KPCR, KPLS and KRR - train set ')  
% testing 
figure(4)
plot(cYt,'k'); 
hold on 
plot(Yt_hat,'b');
title('Results using  (centralized) KPCR, KPLS and KRR - test set ')  
MSE=mean((cY-Y_hat).^2);
MSEt=mean((cYt-Yt_hat).^2);
disp('*****************************************');
disp('MSE train (centralized) KPCR :');disp(MSE);
disp('MSE test  (centralized) KPCR :');disp(MSEt);
disp('*****************************************');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% 3)  KPLS - (centralized model) %%%%%%
%%%% kernel matrices (train / test) generation 
K=Kernel(X,'G',1,0);
K_t=Kernel_Test(X,Xt,'G',1,0);

%%%% centralization K, K_t, (centralization of Y and Yt already done above)  
M=eye(n)-ones(n,n)/n;
Mt=ones(nt,n)/n;
K_t = (K_t - Mt*K)*M;
K=M*K*M;

%mn=mean(Y);
%Y=Y-mn;
%Yt=Yt-mn;

%%%% number of used latent vectors (componets)   
Fac=10; 
%[B,T]=KerNIPALS(K,Y,Fac,0);    %%% a) NIPALS based KPLS  
%[B,T] = KerPLS_eig(K,Y,Fac,0); %%% b) K*Y*Y'*t = a *t based KPLS 
[B,T,U]=KerSIMPLS1(K,Y,Fac);   %%% c) Kernel SIMPLS for single output (this equals a) and b))   
%%%% prediction (train / test)
%Y_hat=T*(T'*Y);   %%%  this is an alternative way for predictions on training set
Y_hat=K*B + mn    ;
Yt_hat=K_t*B + mn ;


%[T,U,C,Q] = KerSIMPLS(K,Y,Fac);   %%% d) Kernel SIMPLS for multivariate output (this does not equal a) and b)   
%[Tt]=KerSIMPLS_Test(K,K_t,T,Q,Y);  %%%    in the case of multivariate outputs (> 1))                        
%%%% prediction (train / test)
%Y_hat=T*C + mn    ;
%Yt_hat=Tt*C + mn ;



%%% Ploting 
% training 
figure(3)
plot(Y_hat,'m');
% testing 
figure(4)
plot(Yt_hat,'m');
MSE=mean((cY-Y_hat).^2);
MSEt=mean((cYt-Yt_hat).^2);
disp('*****************************************');
disp('MSE train KPLS :');disp(MSE);
disp('MSE test  KPLS :');disp(MSEt);
disp('*****************************************');


%%% 4)  KRR - (centralized model) %%%%%%
reg=500; %%% regularization term (actual regularization term :  1/reg)
[Y_hat,Yt_hat,B]=KRR_cent(X,Xt,Y,Yt,reg,'G',1,0);
Y_hat=Y_hat+mn;
Yt_hat=Yt_hat+mn;

%%% Ploting 
% training 
figure(3)
plot(Y_hat,'g');
% testing 
figure(4)
plot(Yt_hat,'g');
MSE=mean((cY-Y_hat).^2);
MSEt=mean((cYt-Yt_hat).^2);
disp('*****************************************');
disp('MSE train (centralized) KRR :');disp(MSE);
disp('MSE test  (centralized) KRR :');disp(MSEt);
disp('*****************************************');

