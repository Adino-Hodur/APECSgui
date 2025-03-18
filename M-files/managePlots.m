function hF=managePlots(param,res,fN)

% global controlPlot  
% %%% set control plot to zero first 
% controlPlot=zeros(1,10); 

% hF=[]; 

switch param.genMethod
    case {'PCA'}
        [hE]=plotControl({'pca'}, param, res, fN);
        uiwait(hE)  
    case {'PARAFAC'}
        [hE]=plotControl({'parafac'}, param, res, fN);
        uiwait(hE)             
    case 'NPLS'
        [hE]=plotControl({'npls'}, param, res, fN);
        uiwait(hE)        
    case 'KPLS'
        if strcmp(param.kernelFcn,'Linear')
            [hE]=plotControl({'npls'}, param, res, fN);
        else
            %%%% nonlinear kpls doeas not have atoms 
            [hE]=plotControl({'nkpls'}, param, res, fN);
        end
        uiwait(hE)             
end

global hFp
hF = hFp;

% param.smoothFac=controlPlot(10);   
% 
% if controlPlot(1)
%     switch param.genMethod
%         case{'NPLS','KPLS'}
%             phF = plotNPLS(res,param);
%             hF =[hF phF];
%         case {'PARAFAC'}
%             phF = plotCoreConsist(res);
%             hF =[hF phF];
%     end
% end
% if controlPlot(2)
%     switch param.genMethod
%         case{'NPLS','KPLS'}
%             phF = plotAtomsNPLS(res,param);
%         case {'PARAFAC'}
%             phF = plotAtomsPARAFAC(res,param);
%         case {'PCA'}
%             phF = plotAtomsPCA(res,param);
%     end
%     hF =[hF phF];
% end
% if controlPlot(3)
%     phF = plot_sepSpectra(fN,param);
%     hF =[hF phF];
% end
% if controlPlot(4)
%     phF = plot_sepSpectraCent(res,param);
%     hF =[hF phF];
% end
% if controlPlot(5)
%     switch param.genMethod
%         case {'PARAFAC'}
%             phF = plot_topoMap(res,param,0);
%             hF =[hF phF];
%             if param. parafacPrctRemove ~= 0
%                 phF = plot_topoMap(res,param,1);
%                 hF =[hF phF];
%             end 
%         otherwise
%             phF = plot_topoMap(res,param,0);
%             hF =[hF phF];
%     end
% end
