function vnb = sslmeshvertexneighbor(T)
%SSLMESHVERTEXNEIGHBOR Mesh Vertex 1-ring Neighbor info.
% VNB = SSLMESHVERTEXNEIGHBOR(T) gives the 1-ring neighbor vertex indices
% for input mesh T. VNB is a nVertex x 1 cell array.

% Siyi Deng; 03-24-2011; 07-11-2011;

vnb = vertexneighboursdouble(T.Face(:,1),T.Face(:,2),T.Face(:,3),...
    T.Vertex(:,1),T.Vertex(:,2),T.Vertex(:,3));
end % SSLMESHVERTEXNEIGHBOR;
