function v = sslmeshsmooth(T,ni,doShowWaitBar)
%SSLMESHSMOOTH Recursively smooth a mesh.
%   U = SSLMESHSMOOTH(T,NI) where
%   T is a SSL mesh struct.
%   NI is the number of iteration;
%   the smoothed vertices are stored in U.
%   U = SSLMESHSMOOTH(T,NI,1) shows a progress bar.

% Siyi Deng; 02-13-2011; 07-11-2011;

if nargin < 3, doShowWaitBar = false; end
v = T.Vertex;
nv = size(v,1);
vn = sslmeshvertexneighbor(T);

if nargin < 2, ni = 20; end
if doShowWaitBar, h = waitbar(0,'Please wait...'); end

for i = 1:ni
    for j = 1:nv  
        v(j,:) = 0.5.*v(j,:)+0.5.*mean(v(vn{j},:),1);
    end
    if doShowWaitBar, waitbar(i/(ni+1),h); end
end

if doShowWaitBar
    waitbar(1,h,'Done.'); 
    pause(0.1); 
    close(h); 
end
end % SSLMESHSMOOTH;


