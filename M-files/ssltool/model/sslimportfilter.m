function Y = sslimportfilter(X,type)
%SSLIMPORTFILTER IO filter.
%   X = SSLIMPORTFILTER(X,TYPE) where 
%   TYPE is a string of the following: 'DATA','ELEC','HEAD';

% Siyi Deng; 06-30-2011;

Y = [];

try
    
switch upper(type)
    case {'DATA'}
        Y.Data = nan;
        if sslisdata(X)
            % Native;
            Y = X;
        elseif isstruct(X) && ...
                all(isfield(X,{'data','nbchan','trials','pnts','srate'}))
            % Eeglab;
            d = permute(X.data,[2 3 1]);    
            Y.Data = reshape(d,size(d,1)*size(d,2),size(d,3)); 
        else
            error('SSLTOOL:Failed to import data.');
        end
        Y = ssldatapreprocessing(Y);        

    case {'ELEC'}
        % some default values;
        Y.Coordinate = [nan nan nan]; 
        Y.Label = {'BAD'};
        Y.Fiducial = nan(4,3);
        if ssliselectrode(X)
            % Native;
            Y = X;
        elseif sslismodel(X)
            Y = X.Electrode;
        elseif isstruct(X) && ...
                all(isfield(X,{'chanlocs','nbchan','trials','pnts','srate'}))
            % Eeglab;            
            Y.Coordinate = [X.chanlocs.X;X.chanlocs.Y;X.chanlocs.Z].';
            Y.Label = {X.chanlocs.labels}.';
            Y.Fiducial = nan(4,3);
        end
        if isfield(Y,'Fiducial')
            if size(Y.Fiducial,1) ~= 4 || size(Y.Fiducial,2) ~= 3
                Y.Fiducial = nan(4,3);
            end
        end
        if ~sslelectrodequalitycheck(Y)
            Y.Coordinate = [nan nan nan]; 
            Y.Label = {'BAD'};
        end
        
    case {'MESH'}
        Y.Face = [1 2 3];
        Y.Vertex = zeros(3,3);
        if sslismesh(X)
            % Native;
            Y = X;
        elseif sslismodel(X)
            Y = X.Head;
        elseif isstruct(X) && isfield(X,'Head') && sslishead(X.Head)
            Y = X.Head;
        elseif isstruct(X) && all(isfield(X,{'faces','vertices'}))
            % Matlab fv struct; 
            Y.Face = X.faces;
            Y.Vertex = X.vertices;
        elseif isa(X,'BVQXfile')
            % Bvqx srf;
            Y.Face = X.TriangleVertex;
            Y.Vertex = X.VertexCoordinate;
        end
        if ~sslmeshqualitycheck(Y)
            Y.Face = [1 2 3];
            Y.Vertex = zeros(3,3);
        end
        
    otherwise
        Y = [];
end

catch ME
    disp(ME.message);
end

end % SSLIMPORTFILTER;


