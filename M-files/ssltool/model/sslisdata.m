function x = sslisdata(D)
%SSLISDATA True if the input is a data structure.

% Siyi Deng; 04-07-2011;

x = isstruct(D) && all(isfield(D,{'Data'}));
end % SSLISDATA;


