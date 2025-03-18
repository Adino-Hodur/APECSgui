function D = ssldatapreprocessing(D)
%SSLDATAPREPROCESSING Process EEG after imported.

% Siyi Deng; 03-01-2010;

if ~isreal(D.Data), D.Data = abs(D.Data); end
badChan = find(any(~isfinite(D.Data)));
zeroChan = find(all(D.Data == 0));

if isfield(D,'ExcludeChannel')
    exChan = D.ExcludeChannel(:);
else
    exChan = [];
end
D.ExcludeChannel = unique([exChan;badChan(:);zeroChan(:)]);
x = D.Data;
if size(D.Data,2) > max(D.ExcludeChannel)
    x(:,D.ExcludeChannel) = [];
end
x = x(:);
D.Max = max(x);
D.Min = min(x);
D.NumFrame = size(D.Data,1);
end % SSLDATAPREPROCESSING;

