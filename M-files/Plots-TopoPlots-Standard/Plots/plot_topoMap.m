function [hF] = plot_topoMap(res,param,run)

modal=length(size(res.Xtrain));

switch modal
    case 2
        [A B]=fac2let(res.Xfactors);
    case 3
        switch run
            case 0
                [A B C]=fac2let(res.Xfactors);
            case 1
                [A B C]=fac2let(res.Xfactors1);
        end
end

%%%% get channels 
load mont88
if isfield(param,'Xlabels2use')
    elect2use = param.Xlabels2use; 
else 
    elect2use = param.Xlabels; 
end 

%%% if old names - convert !
for i=1:length(elect2use)
    switch elect2use{i}
        case 'T3'
            elect2use{i}='T7';
        case 'T4'
            elect2use{i}='T8';
        case 'T5'
            elect2use{i}='P7';
        case 'T6'
            elect2use{i}='P8';
    end
end




for i=1:length(elect2use)
    poz =  find(strcmpi(mont88.name,strtrim(elect2use{i}))==1); 
    if ~isempty(poz)
        channels(i,1)=poz; 
    end 
end 

switch modal
    case 3
        if strcmp(param.genMethod,'PARAFAC') && param.parafacPrctRemove ~= 0
            switch run
                case 0
                    hF={'fig_topoMap_run1'};
                case 1
                    hF={'fig_topoMap_run2'};
            end
        else
            hF={'fig_topoMap'};
        end
        figure('Name',hF{1});
        pWin = size(B,2);
        pS=ceil(pWin/3);
        for i=1:pWin
            if pS == 1
                subplot(pS,pWin,i)
            else
                subplot(pS,3,i)
            end
            % set sixth parameter, label = 0, to turn off labels
            mapeeg2d(channels,B(:,i),[],[],0.01,0,[],[],[],[]);
            %mapeeg2d(channels,B(:,i),[],[],[],[],[],[],[],[]);
            % topoplot(B(:,i),'my8channelsUSAF_Standard-10-20-Cap19.locs')
            if strcmp(param.genMethod,'PARAFAC') && param.parafacPrctRemove ~= 0 
                title(['PARAFAC run:',num2str(run+1),' atom:',num2str(i)]); 
            else
                title([param.genMethod,' atom:',num2str(i)]);
            end 
        end
    case 2
        ii=find(rem(param.fLines(param.fLinesInd2use),4)==0); 
        fU=param.fLinesInd2use(ii);
        fL=length(param.fLinesInd2use);
        pWin=length(fU);
        pS=ceil(pWin/3);
        for aT=1:size(B,2)
            str=['fig_topoMap_Atom',num2str(aT)];
            hF{aT}=str;
            figure('Name',hF{aT});
            for i=1:pWin
                if pS == 1
                    subplot(pS,pWin,i)
                else
                    subplot(pS,3,i)
                end
                fP=param.fLines(fU(i));
                ind=[];
                lenVar=length(param.var2use);
                for e=1:lenVar
                    poz=find(fU(i)== param.fLinesInd2use);
                    nInd=(e-1)*fL + poz;
                    ind=[ind, nInd];
                end
                mapeeg2d(channels,B(ind,aT),[],[],0.01,[],[],[],[],[]);
                %mapeeg2d(channels,B(ind,aT),[],[],[],[],[],[],[],[]);
                % topoplot(B(ind,aT),'my8channelsUSAF_Standard-10-20-Cap19.locs')
                hold on
                str=['atom ',num2str(aT),' / freq. ',num2str(fP), 'Hz'];
                title(str);
            end
            
        end
end
