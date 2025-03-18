function x = sslishead(D)
%SSLIShead True if the input is an head structure.

% Siyi Deng; 08-31-2012;

x = isstruct(D) && all(isfield(D,...
    {'Face','Vertex','VertexNormal','VertexNormalJacobian'}))...
    && sslmeshqualitycheck(D);
end % SSLISHEAD;


