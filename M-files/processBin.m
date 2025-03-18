function [datX] = processBin(param,datX)

if isfield(param,'freqIn2use')
    fIn = param.freqIn2use;
    fLines = param.fLines(param.fLinesInd2use);
else
    fIn = param.freqIn;
    fLines = param.fLines;
end


%%% define realtive spectra index
if strcmp(param.binProcess,'RelAvg') || strcmp(param.binProcess,'RelSpect')
    relSpectra = true;
    fInRel = param.relSpect;
    fL2useRel = (param.fLines >= str2double(fInRel{1}) & param.fLines <= str2double(fInRel{2}));
else
    relSpectra= false;
end

numBin = length(fIn);

numVar = length(param.var2use);
%indxF{1} = param.var2use;        %%%% indexes of variables
indxF{2} = param.fLinesInd2use;
switch length(param.multiWay)
    case 1
        lenSeg =  length(fLines);
    case 2
        lenSeg =  param.multiWay(2);
end

switch param.binProcess
    case 'none'
        if length(fLines) ~= length(param.fLines)
            indA=[];
            for i1=1:numVar
                bg = (i1-1) * lenSeg + 1;
                en = bg + lenSeg - 1;
                ind = bg : en ;
                ind = ind (indxF{2});
                indA = [indA ind];
            end
            %%%% train & val
            for s=1:length(datX{1}.trainClass)
                if ~isempty(datX{1}.trainClass{s})
                    datX{1}.trainClass{s} = datX{1}.trainClass{s}(:,indA);
                end
                if ~isempty(datX{1}.valClass{s})
                    datX{1}.valClass{s} = datX{1}.valClass{s}(:,indA);
                end
            end
            %%%% test
            for s=1:length(datX{1}.testClass)
                if ~isempty(datX{1}.testClass{s})
                    datX{1}.testClass{s} = datX{1}.testClass{s}(:,indA);
                end
            end
        end
    case 'RelSpect'
        lenSegX=length(fLines);
        for s=1:length(datX{1}.trainClass)
            tDatX.trainClass{s} = [];
            tDatX.valClass{s} = [];
        end
        %%%% test
        for s=1:length(datX{1}.testClass)
          %  if ~isempty(datX{1}.testClass{s})
                tDatX.testClass{s} = [];
          %  end
        end
        
        for i1=1:numVar
            bg = (i1-1) * lenSeg + 1;
            en = bg + lenSeg - 1;
            ind = bg : en ;
            indRel= ind(fL2useRel);
            ind   = ind(indxF{2});
            
            bgX = (i1-1)*lenSegX + 1;
            enX = bgX + lenSegX - 1;
            indX= bgX:enX;
            %%%% train & val
            for s=1:length(datX{1}.trainClass)
                if ~isempty(datX{1}.trainClass{s})
                    for t=1:size(datX{1}.trainClass{s},1)
                        tDatX.trainClass{s}(t,indX) = datX{1}.trainClass{s}(t,ind)./sum(datX{1}.trainClass{s}(t,indRel));
                    end
                end
                if ~isempty(datX{1}.valClass{s})
                    for t=1:size(datX{1}.valClass{s},1)
                        tDatX.valClass{s}(t,indX) = datX{1}.valClass{s}(t,ind)./sum(datX{1}.valClass{s}(t,indRel));
                    end
                end
            end
            %%%% test
            for s=1:length(datX{1}.testClass)
                if ~isempty(datX{1}.testClass{s})
                    for t=1:size(datX{1}.testClass{s},1)
                        tDatX.testClass{s}(t,indX) = datX{1}.testClass{s}(t,ind)./sum(datX{1}.testClass{s}(t,indRel));
                    end
                end
            end
        end
        datX{1}=tDatX;
      
    case {'Avg','RelAvg'}
        %%% create tmp tDatX
        for s=1:length(datX{1}.trainClass)
            tDatX.trainClass{s} = [];
            tDatX.valClass{s} = [];
        end
        %%%% test
        for s=1:length(datX{1}.testClass)
          %  if ~isempty(datX{1}.testClass{s})
                tDatX.testClass{s} = [];
          %  end
        end
        
        %lenSeg = size(datX{1}.trainClass{1},2) / length(param.var2use);
        varIn = 1;
        for f=1:numBin
            fL2use = (fLines >= fIn{f}(1) & fLines <= fIn{f}(2));
            inDin = varIn;
            
            for c=1:numVar
                bg  = (c-1) * lenSeg + 1;
                en  = bg + lenSeg - 1;
                indA = bg : en;
                if relSpectra
                    indRel= indA(fL2useRel);
                end
                indA = indA(fL2use);
                %%%% train & val
                for s=1:length(datX{1}.trainClass)
                    if ~isempty(datX{1}.trainClass{s})
                        for t=1:size(datX{1}.trainClass{s},1)
                            switch param.binProcess
                                case 'Avg'
                                    tDatX.trainClass{s}(t,inDin) = mean(datX{1}.trainClass{s}(t,indA));
                                case 'RelAvg'
                                    tDatX.trainClass{s}(t,inDin) = mean(datX{1}.trainClass{s}(t,indA))/sum(datX{1}.trainClass{s}(t,indRel));
                            end
                        end
                    end
                    if ~isempty(datX{1}.valClass{s})
                        for t=1:size(datX{1}.valClass{s},1)
                            switch param.binProcess
                                case 'Avg'
                                    tDatX.valClass{s}(t,inDin) = mean(datX{1}.valClass{s}(t,indA));
                                case 'RelAvg'
                                    tDatX.valClass{s}(t,inDin) = mean(datX{1}.valClass{s}(t,indA))/sum(datX{1}.valClass{s}(t,indRel));
                            end
                        end
                    end
                end
                %%%% test
                for s=1:length(datX{1}.testClass)
                    if ~isempty(datX{1}.testClass{s})
                        for t=1:size(datX{1}.testClass{s},1)
                            switch param.binProcess
                                case 'Avg'
                                    tDatX.testClass{s}(t,inDin) = mean(datX{1}.testClass{s}(t,indA));
                                case 'RelAvg'
                                    tDatX.testClass{s}(t,inDin) = mean(datX{1}.testClass{s}(t,indA))/sum(datX{1}.testClass{s}(t,indRel));
                            end
                        end
                    end 
                end
                inDin = inDin + numBin;
            end
            varIn = varIn + 1;
        end
        datX{1}=tDatX;
end




