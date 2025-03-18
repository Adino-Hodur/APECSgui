function hF = plot_sepSpectra(fName,param)

load(fName,'datX','header'); 
X = datX{1}; 
clear datX 

hF={'fig_spect1'};

cstring='grbcmk'; 
lenColor=length(cstring); 

pWin = length(header.Xlabels);
fL   = header.fLines;  

%%% step for ticks 
stIn=[5 10:100];jj=1;  
stT=0; 
while ~stT
    if (fL(end)/stIn(jj)) < 10       
        stT=stIn(jj);
    else 
        jj=jj+1; 
    end
end
    

pS=ceil(pWin/5);
figure('Name',hF{1});

   

for i=1:pWin
    if pS == 1
        subplot(pS,pWin,i)
    else
        subplot(pS,5,i)
    end 
    
    bg = (i-1)*length(fL) + 1; 
    en = bg + length(fL) - 1; 
    
    %%%%%% one class only !!!! modeling or regression 
    if param.numClass==1
        plot(fL, mean(X.trainClass{1}(:,bg:en)),'');
        hold on
        ii=find(rem(fL,stT)==0);
        set(gca,'Xtick',fL(ii),'XminorTick','on');
        if ~isempty(X.testClass{1})
            plot(fL, mean(X.testClass{1}(:,bg:en)),'r:');
        end
        if ~isempty(X.testClass{1})
            minY=min([min(mean(X.trainClass{1}(:,bg:en))), min(mean(X.testClass{1}(:,bg:en)))]);
            maxY=min([max(mean(X.trainClass{1}(:,bg:en))), max(mean(X.testClass{1}(:,bg:en)))]);
        else
            minY=min(mean(X.trainClass{1}(:,bg:en)));
            maxY=max(mean(X.trainClass{1}(:,bg:en)));
        end
        axis([fL(1) fL(end) minY maxY ])     
        if i==pWin
            legend('train','test');
        end
    else
        for c=1:length(X.trainClass)
            plot(fL, mean(X.trainClass{c}(:,bg:en)),[cstring(mod(c,lenColor)+1)]);
            hold on
            if c==1 
                minY(1) = min(mean(X.trainClass{c}(:,bg:en)));
                maxY(1) = max(mean(X.trainClass{c}(:,bg:en)));
            else 
                minY(end+1) = min(mean(X.trainClass{c}(:,bg:en)));
                maxY(end+1) = max(mean(X.trainClass{c}(:,bg:en)));
            end 
        end 
        ii=find(rem(fL,stT)==0);
        set(gca,'Xtick',fL(ii),'XminorTick','on');
        for c=1:length(X.testClass)
            if ~isempty(X.testClass{c})
                plot(fL, mean(X.testClass{c}(:,bg:en)),[cstring(mod(c,lenColor)+1),':']);
                minY(end+1) = min(mean(X.testClass{c}(:,bg:en)));
                maxY(end+1) = max(mean(X.testClass{c}(:,bg:en)));
            end
        end
        axis([fL(1) fL(end) min(minY) max(maxY)])
        if i==pWin            
            for c=1:length(X.trainClass)
                strL{c}=['train class', num2str(c)];
            end
            if length(X.testClass) == 1
                if ~isempty(X.testClass{1})
                    strL{end+1}='test class';
                end
            else
                for c=1:length(X.testClass)
                    if ~isempty(X.testClass{c})
                        strL{end+1}=['test class', num2str(c)];
                    end
                end
            end
            legend(strL);
        end
    end
        
    xlabel(header.Xlabels{i})

end 
