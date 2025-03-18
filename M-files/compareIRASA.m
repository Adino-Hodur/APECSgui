function compareIRASA(sig)

close all 

srate=250; 
nFFT=512; % length(datSeg); 

datSeg=sig; 
datSeg=datSeg - mean(datSeg);
%%%%%% compute spectra

w = window(@hann, length(datSeg));
datSeg = datSeg.*w';

%%% prior it was
% yF = fft(datSeg,param.nFFT);
% Pyy = (yF.* conj(yF))./ param.nFFT ; % (param.sampleFreq*param.nFFT)

% yF    = fft(datSeg,nFFT);
% yF    = yF(1:nFFT/2 + 1);
% Pyy   = (abs(yF).^2)./ length(datSeg); %param.nFFT ; % (param.sampleFreq*param.nFFT);

yF    = fft(datSeg,nFFT)/length(datSeg); 
yF    = yF(1:nFFT/2 + 1)*2;
Pyy   = abs(yF).^2; %param.nFFT ; % (param.sampleFreq*param.nFFT);

%%% should be 
%%% len freq  > *2 


%%% to be equal with BCI2000, then ingnore 0 bins below
%spectNoise(1:param.nFFT/2,1)=2*Pyy(2:param.nFFT/2+1);

%specRR(1:nFFT/2+1,1)=2*Pyy(1:nFFT/2+1);
specRR(1:nFFT/2+1,1)=Pyy(1:nFFT/2+1);
%%%  if include 0
%%%  spectNoise = [Pyy(param.nFFT/2+1) spectNoise];
if ~exist('f_lines','var')
    %%% ignores 0 bin - DC to be equal with BCI2000
    %f_lines = param.sampleFreq*(1:param.nFFT/2)/param.nFFT;
    %%% include 0 bin
    f_lines = srate*(0:nFFT/2)/nFFT;
end


spec = irasaRR(sig,srate,'detrend',0); 


%close all 
plot(spec.freq,spec.mixd)
hold on 
plot(f_lines,specRR,'r')
disp('ok') 
