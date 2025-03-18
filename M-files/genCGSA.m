% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [datX,param]=genCGSA(datX,param)

clc

logZeroParam = exp(-15) ; %%%% when computing log this replaces 0 values 

for mod=1:length(datX)
    
data       = datX{mod}.chan; %%% eeg data
inChans    = 1:length(param.Xlabels); %%% at the moment take all 
lenInChans = length(inChans); %%% number of channels to be used


nTrials = size(data{1}.X,1); 
nSamples=size(data{1}.X,2); %%% length of the data segment 

FT=fittype('a*x^b');

for i=1:nTrials
    rawCh=[];
    fractalCh=[]; 
    harmonicCh=[]; 
    sharmonicCh1=[]; sharmonicCh2=[]; 
    sfractalCh1=[]; sfractalCh2=[]; 
    iRaw=[];iHar=[]; iFrac=[];
    
    for ch=1:lenInChans %%% by channel
        chan = ch; %%% at the moment take all %%% later can specify  
        datSeg=data{chan}.X(i,:);
        %%%% zero-mean 
        if param.zeroMean
            datSeg=datSeg - mean(datSeg);
        end
        %%%%%% compute cgsa
        x1 = datSeg(1:nSamples/2); % first half of normal data (x)
        lenX1=length(x1); 
        x2 = datSeg(2:2:end); % coarse-grained version (x2)
        x12 = zeros(1,lenX1); % fine-grained version (x1/2)
        x12(1:2:end)=x1(1:lenX1/2);
        x12(2:2:end)=x1(1:lenX1/2);
        
        % calculate needed PSDs and CSDs
         x1 = x1-mean(x1);
         x2 = x2-mean(x2);
         x12 = x12-mean(x12);
        
        switch param.cgsaWindowType
            case 'none'
                %[pxx1,f_lines] = periodogram(x1,[],lenX1,param.sampleFreq,'psd');
                [pxx1,f_lines] = cpsd(x1,x1,[],[],param.nFFT,param.sampleFreq);
                [cxx2,~] = cpsd(x1,x2,[],[],param.nFFT,param.sampleFreq);
                [cxx12,~] = cpsd(x1,x12,[],[],param.nFFT,param.sampleFreq);
            otherwise
                eS=['[pxx1,f_lines] = periodogram(x1,',param.cgsaWindowType,'(lenX1),param.nFFT,param.sampleFreq,''psd'');'];
                eval(eS);
                eS1=['[cxx2,~] = cpsd(x1,x2,',param.cgsaWindowType,'(lenX1),[],param.nFFT,param.sampleFreq);'];
                eval(eS1);
                eS2=['[cxx12,~] = cpsd(x1,x12,',param.cgsaWindowType,'(lenX1),[],param.nFFT,param.sampleFreq);'];
                eval(eS2);
        end

        
        % calculate different components of data (raw,fractal,harmonic)
        switch  param.cgsaSpectraType
            case 'log_power'
                p_raw      = pxx1;
                p_fractal  = sqrt(abs(cxx2) .* abs(cxx12));
                
                p_raw(p_raw <= 0) = logZeroParam;
                p_raw=10*log10(p_raw);
                p_fractal (p_fractal  <= 0) = logZeroParam;
                p_fractal =10*log10(p_fractal );
                
                p_harmonic = p_raw - p_fractal;
                
                
            case 'power'
                p_raw      = pxx1;
                p_fractal  = sqrt(abs(cxx2) .* abs(cxx12));
                p_harmonic = p_raw - p_fractal;
               % p_harmonic(p_harmonic < 0)=0; 
                
                
                %%%% smootef fractal to 1/f 
                z2=fit(f_lines(3:end),p_fractal(3:end),'exp1'); 
                p_sfractal2=[0;0;z2.a*exp(z2.b*f_lines(3:end))]; 
                p_sharmonic2 = p_raw - p_sfractal2;
                
                z1=fit(f_lines(3:end),p_fractal(3:end),FT,'StartPoint',[1,-1]); 
                p_sfractal1=[0;0;z1.a*f_lines(3:end).^z1.b]; 
                p_sharmonic1 = p_raw - p_sfractal1;
                
        end
        rawCh=[rawCh p_raw'];
        fractalCh=[fractalCh p_fractal'];
        sfractalCh1=[sfractalCh1 p_sfractal1'];
        sfractalCh2=[sfractalCh2 p_sfractal2'];
        harmonicCh=[harmonicCh p_harmonic'];
        sharmonicCh1=[sharmonicCh1 p_sharmonic1'];
        sharmonicCh2=[sharmonicCh2 p_sharmonic2'];
        if ~isfield(param,'outEpochLength')
            param.outEpochLength=length(f_lines);
        end
        
        Frange = [0,125];
        specIRASA = amri_sig_fractal(datSeg - mean(datSeg),param.sampleFreq,'detrend',1,'frange',Frange);;
        % fitting power-law function to the fractal power spectra
        % Frange = [2,40]; % define frequency range for power-law fitting
        % specIRASA = amri_sig_plawfit(specIRASA,Frange);
        
        iRaw=[iRaw, specIRASA.mixd'];
        iFrac =[iFrac , specIRASA.frac'];
        iHar =[iHar   , specIRASA.osci'];


    end
    d.harmonic(i,:)=harmonicCh;
    d.fractal(i,:)=fractalCh; 
    d.sfractal1(i,:)=sfractalCh1; 
    d.sfractal2(i,:)=sfractalCh2; 
    d.raw(i,:)=rawCh;
    d.sharmonic1(i,:)=sharmonicCh1;
    d.sharmonic2(i,:)=sharmonicCh2;
    
    d.irasaRaw(i,:)=iRaw;
    d.irasaHarmonic(i,:)=iHar;
    d.irasaFractal(i,:)=iFrac;
    
    if ~isfield(d,'irasaSrate')
        d.irasaSrate=specIRASA.srate;
        d.irasaFlines=specIRASA.freq;
    end
    if ~isfield(d,'Srate')
        d.Srate=param.sampleFreq;
        d.Flines=f_lines;
        d.chanLabels=param.Xlabels;
    end

end
save toLenDT1 d 
param.f_lines_all=f_lines;

%%%% select only desired lines and correct spectra if required

indF=findFlines(param.freqIn,f_lines);
f_lines_in=f_lines(indF);
sAll=[];
for i=1:lenInChans
    bg=(i-1)*param.outEpochLength +1;
    en=bg + param.outEpochLength  -1;
    sCol=[];
    for j=1:size(d.harmonic,1)
        sT=d.harmonic(j,bg:en);
%         switch  param.cgsaSpectraType
%             case 'log_power'
%                 sT(sT <= 0)=logZeroParam; %%%% treat zeros
%                 sT=10*log10(sT);
%             case 'log_power+'
%                 sT(sT <= 0)=logZeroParam; %%%% treat zeros
%                 sT=10*log10(sT + 1);
%             case 'sqrt_power'
%                 sT=sqrt(sT);
%             case 'power'
%                 %sT=sT;
%         end
        sCol=[sCol ; sT(indF)];
    end
    sAll=[sAll sCol];
end

datX{mod}.X=sAll;
param.f_lines_in=f_lines_in;
datX{mod}=rmfield(datX{mod},'chan');

if lenInChans > 1 
    param.multiWay = [lenInChans length(param.f_lines_in)]; 
elseif lenInChans == 1 
    param.multiWay = [1 length(param.f_lines_in)]; 
end 
    

end 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function bP=findBreakPoints(bP_in,f_lines)
% 
% for i=1:length(bP_in)
%     ii=find(f_lines <= bP_in(i));
%     bP(i)=f_lines(ii(end));
% end
% bP=single(bP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function indF=findFlines(freqIn,f_lines)

indF=[];
nSeg=length(freqIn);

for i=1:nSeg
    indFp=find(f_lines >=freqIn{i}(1) &  f_lines <=freqIn{i}(2));
    indF = [indF , indFp];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

