
atom=6; 

X1=permute(res.Xtest,[1 2 3]);
X11 = reshape(X1,size(X1,1),[],1);

reg1=reshape(res.reg{atom},1,23*8);
y1=X11*reg1';
norm(y1-res.ypred_test(:,atom)) ; 

[T,Wj,Wk]=fac2let(res.Xfactors);

