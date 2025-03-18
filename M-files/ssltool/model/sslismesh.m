function x = sslismesh(D)
%SSLISMESH True if the input is a mesh structure.
%   X = SSLISMESH(T) returns TRUE if D is a valid SSL mesh struct as
%   created from SSLMESHSTRUCT.
%
%   See also SSLMESHSTRUCT.

% Siyi Deng; 06-30-2011; 07-11-2011;

x = isstruct(D) && all(isfield(D,{'Face','Vertex'}))...
    && size(D.Face,2) == 3 && size(D.Vertex,2) == 3;
end % SSLISMESH;


