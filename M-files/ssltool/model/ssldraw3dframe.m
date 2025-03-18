function hFrame = ssldraw3dframe(hAxes,hParent)
%SSLDRAW3DFRAME Add a 3D coordinate frame.
%   H = SSLDRAW3DFRAME(AXES,PARENT)

% Siyi Deng; 03-04-2011;

if nargin < 2, hParent = ancestor(hAxes,'Figure'); end
hFrame = axes('parent',hParent,'position',[.82 .10 .10 .10],...
    'unit','norm','Tag','Axis3D');
hold(hFrame,'on');
plot3([0 1],[0 0],[0 0],'r-s','linewidth',2,'markersize',2);
plot3([0 0],[0 1],[0 0],'g-s','linewidth',2,'markersize',2);
plot3([0 0],[0 0],[0 1],'b-s','linewidth',2,'markersize',2);
text(3/2,0,0,'x','color','w','horizontal','center',...
    'backg',[.2 .2 .2],'edgecolor','w');
text(0,3/2,0,'y','color','w','horizontal','center',...
    'backg',[.2 .2 .2],'edgecolor','w');
text(0,0,3/2,'z','color','w','horizontal','center',...
    'backg',[.2 .2 .2],'edgecolor','w');
view(hFrame,get(hAxes,'view'));
axis(hFrame,'vis3d','off');
hold(hFrame,'off');

hLink = linkprop([hFrame,hAxes],{'View'});
setappdata(hAxes,'LinkView',hLink);
set(ancestor(hAxes,'Figure'),'CurrentAxes',hAxes);
end % SSLDRAW3DFRAME;

