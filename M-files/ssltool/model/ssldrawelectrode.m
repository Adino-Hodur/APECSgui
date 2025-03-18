function hp = ssldrawelectrode(c,varargin)
%SSLDRAWELECTRODE Draw electrodes.
%   H = SSLDRAWELECTRODE(C) draws electrodes given by coordinates C.

% Siyi Deng; 03-01-2011;

if nargin < 3, varargin = {}; end
hp = plot3(c(:,1),c(:,2),c(:,3),'o',...
    'markerfacecolor',[.95 .5 .55],...
    'markeredgecolor',[1 1 1],...
    'MarkerSize',6,...
    'linewidth',2,varargin{:});
axis(ancestor(hp,'axes'),'equal','vis3d','off');
end % SSLDRAWELECTRODE;