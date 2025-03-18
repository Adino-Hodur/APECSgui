%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nX = constNwayMatrix(X,param)

if iscell(X)
    tX = [];
    for c=1:length(X)
        tX = [tX ; X{c}];
    end
    X = tX; 
    clear tX 
end

nTimes       = size(X,1);
nVar         = length(param.var2use); 
nFeatures    = size(X,2)/nVar; 

nX = zeros(nTimes,nVar,nFeatures);

%%%%%%% construct N-way matrix X 
for i1=1:nTimes
    for i2=1:nVar
        bg=(i2-1)*nFeatures + 1;      
        nX(i1,i2,1:nFeatures)=X(i1,bg:(bg + nFeatures -1));   
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%