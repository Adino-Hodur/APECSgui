function T = sslreadtrioff(fileName)
%SSLREADTRIOFF Read OFF triangular mesh file.
%   T = SSLREADTRIOFF(FILENAME) FILENAME must be a valid OFF ascii file
%   with extention .off.  Only supports basic format OFF, which means
%   formats like COFF, NOFF ... are NOT supported.

% Siyi Deng;
% 06-25-2011;

fh = fopen(fileName,'rt');
s = fgetl(fh);

if strcmpi(s,'OFF')
    vertFormat = '%f %f %f';
else
    error('SSLREADTRIOFF:BadArgument','Not supported OFF file format.');
end

t = fscanf(fh,'%u %u %u',[1 3]);
nV = t(1);
nF = t(2);
tmp = textscan(fh,vertFormat,nV,'CollectOutput',true,'CommentStyle','#');
T.Vertex = tmp{1};
tmp = textscan(fh,'%*u %u %u %u',nF,'CollectOutput',true,'CommentStyle','#');
T.Face = double(tmp{1}+1);
fclose(fh);

end % SSLREADTRIOFF;

