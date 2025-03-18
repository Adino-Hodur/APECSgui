% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function preProcessData(param)

nF= param.fileIndx; 

hW=waitbar(0,'Please wait .... processing files ....'); 

%fid = fopen('percCorrect.txt','a+');
        

for f = 1:nF
    
    % if conditional block added for backwards compatability.
%     if strcmp(param.pathName{f}(1),'.')
%         fName = [getpref('APECSgui','workspace') ...
%                  param.pathName{f}(2:end) ...
%                  param.fileName{f}];
%     else
        fName = strcat(param.pathName{f},param.fileName{f});
%    end        
    load(fName);
    
    
    
    %%%% Notch Data filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(param.fileHeader{f},'notchFilter')
       Wo = param.fileHeader{f}.notchFilter/(param.fileHeader{f}.sampleFreq/2);  
       BW = Wo/35;
       [bB,aA] = iirnotch(Wo,BW); 
        for i=1:size(dat.X,2)
            %%%%% do filtfilt
            dat.X(:,i)=filtfilt(bB,aA,double(dat.X(:,i)));
        end
    end
    
    
    if isfield(param.fileHeader{f},'refType') && ...
            (strcmpi(param.fileHeader{f}.refType,'Laplacian-Sph') || strcmpi(param.fileHeader{f}.refType,'Laplacian-Geo'))
        D.Data=dat.X; 
        M=load(param.fileHeader{f}.fnHeadModel); 
        %%%% check electrode consistency and re-arrange
        
        % EDIT: J.L. Hester added these two conditional blocks to complement plotChannelsList 
        if isfield(param.fileHeader{f},'Xlabels2use') && length(M.Electrode.Label) == length(param.fileHeader{f}.Xlabels2use)
           l1=strtrim(param.fileHeader{f}.Xlabels2use); 
           for e=1:length(M.Electrode.Label)
               ii=find(strcmpi(l1,M.Electrode.Label{e})==1);
               if isempty(ii)
                  strE=['Error: Electrode ', M.Electrode.Label{e}, ' from the Laplacian head model is not present'];
                  hE=errordlg(strE);
                  uiwait(hE)
                  error(strE)  
               else 
                  indE(e)=ii; 
               end                
           end
           %%% re-arrange 
           D.Data=dat.X(:,indE); 
        elseif isfield(param.fileHeader{f},'Xlabels2use') && length(M.Electrode.Label) ~= length(param.fileHeader{f}.Xlabels2use)
           hE=errordlg('Error: Number of electrodes is not equal to the number of electrodes in Laplacian head model');
           uiwait(hE)
           error('Error: Number of electrodes is not equal to the number of electrodes in Laplacian head model')
        % -----------------------------------------------------------------
        
        elseif length(M.Electrode.Label) ~= length(param.fileHeader{f}.Xlabels)
           hE=errordlg('Error: Number of electrodes is not equal to the number of electrodes in Laplacian head model');
           uiwait(hE)
           error('Error: Number of electrodes is not equal to the number of electrodes in Laplacian head model')                
        else  
           l1=strtrim(param.fileHeader{f}.Xlabels); 
           for e=1:length(M.Electrode.Label)
               ii=find(strcmpi(l1,M.Electrode.Label{e})==1);
               if isempty(ii)
                  strE=['Error: Electrode ', M.Electrode.Label{e}, ' from the Laplacian head model is not present'];
                  hE=errordlg(strE);
                  uiwait(hE)
                  error(strE)  
               else 
                  indE(e)=ii; 
               end 
           end 
           %%% re-arrange 
           D.Data=dat.X(:,indE); 
        end 
        if isfield(param.fileHeader{f},'Xlabels2use')
            %l1=param.fileHeader{f}.Xlabels;
            %%% find indexes of the head model which will not be used \\
            l1=M.Electrode.Label;
            l2=strtrim(param.fileHeader{f}.Xlabels2use);
            indL=ones(1,length(l2));
            for j=1:length(l2)
                indL(strcmpi(l2{j},l1)==1)=0;
            end
            D.ExcludeChannel=find(indL==1); 
        end
        %%%% run laplacian tool 
        X = ssltool(D,M);
        [sI, pX]=sort(indE); 
        
        % NOTE: This switch case to rebuild dat.X with param.Xlabels2use
        %       can only be EOG channels due to head model criterion and 
        %       can only concatenate the unreferenced EOG channels data
        %       to the end of the rereferenced channels data. 
        switch param.fileHeader{f}.refType            
            case {'Laplacian-Sph'}                                              
                if isfield(param.fileHeader{f},'Xlabels2use')                    
                    all_labels = param.fileHeader{f}.Xlabels;
                    used_labels = param.fileHeader{f}.Xlabels2use;
                    dat_eog = dat.X(:, ~ismember(all_labels, used_labels));            
                    dat.X = [X.Sph(:,pX) dat_eog];                    
                else
                    dat.X = X.Sph(:,pX);
                end
            case {'Laplacian-Geo'}
                if isfield(param.fileHeader{f},'Xlabels2use')                    
                    all_labels = param.fileHeader{f}.Xlabels;
                    used_labels = param.fileHeader{f}.Xlabels2use;
                    dat_eog = dat.X(:, ~ismember(all_labels, used_labels));            
                    dat.X = [X.Geo(:,pX) dat_eog];                    
                else
                    dat.X = X.Geo(:,pX);
                end
        end
        %%% this will keep all !!!! but mark interplotated channels 
        if isfield(param.fileHeader{f},'Xlabels2use')
            l1=strtrim(param.fileHeader{f}.Xlabels);
            l2=strtrim(param.fileHeader{f}.Xlabels2use);
            indL=ones(1,length(l2));
            for j=1:length(l2)
                indL(strcmpi(l2{j},l1)==1)=0;
            end
            excludeLap=find(indL==1); 
            param.fileHeader{f}= rmfield(param.fileHeader{f},'Xlabels2use');
            %excludeLap=D.ExcludeChannel;
        end
        clear X M D indL 
    end
              
