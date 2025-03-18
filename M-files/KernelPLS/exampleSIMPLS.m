function exampleSIMPLS


%%%% example of approximation of the clean sinc function 
Fac=3;

%%% X Y training  inputs/outputs ; Xt Yt testing  inputs/outputs,  
X=rand(100,5); 
Y=rand(100,3);

Xt=rand(100,5); 
Yt=rand(100,3);

[n,dimX]=size(X);
[nt,dimX]=size(Xt);
dimY=size(Y,2);


  
%%%% zero-mean X and Y 
mnX=mean(X);
for i=1:dimX
    X(:,i) = X(:,i) - mnX(i);
    Xt(:,i)= Xt(:,i)- mnX(i);
end

mnY=mean(Y);
for i=1:dimY
    Y(:,i)=Y(:,i)-mnY(i);
    Yt(:,i)=Yt(:,i)-mnY(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% kernel matrices (train / test) generation 
K=Kernel(X,'L',1,0);
Kt=Kernel_Test(X,Xt,'L',1,0);

%%%% centralization K, K_t, (centralization of Y and Yt already done above)  
M=eye(n)-ones(n,n)/n;
Mt=ones(nt,n)/n;
Kt = (Kt - Mt*K)*M;
K=M*K*M;

[T,U,C,Q] = KerSIMPLS(K,Y,Fac);    %%% Kernel SIMPLS for multivariate output (this does not equal a) and b)   
[Tt]=KerSIMPLS_Test(K,Kt,T,Q,Y);  %%% in the case of multivariate outputs (> 1))                        
pYt=Tt*C;


[B1,T1]= PLS_SIMPLS(X,Y,Fac);
pYt1 = Xt * B1; 

norm(T-T1)
norm(pYt - pYt1)





