function x = ssliselectrode(D)
%SSLISELECTRODE True if the input is an electrode structure.

% Siyi Deng; 06-30-2011;

x = isstruct(D) && all(isfield(D,{'Coordinate'}))...
    && sslelectrodequalitycheck(D);
end % SSLISELECTRODE;


