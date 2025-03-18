function out = sslgeo(xyzD,xyzI,w,n,nj)
%SSLGEO SSL-Geo algorithm.
%   SSLGEO(XD,XI,W,N,NJ)
%   XD input coordinates.
%   XI out coordinates;
%   W differentiation parameter;
%   N vertex normals;
%   NJ mesh curvature tensor at each vertex;

% Siyi Deng; 09-11-2010;

xD = xyzD(:,1);
zD = xyzD(:,3);
yD = xyzD(:,2);
xI = xyzI(:,1);
yI = xyzI(:,2);
zI = xyzI(:,3);
nD = size(xyzD,1);
if nargin < 3 || isempty(w), w = []; end
[~,qm,pm,dd,ww] = sslphs(xyzD,xyzI,w);
wd = ww+dd;
lwd = log(wd);
kuv = @(u,v)(4*u.*v.*(3+2*lwd));
kuu = @(uu)(4*uu.*(3+2.*lwd)+2*wd.*(1+2*lwd));
ku = @(u)((1+2*lwd).*2.*wd.*u);
n = sslunitize(n);
n1 = repmat(n(:,1),1,nD);
n2 = repmat(n(:,2),1,nD);
n3 = repmat(n(:,3),1,nD);
nj = reshape(nj,9,[]);
n1x = repmat(nj(1,:).',1,nD);
n2x = repmat(nj(2,:).',1,nD);
n3x = repmat(nj(3,:).',1,nD);
n1y = repmat(nj(4,:).',1,nD);
n2y = repmat(nj(5,:).',1,nD);
n3y = repmat(nj(6,:).',1,nD);
n1z = repmat(nj(7,:).',1,nD);
n2z = repmat(nj(8,:).',1,nD);
n3z = repmat(nj(9,:).',1,nD);
rx = bsxfun(@minus,xI,xD.');
ry = bsxfun(@minus,yI,yD.');
rz = bsxfun(@minus,zI,zD.');
fx = ku(rx);
fy = ku(ry);
fz = ku(rz);
out = (kuu(rx).*(1-n1.^2)+kuu(ry).*(1-n2.^2)+kuu(rz).*(1-n3.^2)...
    -2*(kuv(rx,ry).*n1.*n2+kuv(rx,rz).*n1.*n3+kuv(rz,ry).*n3.*n2)...
    -(n1x+n2y+n3z).*(fx.*n1+fy.*n2+fz.*n3)...
    -fx.*(n1x.*n1+n2x.*n2+n3x.*n3)...
    -fy.*(n1y.*n1+n2y.*n2+n3y.*n3)...
    -fz.*(n1z.*n1+n2z.*n2+n3z.*n3))*pm;
n1 = n(:,1);
n2 = n(:,2);
n3 = n(:,3);
n1x = nj(1,:).';
n2x = nj(2,:).';
n3x = nj(3,:).';
n1y = nj(4,:).';
n2y = nj(5,:).';
n3y = nj(6,:).';
n1z = nj(7,:).';
n2z = nj(8,:).';
n3z = nj(9,:).';
term1 = (n1x+n2y+n3z);
term2 = n1.*n1x+n2.*n1y+n3.*n1z;
term3 = n1.*n2x+n2.*n2y+n3.*n2z;
term4 = n1.*n3x+n2.*n3y+n3.*n3z;
dq = -[...
    term2+n1.*term1,...
    term3+n2.*term1,...
    -2+2*n1.^2+(term2+n1.*term1).*xI*2,...
    2*n1.*n2+(term3+n2.*term1).*xI+...
        (term2+n1.*term1).*yI,...
    -2+2*n2.^2+(term3+n2.*term1).*yI*2,...
    term4+n3.*term1,...
    2*n1.*n3+(term4+n3.*term1).*xI+...
        (term2+n1.*term1).*zI,...
    2*n2.*n3+(term4+n3.*term1).*yI+...
        (term3+n2.*term1).*zI,...
    -2+2*n3.^2+(term4+n3.*term1).*zI*2];
out = -out-dq*qm(2:10,:);
end % SSLGEO;




