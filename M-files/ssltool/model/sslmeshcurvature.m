function nj = sslmeshcurvature(T,vnb,vn)
%SSLMESHCURVATURE Curvature matrix at each vertex of a mesh.
%   C = SSLMESHCURVATURE(T,VNB,VN)
%   T is a SSL mesh struct;
%   VNB is the vertex neighbor list, usually from SSLMESHVERTEXNEIGHBOR;
%   VN is the vertex normal list, usually from SSLMESHVERTEXNORMAL;
%   C is the 3 x 3 x nVertex Curvature tensor for each vertex.

% Siyi Deng; 02-14-2011; 07-11-2011;

v = T.Vertex;
nv = size(v,1);
nj = zeros(3,3,nv);
for k = 1:nv 
    dn = bsxfun(@minus,vn(vnb{k},:),vn(k,:));
    d = bsxfun(@minus,v(vnb{k},:),v(k,:));
    dp = d-bsxfun(@times,d*vn(k,:).',vn(k,:));
    nj(:,:,k) = [dp;vn(k,:)]\[dn;[0 0 0]];
end
end % SSLMESHCURVATURE;

