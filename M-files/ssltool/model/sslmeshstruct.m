function T = sslmeshstruct(v,f)
%SSLMESHSTRUCT Construct SSL mesh structure.
%   T = SSLMESHSTRUCT(V,F) constructs the SSL mesh struct T from vertex
%   list V and face list F.
%   T is a structure with fields T.Face and T.Vertex.

% Siyi Deng; 07-11-2011;

T.Vertex = [];
T.Face = [];
if nargin > 0, T.Vertex = v; end
if nargin > 1, T.Face = f; end
end % SSLMESHSTRUCT;