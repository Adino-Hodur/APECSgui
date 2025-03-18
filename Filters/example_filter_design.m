%  EXAMPLE - Design a minimum order lowpass filter with
              % a normalized passband frequency of 0.2, 
              % a stopband frequency of 0.22, 
              % a passband ripple of 1 dB, 
              % and a stopband attenuation of 60 dB. 
              
              %%% filter 1 
              dM = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2, 0.22, 1, 60);
              fM = design(dM, 'equiripple');  % Design an FIR equiripple filter
              info(fM)                       % View information about filter
              save filter1 dM fM 
              
              %%%% filter 2 
              % Other designs can be performed for the same specifications
              designmethods(dM,'iir'); % List the available IIR design methods              
              fM = design(dM, 'ellip');  % Design an elliptic IIR filter (SOS)
              %fvtool(f)    
              save filter2 dM fM              
 

              %%%  filter 3 
              dM=fdesign.bandstop('Fp1,Fst1,Fst2,Fp2,Ap1,Ast,Ap2',1600,2000,2400,2800,1,80,1,8000);
              fM=design(dM,'equiripple'); 

              save filter3 dM fM 
              
              %%%% high pass 0.1 Hz EEG filter 
              Fs=128; 
              dM = fdesign.highpass('Fst,Fp,Ast,Ap',0.1,0.2,60,1,Fs);
              fM = design(dM, 'cheby2');
              save filterHP0d1_EEG dM fM 

              