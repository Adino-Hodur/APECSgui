function [fH,P,ypred] = getWeights4BCI2000(fName,typeOut,res,X)

%%%% Returns the projection matrix P which can be used for the prediction
%%%% ypred = X * P;
%%%% where X is a vector (or a matrix) where columns
%%%% are concatenated variables;
%%%% i.e. consider 32 frequency lines and 8 electrodes will be used ....
%%%% then the form is: elect1 x elect2 x elect 3 .....  it will be 32 x 8 = 256

Fac=res.numFac2Save;

% if strcmp(res.Method,'KPLS') && strcmp(res.kernelFcn,'Linear')
%     res.Method='linPLS'; 
% end 

% switch res.Method
%     case {'NPLS','linPLS'}
        %%%%% compute W,Q projection matrices considering all Atoms
        DimX = size(res.Xfactors{1},1);
        for j = 2:length(res.Xfactors)
            DimX(j) = size(res.Xfactors{j},1);
        end
        DimY = size(res.Yfactors{1},1);
        for j = 2:length(res.Yfactors)
            DimY(j) = size(res.Yfactors{j},1);
        end
        W = [];
        for f = 1:Fac
            w = res.Xfactors{end}(:,f);
            for o = length(DimX)-1:-1:2
                w = kron(w,res.Xfactors{o}(:,f));
            end
            W = [W w];
        end
        Q = [];
        for f = 1:Fac
            q = res.Yfactors{end}(:,f);
            for o = length(DimY)-1:-1:2
                q = kron(q,res.Yfactors{o}(:,f));
            end
            Q = [Q q];
        end
        
        %%%% coefficients
        P=W*res.B(1:Fac,1:Fac)*Q';
        
        %%% if you need to do predictions
        if nargin > 4
            Dimx = size(X);
            X = reshape(X,Dimx(1),prod(Dimx(2:end)));
            ypred= X * P;
        else
            ypred = [];
        end
        
        %%%% generate text file with the weights matrix
        numVar = length(res.varUsed);
        switch typeOut
            case 'labelHz'
                fBin   = res.featureIn';
            case 'bin'
                [~,fBin]=intersect(res.featureAll,res.featureIn);
                fBin = fBin';         
        end
                        
        lenP = length(P);
        c1   = reshape(repmat(1:numVar,length(fBin),1),lenP,1);
        c2   = repmat(fBin,numVar,1);
        c3   = ones(lenP,1);
        c4   = P;
        bigC = [c1 c2 c3 c4]';
% end 

switch typeOut
    case 'labelHz'
        fid = fopen(fName,'wt');
        fprintf(fid,'%d\t %3.2fHz\t %d\t  %12.16f \n',bigC);
        fH = fclose(fid);
    case 'bin'
        fid = fopen(fName,'wt');
        fprintf(fid,'%d\t %d\t %d\t  %12.16f \n',bigC);
        fH = fclose(fid);
end

if ~fH
    hM=msgbox('BCI2000 weights were saved .... ','File saved');
    uiwait(hM);
else 
    hM=errordlg('Error !!! BCI2000 file was not saved properly ... ','File not saved');
    uiwait(hM);  
end



 