%     %%%% select subset of variables
%     if isfield(param.fileHeader{f},'Xlabels2use')
%         l1=param.fileHeader{f}.Xlabels;
%         l2=param.fileHeader{f}.Xlabels2use;
%         %indL=zeros(1,length(l2));
%         indL=[];
%         for j=1:length(l2)
%             indL(j) = find(strcmp(l2{j},l1)==1);
%         end
%         dat.X=dat.X(:,indL);
%         if isfield(dat,'E')
%             if (size(dat.E,1) == param.fileHeader{f}.Xsize(1)) && ...
%                     (size(dat.E,2) == param.fileHeader{f}.Xsize(2))
%                 dat.E=dat.E(:,indL);
%             end
%         end
%         param.fileHeader{f}.Xsize=size(dat.X);
%         param.fileHeader{f}.Xlabels = param.fileHeader{f}.Xlabels2use;
%         param.fileHeader{f}= rmfield(param.fileHeader{f},'Xlabels2use');
%     end
    
    %%%% Re-referencing 
    if isfield(param.fileHeader{f},'refType')
        switch param.fileHeader{f}.refType
            case {'Average Reference','Average Reference & GF'}
                for t=1:size(dat.X,1)
                    dat.X(t,:) = dat.X(t,:) - mean(dat.X(t,:));
                    if strcmp(param.fileHeader{f}.refType,'Average Reference & GF')
                        gfp = sqrt(mean(dat.X(t,:).^2));
                        if gfp ~=0
                            dat.X(t,:)=dat.X(t,:)/gfp;
                        end
                    end
                end
            case {'A1A2-2'}                
                if ~isfield(header,'refLabels') || ~isfield(dat,'refCh')
                    hW=warndlg('Reference labels or channles missing ... I don''t re-reference ...','Missing ref ...');
                    uiwait(hW); 
                elseif ~strcmpi(header.refLabels{1},'A1') || ~strcmpi(header.refLabels{2},'A2')
                    hW=warndlg('Reference labels don''t much A1 or A2 ... I don''t re-reference ...','Missing A1 anbd A2 ...');
                    uiwait(hW);
                else
                    refM=(dat.refCh(:,1)+dat.refCh(:,2))/2; 
                    for t=1:size(dat.X,2)
                        dat.X(:,t) = dat.X(:,t) - refM;
                    end
                end
                
        end
    end

    %%%% select subset of variables
    if isfield(param.fileHeader{f},'Xlabels2use')
        l1=param.fileHeader{f}.Xlabels;
        l2=param.fileHeader{f}.Xlabels2use;
        %indL=zeros(1,length(l2));
        indL=[];
        for j=1:length(l2)
            indL(j) = find(strcmp(l2{j},l1)==1);
        end
        dat.X=dat.X(:,indL);
        if isfield(dat,'E')
            if (size(dat.E,1) == param.fileHeader{f}.Xsize(1)) && ...
                    (size(dat.E,2) == param.fileHeader{f}.Xsize(2))
                dat.E=dat.E(:,indL);
            end
        end
        param.fileHeader{f}.Xsize=size(dat.X);
        param.fileHeader{f}.Xlabels = param.fileHeader{f}.Xlabels2use;
        param.fileHeader{f}= rmfield(param.fileHeader{f},'Xlabels2use');
    end
    

    
    %%%% Joining data segments
    if isfield(param.fileHeader{f},'joinSeg')
        if param.fileHeader{f}.joinSeg
            if isvector(dat.E)
                numPoint=5;
                tX=dat.X;
                tY=dat.Y;tE=dat.E;
                tI=zeros(length(tE),1);
                tI(diff(tE)> 0)=1; %%% find all edges where clean to artifact 
                ii=find(tE > 0);   %%% find all artifacts 
                tI(ii)=[];tE(ii)=[];tX(ii,:)=[];%%% remove all artifact points 
                tI=find(tI==1);                 %%% take only edges  
                tY(ii)=[];
                [nL,nCh]=size(tX);
                for j=1:length(tI)
                    bg=tI(j)-numPoint;
                    en=tI(j)+numPoint;
                    for ch=1:nCh
                        if bg>0 & en <= nL
                            tX(bg:en,ch)=smooth(tX(bg:en,ch));
                        elseif tI(j) < numPoint
                            tX(1:en,ch)=smooth(tX(1:en,ch));
                        elseif en  >  nL
                            tX(bg:end,ch)=smooth(tX(bg:end,ch));
                        end
                    end
                end
                dat.E=tE;
                dat.X=tX;
                dat.Y=tY;
                clear tE tX tY tI
            else
                numPoint=5;
                [nL,nCh]=size(dat.X);
                newX  =nan(nL,nCh);
                newErr=zeros(nL,nCh);
                for ch=1:nCh
                    tX=dat.X(:,ch);
                    %tY=dat.Y;
                    tE=dat.E(:,ch);
                    tI=zeros(length(tE),1);
                    tI(diff(tE)> 0)=1; %%% find all edges where clean to artifact 
                    ii=find(tE > 0);   %%% find all artifacts 
                    tI(ii)=[];tX(ii,:)=[];%%% remove all artifact points 
                    %tE(ii)=[];
                    tI=find(tI==1);                 %%% take only edges  
                    nP=length(tX); 
                    for j=1:length(tI)
                        bg=tI(j)-numPoint;
                        en=tI(j)+numPoint;
                       % for ch=1:nCh
                            if bg> 0 & en <= nP
                                tX(bg:en,1)=smooth(tX(bg:en,1));
                            elseif tI(j) < numPoint
                                tX(1:en,1)=smooth(tX(1:en,1));
                            elseif en  >  nP
                                tX(bg:end,1)=smooth(tX(bg:end,1));
                            end
                       % end
                    end
                    newX(1:length(tX),ch)=tX; 
                    newErr(length(tX)+1:end,ch)=1; 
                end
                dat.E=newErr;
                dat.X=newX;
                %dat.Y=tY;
                clear tE newX newErr tI
                %hW=warndlg('Warning: Artifacts file dat.E is not a vector');
                %uiwait(hW);
            end
        end
    end

    %%%%% Data re-sampling 
    if isfield(param.fileHeader{f},'new_sampleFreq')
        if (param.fileHeader{f}.sampleFreq ~= param.fileHeader{f}.new_sampleFreq)
            %%%% resampling data %%%%%
            dat.X=resample(double(dat.X),double(int32(param.fileHeader{f}.new_sampleFreq)),double(int32(param.fileHeader{f}.sampleFreq)));
        end
    end
    if isfield(param.fileHeader{f},'decimationFactor')
        dat.X = dat.X(1:param.fileHeader{f}.decimationFactor:end,:); 
    end 
    
    %%%% Data filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(param.fileHeader{f},'filterFile')
        load(param.fileHeader{f}.filterFile,'dM','fM')
        for i=1:size(dat.X,2)
            %%%%% do filtfilt
            tOut=filter(fM,dat.X(:,i));
            tOut=tOut(length(tOut):-1:1);
            tOut=filter(fM,tOut);
            dat.X(:,i)=tOut(length(tOut):-1:1);
        end
    end
    
    
    
    %%%%%%% Data epoching %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(dat,'E')
        [datX,datY,datErr] = epochData(dat, param.fileHeader{f});
       %  datErr=artEpoch2Vect(datErr); 
        param.fileHeader{f}.artifactLabel = true;
    else 
        [datX,datY] = epochData(dat, param.fileHeader{f});
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if isfield(param.fileHeader{f},'eventsProcessFile')
        if exist('datErr','var')
            disp(fName)
            
            strY=['[datY,classLabel,datErr,perC] = ',param.fileHeader{f}.eventsProcessFile(1:end-2),'(datY,datErr);'];
            
            eval(strY);
            
            %fprintf(fid,'%s : %2.2f  \n',fName,perC);
            
            param.fileHeader{f}.classLabel=classLabel;
            if isempty(datErr)
                clear datErr
                param.fileHeader{f}.artifactLabel = false;
            else
                param.fileHeader{f}.artifactLabel = true;
            end
        else
            strY=['[datY,classLabel] = ',param.fileHeader{f}.eventsProcessFile(1:end-2),'(datY);'];
            eval(strY);
            param.fileHeader{f}.classLabel=classLabel;
            param.fileHeader{f}.artifactLabel = false;
        end
    end
     
    %%%% keep excluded laplacian 
    if isfield(param.fileHeader{f},'refType') && ...
            (strcmpi(param.fileHeader{f}.refType,'Laplacian-Sph') || strcmpi(param.fileHeader{f}.refType,'Laplacian-Geo'))
        if exist('excludeLap','var')
            datErr{1}.excludeLaplacian = excludeLap;
        end
    end
    
    
    %%%% save data into EpochedData folder
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
        if isfield(param.fileHeader{f},'new_sampleFreq')
            folderName=strcat(folderName,'_fs',num2str(param.fileHeader{f}.new_sampleFreq),param.fileHeader{f}.sampleFreqUnit);
        else
            folderName=strcat(folderName,'_fs',num2str(param.fileHeader{f}.sampleFreq),param.fileHeader{f}.sampleFreqUnit);
        end
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
    %%% save epoched data
    %%% now keep only new sampling freq. 
    if isfield(param.fileHeader{f},'new_sampleFreq')
        param.fileHeader{f}.sampleFreq     = param.fileHeader{f}.new_sampleFreq;
        param.fileHeader{f} = rmfield(param.fileHeader{f},'new_sampleFreq');
    end
    %%%% new sizes pre
    param.fileHeader{f}.Xsize(1)    = length(datX{1}.chan); 
    param.fileHeader{f}.Xsize([2 3])= size(datX{1}.chan{1}.X); 
    param.fileHeader{f}.Ysize       = size(datY);
