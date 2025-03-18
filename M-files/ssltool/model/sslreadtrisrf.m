function T = sslreadtrisrf(fileName)
%SSLREADTRISRF Read BVQX SRF triangular mesh file.
%   T = SSLREADTRISRF(FILENAME) FILENAME must be a valid SRF file
%   with extention .srf.

% Siyi Deng;
% 06-30-2011;

fh = fopen(fileName,'r','ieee-le');
fseek(fh,8,'cof'); 
nVert = fread(fh,1,'int32');
nFace = fread(fh,1,'int32');
fseek(fh,12,'cof');
T.Vertex = fread(fh,[nVert,3],'single');
fseek(fh,nVert*3*4,'cof');
fseek(fh,32,'cof');
fseek(fh,nVert*4,'cof');
for k = 1:nVert
    nVertNeighbor = fread(fh,1,'int32');
    fseek(fh,nVertNeighbor*4,'cof');    
end
T.Face = fread(fh,[3,nFace],'int32').'+1;
fclose(fh);

end % SSLREADTRISRF;



