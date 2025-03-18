function isOk = sslmeshqualitycheck(T)
%SSLMESHQUALITYCHECK Check the quality of a triangular mesh.
%   X = SSLMESHQUALITYCHECK(T) checks the trimesh given by T. X is true if
%   T passes the criterion. T is rejected if:
%   T is not a triangular mesh.
%   T is not in 3D space.
%   T is not a closed mesh (any edge referenced by only 1 face).
%   T has too many faces ( > 6000) or vertices ( > 3000);

% Siyi Deng; 02-12-2011;

v = T.Vertex;
f = T.Face;
nv = size(v,1);
isOk = true;
if nv < 4, isOk = false; end
if size(v,2) ~= 3, isOk = false; end
if size(f,2) ~= 3, isOk = false; end
if min(f(:)) < 1, isOk = false; end
if max(f(:)) > nv, isOk = false; end
if any(f(:)-round(f(:)) ~= 0), isOk = false; end

if size(v,1) > 3612, isOk = false; end
if size(f,1) > 7220, isOk = false; end

R = TriRep(f,v);
ea = cellfun(@length,edgeAttachments(R,R.edges));
if any(ea ~= 2), isOk = false; end
end % SSLMESHQUALITYCHECK;

