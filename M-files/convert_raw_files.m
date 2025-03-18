d.X=dat.eeg;
d.Y=dat.events; 

header.Xsize   = size(d.X); 
header.Ysize   = size(d.Y);
header.Xlabels = dat.elect; 
header.sampleFreq = 128; 
header.sampleFreqUnit = 'Hz'; 

clear dat 
dat = d ; 
clear d 