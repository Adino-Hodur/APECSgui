function pathName=getRelPath(pathName)

sF=strsplit(pwd,filesep);  

homeFolder=sF{end}; % 'APECSgui';

poz=strfind(pathName,homeFolder);
pathName=['.',pathName(poz+length(homeFolder):end)];
