function [fH] = saveWeights2xls(fName,res)

fH = false; 
Fac=res.numFac2Save;

numA=size(res.Xfactors,2); 

%[A,B,C]=fac2let(res.Xfactors);

dAll=[];

allC= numA*Fac; 

indC=1; 
hW=waitbar(0,'Please wait .... saving xls file ....');     
for f=1:Fac
    for a=1:numA   
        %%% first row - names 
        cN=xlsColNum2Str(indC);        
        strIn = {['atom',num2str(f),'-array',num2str(a)]}; 
        rC=[cN{1},'1'];    
        tH = xlswrite(fName,strIn,1,rC);
        if ~tH 
            fH = true; 
        end 
        % data 
        datIn = res.Xfactors{a}(:,f);       
        rC=[cN{1},'2:',cN{1},num2str(length(datIn))];
        tH = xlswrite(fName,datIn,1,rC);
        if ~tH 
            fH = true; 
        end 
        indC = indC + 1;  
        waitbar(indC/allC,hW); 
    end
end
close(hW); 
