function [datX,datY,datE]=epochData(data,param)

if isfield(param,'sampleFreq')
    switch param.sampleFreqUnit
        case 'Hz'
            if isfield(param,'new_sampleFreq')
                fsFactor  = param.new_sampleFreq;
            else
                fsFactor  = param.sampleFreq;
            end
            fsFactorY = param.sampleFreq; 
        case 'kHz'
            if isfield(param,'new_sampleFreq')
                fsFactor  = param.new_sampleFreq*1000;
            else
                fsFactor  = param.sampleFreq*1000;
            end
            fsFactorY = param.sampleFreq*1000;
    end 
    switch param.lenEpochUnit
        case 'samples'
            elements_per_win  = param.lenEpoch;
            elements_per_winY = param.lenEpoch;
        case 'msec'            
            elements_per_win  = round((param.lenEpoch/1000) * fsFactor);
            elements_per_winY = round((param.lenEpoch/1000) * fsFactorY);
        case 'sec'
            elements_per_win  = round((param.lenEpoch) * fsFactor); 
            elements_per_winY = round((param.lenEpoch) * fsFactorY);
        case 'min'    
            elements_per_win  = round((param.lenEpoch*60) * fsFactor);
            elements_per_winY = round((param.lenEpoch*60) * fsFactorY);
    end   
    if param.lenOverlap > 0
        switch param.lenOverlapUnit
            case 'samples'
                elements_per_overlap  = param.lenOverlap;
                elements_per_overlapY = param.lenOverlap;
            case 'msec'
                elements_per_overlap  = round((param.lenOverlap/1000) * fsFactor);
                elements_per_overlapY = round((param.lenOverlap/1000) * fsFactorY);
            case 'sec'
                elements_per_overlap  = round((param.lenOverlap) * fsFactor);
                elements_per_overlapY = round((param.lenOverlap) * fsFactorY);
            case 'min'
                elements_per_overlap  = round((param.lenOverlap*60) * fsFactor);
                elements_per_overlapY = round((param.lenOverlap*60) * fsFactorY);
        end
    end
else 
    if isfield(param,'decimationFactor')
        elements_per_win  = round(param.lenEpoch/param.decimationFactor);
        elements_per_winY = param.lenEpoch;
        if param.lenOverlap > 0
            elements_per_overlap  = round(param.lenOverlap/param.decimationFactor);
            elements_per_overlapY = param.lenOverlap;
        end
    else
        elements_per_win  = param.lenEpoch;
        elements_per_winY = param.lenEpoch;
        if param.lenOverlap > 0
            elements_per_overlap  = param.lenOverlap;
            elements_per_overlapY = param.lenOverlap;
        end
    end
end 


elems  = size(data.X,1);
elemsY = size(data.Y,1);


if param.lenOverlap == 0
    %%%% no overlap
    wincount  = floor(elems  / elements_per_win);
    wincountY = floor(elemsY / elements_per_winY);
    min_wincount = min(wincount, wincountY);
    newshape  = [min_wincount  elements_per_win];
    newshapeY = [min_wincount  elements_per_winY];
    
    for ch=1:size(data.X,2)
        datX{1}.chan{ch}.X = reshape(data.X(1:prod(newshape(1:2)),ch), fliplr(newshape))';
    end
    if size(data.Y,2) > 1
        for i=1:size(data.Y,2)
            datY.var{i}.Y = reshape(data.Y(1:prod(newshapeY(1:2)),i), fliplr(newshapeY))';
        end
    else
        datY  = reshape(data.Y(1:prod(newshapeY(1:2)),1), fliplr(newshapeY))';
    end
    if isfield(data,'E')
        if size(data.E,2) > 1
            for i=1:size(data.E,2)
                datE{1}.var{i}.E = reshape(data.E(1:prod(newshapeY(1:2)),i), fliplr(newshapeY))';
            end
        else
            datE{1}.var  = reshape(data.E(1:prod(newshapeY(1:2)),1), fliplr(newshapeY))';
        end
    end
else
    %%%% overlap
    %wincount  = (floor(elems  / elements_per_win) - elements_per_win)  +  floor(rem(elems  , elements_per_win)/elements_per_overlap);
    wincount  = floor((elems   - elements_per_win) /elements_per_overlap );
    wincountY = floor((elemsY  - elements_per_winY)/elements_per_overlapY);
    min_wincount = min(wincount, wincountY);

    for ch=1:size(data.X,2)
        newX = zeros(min_wincount,elements_per_win);
        for i=1:min_wincount
            bg = (i-1)* elements_per_overlap + 1;
            en = bg + elements_per_win - 1 ;
            newX(i,:)=data.X(bg:en,ch);
        end
        datX{1}.chan{ch}.X = newX;
    end
    if size(data.Y,2) > 1        
        for ch=1:size(data.Y,2)
            unY=unique(data.Y(:,ch)); 
            if length(unY) == 1                
               datY.var{ch}.Y(1:min_wincount,1)=unY;
            else
                newY = zeros(min_wincount,elements_per_winY);
                for i=1:min_wincount
                    bg = (i-1)* elements_per_overlapY + 1;
                    en = bg + elements_per_winY - 1 ;
                    newY(i,:) = data.Y(bg:en,ch);
                end
                datY.var{ch}.Y = newY;
            end
        end
    else
        unY = unique(data.Y); 
        if length(unY)==1
            datY(1:min_wincount,1)=unY; 
        else
            datY = zeros(min_wincount,elements_per_winY);
            for i=1:min_wincount
                bg = (i-1)* elements_per_overlapY + 1;
                en = bg + elements_per_winY - 1 ;
                datY(i,:) = data.Y(bg:en,1)';
            end
        end
    end
    %%%% artifact - error 
    if isfield(data,'E')
        if size(data.E,2) > 1
            for ch=1:size(data.E,2)
                unE=unique(data.E(:,ch));
                if length(unE) == 1
                    datE{1}.var{ch}.E(1:min_wincount,1)=unE;
                else
                    newE = zeros(min_wincount,elements_per_winY);
                    for i=1:min_wincount
                        bg = (i-1)* elements_per_overlapY + 1;
                        en = bg + elements_per_winY - 1 ;
                        newE(i,:) = data.E(bg:en,ch);
                    end
                    datE{1}.var{ch}.E = newE;
                end
            end
        else
            unE = unique(data.E);
            if length(unE)==1
                datE{1}.var(1:min_wincount,1)=unE;
            else
                datE{1}.var = zeros(min_wincount,elements_per_winY);
                for i=1:min_wincount
                    bg = (i-1)* elements_per_overlapY + 1;
                    en = bg + elements_per_winY - 1 ;
                    datE{1}.var(i,:) = data.E(bg:en,1)';
                end
            end
        end
    end
end
