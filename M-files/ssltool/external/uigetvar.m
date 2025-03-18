function [variable,varname] = uigetvar(variableclass)
%UIGETVAR Gui to extract a variable from the base matlab workspace.
%   [VAR,VARNAME] = UIGETVAR;
%   Gui to extract a variable from the base matlab workspace, allowing you
%   to specify the class of variables viewed 
%   usage: [variable,varname] = uigetvar;
%   usage: [variable,varname] = uigetvar(variableclass);
%
%   uigetvar ALWAYS looks at the base matlab workspace,
%   and allows you to import a single variable from that
%   workspace.
%
%   arguments: (input)
%   variableclass - a string that denotes the class of
%       the variables that will be shown in the gui menu.
%       If more than one class is allowed, then use a
%       cell array of strings.
%
%   arguments: (output)
%   variable - contents of the selected variable.
%
%   varname  - the name of the selected matlab variable
%       that was chosen from the workspace.
%
%       If cancel was indicated, then empty arrays
%       will be returned for both variable and varname.
%       Simply closing the window will cause the first
%
%   See also: uigetdir, uigetfile, who, whos

%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 2/19/10

% Copyright (c) 2010, John D'Errico
% All rights reserved.

% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.


% if variableclass is supplied, is it a string or a cellstr?
if (nargin > 1)
  error('UIGETVAR:multiple_arguments','Only 1 argument allowed for uigetvar')
elseif (nargin > 0) && ~(ischar(variableclass) || iscellstr(variableclass))
  error('UIGETVAR:string','variableclass must be a string or a cell array of strings')
elseif (nargin == 1) && ischar(variableclass)
  % only one class is provided. Just make it a cell
  % array to make things easier.
  variableclass = {variableclass};
elseif (nargin == 0)
  % no class was indicated, so list all variables
  variableclass = {};
end

% get the list of all variables in the base workspace,
par.varlist = evalin('base','whos');
% subject to any class restriction from variable class.
if ~isempty(variableclass)
  k = cellfun(@(c) ~ismember(c,variableclass),{par.varlist.class});
  par.varlist(k) = [];
end

% set up the uigetvar gui ...

% open up a figure window
par.fig = figure('Color',[0.9 0.9 0.9], ...
  'Units','normalized', ...
  'numbertitle','off',...
  'Position',[.5 .3 .2 .3], ...
  'CloseRequestFcn',@(s,e) weAreDone('closed'), ...
  'MenuBar','none', ...
  'Name','Choose a variable from the base workspace');

% set(par.fig,'unit','pixel','position',[200 200 310 400]);

% listbox of selected variables from the base workspace
par.vars = uicontrol('Parent',par.fig, ...
  'Units','normalized', ...
  'BackgroundColor',[1 1 1], ...
  'Position',[.04 .2 .92 .75], ...
  'String',{par.varlist.name}, ...
  'HorizontalAlignment','left', ...
  'Style','listbox', ...
  'FontSize',14, ...
  'Value',1, ...
  'TooltipString','Choose one variable from the base workspace');

% Cancel button
par.cancel = uicontrol('Parent',par.fig, ...
  'Units','normalized', ...
  'Position',[.56,.05 .4 .1], ...
  'String','Cancel', ...
  'HorizontalAlignment','center', ...
  'Style','pushbutton', ...
  'Callback',@(s,e) weAreDone('cancel'), ...
  'TooltipString','Cancel, returning no selected variable');

% Done button
par.done = uicontrol('Parent',par.fig, ...
  'Units','normalized', ...
  'Position',[.04,.05 .4 .1], ...
  'String','Done', ...
  'HorizontalAlignment','center', ...
  'Style','pushbutton', ...
  'Callback',@(s,e) weAreDone('done'), ...
  'TooltipString','Return the selected variable');

% set a uiwait, to not return anything until
% the done or cancel buttons were clicked.
uiwait

% ...........
% Dum, de dum. Get some coffee. Dawdle. Snooze.
% ...........

% uiresume will come back in right here.
variable = par.variable;
varname = par.varname;

% remove the figure window
delete(par.fig)


% ==========================
% end of main function
% ==========================
% begin nested functions for callbacks
% ==========================

  function weAreDone(op)
    % all done. did we cancel or was something selected?
    
    % the selection was ...
    val = get(par.vars,'value');
    
    % A fix by Siyi Deng;
    if isempty(par.varlist), op = 'cancel'; end
    
    switch op
      case 'cancel'
        % return with nothing selected
        par.variable = [];
        par.varname = '';
        
      case {'done' 'closed'}
        % a selection was made, so return that variable.
        % if more than one was selected, just take
        % the first.
        val = val(1);
        
        % we need to return the variable name as well
        % as the contents
        par.varname = par.varlist(val).name;
        par.variable = evalin('base',par.varname);
        
    end % switch op
    
    % all done now
    uiresume
    
  end % function weAreDone

end % mainline

