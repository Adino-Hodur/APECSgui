function genFeatures(param)


nF= param.fileIndx; 

hW=waitbar(0,'Please wait ... generating features ...');  
for f = 1:nF
    
    fName=strcat(param.pathName{f},param.fileName{f});        
    load(fName);
    
    %%%%% where to save 
    %%%% save data into FeaturesData sub-folder
    folderName=strcat(filesep,'win',num2str(param.fileHeader{f}.lenEpoch),param.fileHeader{f}.lenEpochUnit,'_overlap');
    %if param.fileHeader{f}.lenOverlap
    folderName=strcat(folderName,num2str(param.fileHeader{f}.lenOverlap),param.fileHeader{f}.lenOverlapUnit);
    %else
    %    folderName=strcat(folderName,'0');
    %end
    if isfield(param.fileHeader{f},'filterFile')
        folderName=strcat(folderName,'_filtered');
    end
    if isfield(param.fileHeader{f},'sampleFreq')
        folderName=strcat(folderName,'_fs',num2str(param.fileHeader{f}.sampleFreq),param.fileHeader{f}.sampleFreqUnit);
    end
    if isfield(param.fileHeader{f},'decimationFactor')
        folderName=strcat(folderName,'_decimation',num2str(param.fileHeader{f}.decimationFactor));
    end
    if isfield(param.fileHeader{f},'refType')
        switch param.fileHeader{f}.refType
            case 'Average Reference'
                folderName=strcat(folderName,'_avgRef');
            case 'Average Reference & GF'
                folderName=strcat(folderName,'_avgRefGF');
            case {'A1A2-2'}
                folderName=strcat(folderName,'_A1A2-2Ref');
            case {'Laplacian-Sph'}
                folderName=strcat(folderName,'_LaplacianSph');
            case {'Laplacian-Geo'}
                folderName=strcat(folderName,'_LaplacianGeo');
        end
    end
    if isfield(param.fileHeader{f},'joinSeg')
        if param.fileHeader{f}.joinSeg
            folderName=strcat(folderName,'_jointSegments'); 
        end
    end
    waitbar(0.45)
    
    switch param.fileHeader{f}.featureType
        case 'psd'
            %%%% generate spectral features
            [datX,datE,param.fileHeader{f}] = genSpectra(datX,param.fileHeader{f});
            %param.fileHeader{f}.Esize = size(datE{1}.timeEpochVariance);
            param.fileHeader{f}.errorType='timeEpochVariance';
            switch param.fileHeader{f}.psdMethod
                case 'fft'
                    folderName=[folderName,'_',param.fileHeader{f}.psdMethod,'_',param.fileHeader{f}.psdWindowType,'_',param.fileHeader{f}.psdSpectraType];
                    if strcmp(param.fileHeader{f}.detrendL,'yes')
                        folderName=[folderName,'_detrendL'];
                    end
                    if strcmp(param.fileHeader{f}.fftNorm2Hz,'yes')
                        folderName=[folderName,'_norm2Hz'];
                    end
                    folderName=[folderName,'_numSubsets',num2str(param.fileHeader{f}.nSubset)];
                otherwise
                    folderName=strcat(folderName,'_',param.fileHeader{f}.psdMethod,'_', ...
                        param.fileHeader{f}.psdWindowType,'_',param.fileHeader{f}.psdSpectraType);
            end
            if exist('datErr','var')
                for m=1:length(datE)
                    datErr{m}.timeEpochVariance=datE{m}.timeEpochVariance;
                end
            elseif  exist('datE','var') %%% here I say that variance can be used
                %%% for possible artifact detection if
                %%% there are not other artifacts, i.e.
                %%% datErr does not exist
                datErr=datE;
                header.artifactLabel=1;
            end
            
        case 'irasa'
            %%%% remove 1/f - irasa, save raw(mixed- harmonic+ fractal) and harmonic  
            [datX,datRaw,datFrac,datE,param.fileHeader{f}] = genIRASA(datX,param.fileHeader{f});
            param.fileHeader{f}.errorType='timeEpochVariance';
            folderName=[folderName,'_IRASA_',param.fileHeader{f}.irasaWindowType,'_',param.fileHeader{f}.irasaSpectraType];
            if strcmp(param.fileHeader{f}.detrendL,'yes')
                folderName=[folderName,'_detrendL'];
            end
            if strcmp(param.fileHeader{f}.fftNorm2Hz,'yes')
                folderName=[folderName,'_norm2Hz'];
            end
            if strcmp(param.fileHeader{f}.rectOsc,'yes')
                folderName=[folderName,'_rectOsc'];
            end
            folderName=[folderName,'_numSubsets',num2str(param.fileHeader{f}.nSubset)];


            pS=textscan(param.fileHeader{f}.hset,'%s','delimiter',':');
            folderName=[folderName,'_Hmin',pS{1}{1},'_Hmax',pS{1}{end}];
            if exist('datErr','var')
                for m=1:length(datE)
                    datErr{m}.timeEpochVariance=datE{m}.timeEpochVariance;
                end
            elseif  exist('datE','var') %%% here I say that variance can be used
                %%% for possible artifact detection if
                %%% there are not other artifacts, i.e.
                %%% datErr does not exist
                datErr=datE;
                header.artifactLabel=1;
            end
        case 'coherence'
            if exist('datErr','var')
               if isfield(datErr{1},'artifact')
                   [param.fileHeader{f},datX,datErr{1}.artifact] = genCoherence(param.fileHeader{f},datX,datErr{1}.artifact);
               else
                   [param.fileHeader{f},datX] = genCoherence(param.fileHeader{f},datX);
               end
            else
                [param.fileHeader{f},datX] = genCoherence(param.fileHeader{f},datX);
            end
            folderName=strcat(folderName,'_',param.fileHeader{f}.coherMethod,'_', ...
                param.fileHeader{f}.coherWindowType);
        case 'cwt'
            switch param.fileHeader{f}.procWTcoef
                case 'none'
                    [datX,param.fileHeader{f}] = genCWT(datX,param.fileHeader{f});
                     folderName=[folderName,'_CWT_',param.fileHeader{f}.cwtType];
                case {'ITPC','ITLC','ERSP','WTav','avWT','WTav-avWT'}
                    [datX,param.fileHeader{f}] = genCWT(datX,param.fileHeader{f},datErr);
                    %%% update time params, now epochs switch to a single
                    %%% epoch time 
                    switch param.fileHeader{f}.lenEpochUnit
                        case 'sec'
                            param.fileHeader{f}.maxTime=param.fileHeader{f}.lenEpoch;
                            param.fileHeader{f}.timeUnit='sec' ; 
                            %%% now change the epoch  
                            param.fileHeader{f}.lenEpochUnit='msec'; 
                            param.fileHeader{f}.lenEpoch=1000*(param.fileHeader{f}.maxTime/size(datX{1}.X,1));
                        otherwise 
                            warndlg('Step not done for other than sec units / genFeatures.m line 102','!! Warning !!')
                    end
                    if isfield(param.fileHeader{f},'lenOverlap') 
                        param.fileHeader{f}.lenOverlap=0;  
                       % param.fileHeader{f}=rmfield(param.fileHeader{f},'lenOverlapUnit'); 
                    end 
                    folderName=[folderName,'_CWT_',param.fileHeader{f}.cwtType,'_procCoeff_',param.fileHeader{f}.procWTcoef];
                    clear datErr
                    datY=ones(size(datX{1}.X,1),1); 
                    param.fileHeader{f}=rmfield(param.fileHeader{f},'classLabel'); 
                    %param.fileHeader{f}.classLabel=0; 
                    %param.fileHeader{f}.Ysize=size(datY); 
                    
            end
            
        case 'np' %%%% no processing
           [datX,param.fileHeader{f}] = genNP(datX,param.fileHeader{f}); 
            folderName=[folderName,'_NoFeatureProcessing'];
    end

    waitbar(0.70)
    
    %%% create folder if does not exist
    folderName=strcat(param.pathFeaturesData,folderName);
    warning off
    mkdir(folderName)
    warning on

    %%% save epoched data
    %%% define Xsize, Ysize Esize 
    if isfield(datX{1},'epoch')
        param.fileHeader{f}.Xsize=[length(datX{1}.epoch),size(datX{1}.epoch(1).X)]; 
    else
        param.fileHeader{f}.Xsize = size(datX{1}.X);
    end
    param.fileHeader{f}.Ysize = size(datY);
    header=param.fileHeader{f};       
    
    waitbar(0.99)
    
    switch param.fileHeader{f}.featureType
        case 'irasa'
            %%%% osilatory/harmonic part
            folderNameT=[folderName,filesep,'Harmonic',filesep];
            if ~exist(folderNameT,'dir')
                mkdir(folderNameT);
            end
            fNameSegOut=strcat(folderNameT,filesep,param.fileName{f});
            if exist('datErr','var')
                save(fNameSegOut,'datX','datY','datErr','header');
            else
                save(fNameSegOut,'datX','datY','header');
            end
            clear datX 
            %%%% fractal part
            datX = datFrac; 
            clear datFrac
            folderNameT=[folderName,filesep,'Fractal',filesep];
            if ~exist(folderNameT,'dir')
                mkdir(folderNameT);
            end
            fNameSegOut=strcat(folderNameT,filesep,param.fileName{f});
            if exist('datErr','var')
                save(fNameSegOut,'datX','datY','datErr','header');
            else
                save(fNameSegOut,'datX','datY','header');
            end
            clear datX 
            %%%% raw spectrum mixed harmonic + fractal  part
            datX = datRaw; 
            clear datRaw 
            folderNameT=[folderName,filesep,'RawSpect',filesep];
            if ~exist(folderNameT,'dir')
                mkdir(folderNameT);
            end
            fNameSegOut=strcat(folderNameT,filesep,param.fileName{f});
            if exist('datErr','var')
                save(fNameSegOut,'datX','datY','datErr','header');
            else
                save(fNameSegOut,'datX','datY','header');
            end
        otherwise
            fNameSegOut=strcat(folderName,filesep,param.fileName{f});
            if exist('datErr','var')
                save(fNameSegOut,'datX','datY','datErr','header');
            else
                save(fNameSegOut,'datX','datY','header');
            end
    end
 
   waitbar(f/nF,hW);
end 


close(hW)