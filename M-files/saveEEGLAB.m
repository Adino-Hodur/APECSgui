function saveEEGLAB(eeg,fName)

if nargin < 2 
    if isfield(eeg,'filepath') 
        fName = [eeg.filepath, eeg.setname]; 
    else 
        fName = eeg.setname; 
    end 
end 

dat.X=double(eeg.data(:,:)'); 

%%%% convert events to continous file 
dat.Y=zeros(size(dat.X,1),1);

if isfield(eeg,'event')
    for i=1:length(eeg.event)
       dat.Y(round(eeg.event(i).latency))=eeg.event(i).type;
    end 
end 

for i=1:length(eeg.chanlocs)
    header.Xlabels{i} = eeg.chanlocs(i).labels; 
end 

header.sampleFreqUnit = 'Hz';
header.sampleFreq = eeg.srate;
header.Xsize = size(dat.X); 
header.Ysize = size(dat.Y); 

save(fName,'dat','header');

