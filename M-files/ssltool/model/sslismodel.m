function x = sslismodel(M)
%SSLISMODEL True if the input is a model structure.

% Siyi Deng; 04-07-2011;

x = isstruct(M) && all(isfield(M,{'Head','Electrode'})) && ...
    sslishead(M.Head) && ssliselectrode(M.Electrode);
end % SSLISMODEL;

