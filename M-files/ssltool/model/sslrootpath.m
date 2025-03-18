function p = sslrootpath
%SSLROOTPATH The root installation path of this toolbox.
%   PATH = SSLROOTPATH

% Siyi Deng; 04-02-2011;

p = fileparts(which('ssltool'));
end % SSLROOTPATH;