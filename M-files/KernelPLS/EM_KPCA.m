function [P_X,P_Xt,D]=EM_KPCA(X,Xt,n_pc,type,par1,par2)

    % Threshold for norm difference in E-M
    Epsilon = 0.005;

    %%% Expectation Maximization Kernel Principal Component Analysis
    %%%
    %%% Inputs  
    %     X  : training data points  (number of samples  x dimension)
    %     Xt : testing  data points  (number of samples  x dimension)
    %
    %     n_pc : number of principal componets onto which data are projected 
    %
    %                                                      par1    par2 
    %     type:  'G' Gaussian   Kernel  exp((|x-y|^2)/w)   w       0 
    %            'P' Polynomial Kernel  (<x,y>+c)^a:       a       c     
    %
    %%  Output 
    %     P_X  : projection of training data  onto the first n_pc  principal componets (number of samples  x n_pc)
    %     P_Xt : projection of testing  data  onto the first n_pc  principal componets (number of samples  x n_pc)
    %        
    %     D    : eigenvalues of the centralized (cen_K) training data kernel matrix 
    %          : !!!!  eigenvalues coresponding to the sample covariance matrix are sqrt(D)/(n-1)

       
    [n,dim]=size(X);
    [nt,dim]=size(Xt);

    %%% training data kernel matrix construction  
    K=Kernel(X,type,par1,par2);
    
    %%% centering of K 
    M=eye(n)-ones(n,n)/n;
    cen_K=M*K*M;
    

    %%% EM-KPCA 
    %%% in contrast to the NC paper there is a change in notation : X <--> Y
    

    Gamma=randn(n,n_pc); %%% random intialization 

    iter=1;
    err(1)=Epsilon+1; 
        
    while err(iter) >  Epsilon     
      % iter  
      %%%%% E-step 
      LC=Gamma'*cen_K;
      Y=inv(LC*Gamma)*LC;

      %%%%% M-step 
      Gamma_old=Gamma;

      Gamma=Y'*inv(Y*Y'); 
      
      iter=iter+1;   
      err(iter)=norm(Gamma_old-Gamma);
      

    end 
    
    
    %%% getting eigenvalues 

    ort_Gamma=orth(Gamma);
    Y=cen_K*ort_Gamma;
    [V,D]=eig(cov(Y));
    [D,ind]=sort(diag(D)*(n-1));
    D=flipud(D);
    ind=flipud(ind);
   
    V=V(:,ind);             %%% sorting  eigenvectors  
    YV=Y*V;                 %%% rotation to Kernel PCA  
 
    %%% training data projection

    P_X=YV;
        
    %%% TESTING PART 
    
    % testing data kernel matrix construction 
    Kt=Kernel_Test(X,Xt,type,par1,par2);
    
    %%% centering of Kt 
    Mt=ones(nt,n)/n;
    cen_Kt = (Kt - Mt*K)*M;

        
    %%% testing  data projection 
    P_Xt=cen_Kt*ort_Gamma*V;
    
