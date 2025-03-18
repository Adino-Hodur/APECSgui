function sslmakeall
%SSLMAKEALL Compile mex files.

% Siyi Deng; 04-07-2011;

w = pwd;
r = sslrootpath;
o = filesep;
fileToMake = {...
    [r,o,'external'],'vertexneighboursdouble.c'};

for k = 1:size(fileToMake,1)
    try
        thePath = fileToMake{k,1};
        theFile = fileToMake{k,2};
        cd(thePath);
        mex(theFile,'-largeArrayDims');
        fprintf('%s build successful.\n',theFile);
    catch Me
        fprintf('%s build failed.\n',theFile);
        fprintf(Me.identifier);       
    end
end
cd(w);
end % SSLMAKEALL

