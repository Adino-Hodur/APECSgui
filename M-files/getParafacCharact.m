function res = getParafacCharact(X,res,Weights)


warning off

DimX = size(X);
X = reshape(X,DimX(1),prod(DimX(2:end)));

Factors=res.Xfactors; 
% Convert to old format
NewLoad = Factors;
ff = [];
for f=1:length(Factors)
    ff=[ff;Factors{f}(:)];
end
Factors = ff;

factors = Factors;
ord=length(DimX);
Fac=length(factors)/sum(DimX);
lidx(1,:)=[1 DimX(1)*Fac];
for i=2:ord
    lidx=[lidx;[lidx(i-1,2)+1 sum(DimX(1:i))*Fac]];
end

%%% Compute DIAGONALITY OF T3-CORE
res.Corcondia=corcond(reshape(X,DimX),NewLoad,Weights);

model = nmodel(NewLoad);
model = reshape(model,DimX(1),prod(DimX(2:end)));

%%% Compute RESIDUAL VARIANCE
aa=ceil(sqrt(ord));
bb=ceil(ord/aa);
for i=1:ord    
    r=nshape(reshape(X-model,DimX),i)';
    res.varian{i}=(stdnan(r).^2)'; 
    
    A=reshape(factors(lidx(i,1):lidx(i,2)),DimX(i),Fac);
    res.lev{i}=diag(A*pinv(A'*A)*A'); %  + 100*eps;           
end



