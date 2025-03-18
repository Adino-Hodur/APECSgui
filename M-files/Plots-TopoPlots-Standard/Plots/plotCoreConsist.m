function hF = plotCoreConsist(res)

Weights = []; 

X=res.Xtrain; 
DimX = size(X);
X = reshape(X,DimX(1),prod(DimX(2:end)));


if isfield(res,'Corcondia1')
    numR = 2; 
    hF={'fig_CoreConsistRun1','fig_CoreConsistRun2'};
    
    X1=res.Xtrain1; 
    DimX1 = size(X1);
    X1 = reshape(X1,DimX1(1),prod(DimX1(2:end)));
    
else 
    numR=1;
    hF={'fig_CoreConsist'};
end 


if numR == 2 
   figure('Name',hF{1}); 
   diagonality=rr_corcond(reshape(X,DimX),res.Xfactors,Weights,1);
   title(['\fontsize{16}\color{red} Core consistency run 1: ',num2str(res.Corcondia),'%']);  
   figure('Name',hF{2});
   diagonality1=rr_corcond(reshape(X1,DimX1),res.Xfactors1,Weights,1); 
   title(['\fontsize{16}\color{red} Core consistency run 2: ',num2str(res.Corcondia1),'%']);  
else
   figure('Name',hF{1}); 
   diagonality=rr_corcond(reshape(X,DimX),res.Xfactors,Weights,1);
   title(['\fontsize{16}\color{red} Core consistency run 1: ',num2str(res.Corcondia),'%']);  
end 


 


