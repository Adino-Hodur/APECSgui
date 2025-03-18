function H = sslcanvas3d(isHidden)
%SSLCANVAS3D Prepare the 3D figure for plotting.
%   SSLCANVAS3D(1) creates a hidden figure.

% Siyi Deng; 03-01-2010;

if nargin < 1, isHidden = false; end

H.Fig = figure('Visible','off','NumberTitle','off',...
    'MenuBar','figure','Toolbar','figure','DockControls','on',...
    'Name','SSLTool','nextplot','add');
H.Axes = axes('Parent',H.Fig,'Units','normalized',...
    'Position',[.05 .05 .9 .9],'nextplot','add');
hold(H.Axes,'on'); % a brute fix to the plot3 reset axis behavior;
axis vis3d equal off;
if ~isHidden, set(H.Fig,'visible','on'); end

end % SSLCANVAS3D;

