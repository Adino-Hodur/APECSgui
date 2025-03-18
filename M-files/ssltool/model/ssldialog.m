function x = ssldialog(sTitle,sContent,aLink,aMode)
%SSLDIALOG A dialog box.
%   X = SSLDIALOG(S,C,L,M) brings up a dialog GUI with 3 buttons.
%   S is a string for dialog title.
%   C is a string or char cell array for main body of message.
%   L is a string of a path to show the help document.
%   M is either 'modal' or 'normal' to set the window style.
%   X is a boolean about user selection. 1 for OK and 0 for Cancel;
%   SSLDIALOG... with no output argument brings up a GUI with 1 button.

% Siyi Deng; 04-06-2011;

if nargin < 3, aLink = []; end
if nargin < 4, aMode = 'modal'; end
H = guihandles(openfig('SSL_GUI_DIALOG.fig'));

if ischar(sContent), sContent = {sContent}; end
sContent = cellfun(@(x)([x,'\n']),sContent,'Uniform',false);
sContent = sprintf([sContent{:}]);

set(H.TextTitle,'string',sTitle);
set(H.TextContent,'string',sContent);
set(H.Fig,'WindowStyle',aMode);

if isempty(aLink)
    set(H.ButtonHelp,'visible','off','enable','off');
else
    set(H.ButtonHelp,'callback',{@localHelpCall,aLink});
end

set(H.ButtonOk,'callback',{@localSelCall,H.Fig,true});
set(H.ButtonCancel,'callback',{@localSelCall,H.Fig,false});
set(H.Fig,'closerequestfcn',{@localSelCall,H.Fig,false});

if nargout == 0
    set(H.ButtonOk,'position',get(H.ButtonHelp,'Position'));
    set(H.ButtonCancel,'visible','off','enable','off');
    set(H.ButtonHelp,'visible','off','enable','off');
end

setappdata(H.Fig,'x',[]);
uiwait(H.Fig);
x = getappdata(H.Fig,'x');
delete(H.Fig);
% closereq;
end % SSLDIALOG;

function localHelpCall(~,~,aLink)
web(aLink,'-browser');
end % LOCALHELPCALL;

function localSelCall(~,~,hFig,x)
setappdata(hFig,'x',x);
uiresume(hFig);
end % LOCALSELCALL;