%     if exist('datErr','var')
%         param.fileHeader{f}.Asize   = size(datErr{1}.artifact);
%     end 
    %%%% define max time and time unit 
    header=param.fileHeader{f};       
    numEpoch = size(datX{1}.chan{1}.X,1); 
    header = fcn1 (header, numEpoch); 

   %%% create folder if does not exist
    folderName=strcat(param.pathEpochedData,folderName);
    warning off
    if ~exist(folderName,'dir')
        mkdir(folderName)
    end
    warning on
    fNameSegOut=strcat(folderName,filesep,param.fileName{f});
    
    %%% don't need later 
    if isfield(header,'refLabels')
        header = rmfield(header,'refLabels');
    end
    
    if exist('datErr','var')
        save(fNameSegOut,'datX','datY','datErr','header');
    else
        save(fNameSegOut,'datX','datY','header');
    end
    waitbar(f/nF,hW); 
end


%fclose(fid);
        
close(hW); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function header=fcn1(header,numEpoch)
%%% compute maxTime

if header.lenOverlap
    switch header.lenOverlapUnit
        case 'msec'
            lenOverlap = header.lenOverlap / 1000 ;  %%% lenOverlap in sec
        case 'sec'
            lenOverlap = header.lenOverlap;           %%% lenOverlap in sec
        case 'min'
            lenOverlap = header.lenOverlap * 60;      %%% lenOverlap in sec
    end
    maxTimeTMP = (numEpoch-1)* lenOverlap ; %+ header.lenEpochUnit; 
end


switch header.lenEpochUnit
    case 'samples'
        header.timeUnit = 'samples';
        if header.lenOverlap
            header.maxTime  = (numEpoch-1)* header.lenOverlap + header.lenEpoch; 
        else 
            header.maxTime  = numEpoch * header.lenEpoch; 
        end 
    case 'msec'
        header.timeUnit = 'sec';
        if header.lenOverlap
            header.maxTime = maxTimeTMP + header.lenEpoch/1000;
        else
            header.maxTime = numEpoch * (header.lenEpoch/1000);
        end
    case 'sec'
        header.timeUnit = 'min';
        if header.lenOverlap
            header.maxTime = (maxTimeTMP + header.lenEpoch)/60;
        else
            header.maxTime = (numEpoch * header.lenEpoch)/60;
        end
    case 'min'
        header.timeUnit = 'min';
        if header.lenOverlap
            header.maxTime = maxTimeTMP/60 + header.lenEpoch;
        else
            header.maxTime  = numEpoch * header.lenEpoch;
        end
end