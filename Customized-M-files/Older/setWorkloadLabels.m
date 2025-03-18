function [dY,classLabel] = setWorkloadLabels(datY)



for i=1:size(datY,1)
    if length(unique(datY(i,:))==1)
        wL=datY(i,1);
        switch wL
            case {72,73,74,75} %%%% low workload
                dY(i,1)=-1;
            case {80,81,82,83} %%%% high workload
                dY(i,1)=1;
            otherwise
                dY(i,1)=0;
        end
    else
        dY(i,1)=0;
    end
end

classLabel=[-1 1 0];
