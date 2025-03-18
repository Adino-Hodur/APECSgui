function isOk = sslelectrodequalitycheck(E)
%SSLELECTRODEQUALITYCHECK Check the quality of a electrode data structure.
%   X = SSLELECTRODEQUALITYCHECK(E) checks if the input electrode data
%   structure E is suitable for ssltool. X is true if E passes the check.

% Siyi Deng; 02-14-2011;

c = E.Coordinate;
a = E.Label;
isOk = true;
if size(c,2) ~= 3, isOk = false; end
if ~isempty(E.Label) && (size(a,1) ~= size(c,1)), isOk = false; end
if size(c,1) > 3000 || size(c,1) < 1, isOk = false; end
end % SSLELECTRODEQUALITYCHECK;

