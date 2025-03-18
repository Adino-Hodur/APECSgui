function vn = sslmeshvertexnormal(T)
%SSLMESHVERTEXNORMAL Unit Vertex Normals of a mesh.
%   VN = SSLMESHVERTEXNORMAL(T) computes unit vertex normal for input mesh
%   struct T. VN is a nVertex x 3 list of normals.

% Siyi Deng; 02-14-2011; 07-11-2011;

v = T.Vertex;
f = T.Face;
T = TriRep(f,v);
nv = size(v,1);
fl = vertexAttachments(T);
vn = zeros(nv,3);
for k = 1:nv    
    for c = 1:numel(fl{k})
        if f(fl{k}(c),2) == k
            fTmp = f(fl{k}(c),[2 3 1]); 
        elseif f(fl{k}(c),3) == k
            fTmp = f(fl{k}(c),[2 3 1]); 
        else
            fTmp = f(fl{k}(c),:);
        end
        x21 = v(fTmp(2),:)-v(fTmp(1),:);
        x31 = v(fTmp(3),:)-v(fTmp(1),:);                
        vn(k,:) = vn(k,:)+sslcp(x21,x31)./ssln2(x21)./ssln2(x31);
    end
end
vn = sslunitize(vn);
end % SSLMESHVERTEXNORMAL;

