function [fM,qM,pM,dd,ww] = sslphs(xyzD,xyzI,w)
%SSLPHS Polyharmonic spline.
%   SSLPHS(XD,XI,W)
%   XD input coordinates.
%   XI out coordinates;
%   W differentiation parameter;

% Siyi Deng; 08-13-2010;

xD = xyzD(:,1);
yD = xyzD(:,2);
zD = xyzD(:,3);
xI = xyzI(:,1);
yI = xyzI(:,2);
zI = xyzI(:,3);
if nargin < 3 || isempty(w), w = (max(yD(:))-min(yD(:)))/10/2; end
ww = w.^2;
eD = [ones(size(xD)),xD,yD,xD.^2,xD.*yD,yD.^2,zD,zD.*xD,zD.*yD,zD.^2];
kM = ssldist(xyzD,xyzD)+ww;
kM = log(kM).*(kM.^2);
kMi = pinv(kM);
eki = eD.'*kMi;
qM = pinv(eki*eD)*(eki);
pM = (kMi-kMi*eD*qM);
dd = ssldist(xyzI,xyzD);
kI = dd+ww;
kI = log(kI).*(kI.^2);
eI = [ones(size(xI)),xI,yI,xI.^2,xI.*yI,yI.^2,zI,zI.*xI,zI.*yI,zI.^2];
fM = kI*pM+eI*qM;
end % SSLPHS;

