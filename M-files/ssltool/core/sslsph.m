function out = sslsph(xyzD,xyzI,w)
%SSLSPH SSL-Sph algorithm.
%   M = SSLSPH(XD,XI,W)
%   XD input coordinates.
%   XI out coordinates;
%   W differentiation parameter;

% Siyi Deng; 09-11-2010;

if nargin < 3, w = []; end
nI = size(xyzI,1);
nD = size(xyzD,1);
xyzD = sslunitize(xyzD);
xyzI = sslunitize(xyzI);
rID = xyzI*(xyzD.');
[~,qm,pm,dd,ww] = sslphs(xyzD,xyzI,w);
xI = xyzI(:,1);
yI = xyzI(:,2);
zI = xyzI(:,3);
wd = ww+dd;
lwd = log(wd);
out = ((8*lwd+12).*(ones(nI,nD)-rID.^2)+(8*wd.*lwd+4*wd).*rID)*pm+...
    (-2).*[xI,yI,3*xI.^2-1,3*xI.*yI,3*yI.^2-1,...
    zI,3*xI.*zI,3*yI.*zI,3*zI.^2-1]*qm(2:10,:);
out = -out;
end % SSLSPH;


