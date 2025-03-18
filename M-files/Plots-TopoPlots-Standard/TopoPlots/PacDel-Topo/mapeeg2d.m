%%% mapeeg2d -- plot a 2-d topographical map of EEG measures
% [mapobject, h] = function mapeeg2d(channels,measures,montage,units,step,label,clevels,clines,cmap,cbar)

function [mapobject, h] = mapeeg2d(channels,measures,montage,units,step,label,clevels,clines,cmap,cbar)

% Inputs:
%   channels: a vector of row numbers to select a set of electrodes from the montage
%   measures: a vector of real-valued measures, one for each electrode
%   montage: a structure of electrode names and coordinates (default 'mont88')
%       montage.name: cell array of strings containing the names of electrodes
%       montage.x,montage.y,montage.z: vectors of 2d cartesian x,y coordinates
%       montage.x3d, montage.y3d, montage.z3d: vectors of 3d cartesian x,y,z coordinates (unused here)
%       montage.APgroup: electrode group membership 1 = anterior, 2 = posterior, 0 = neither (e.g. EOG)
%           the montage carteisan coordinate limits are x:(-1,1),y:(-1,1)
%       The channel names in the "name" element cell array of montage file. For example mont32 for 32 channels:
%       {'O2';'O1';'OZ';'PZ';'P4';'CP4';'P8';'C4','TP8';'T8';'P7';'P3';'CP3';'CPZ';'CZ';'FC4' ...
%       'FT8';'TP7';'C3';'FCZ';'FZ';'F4';'F8';'T7','FT7';'FC3';'F3';'FP2';'F7';'FP1';'HEOG';'VEOG';}
%       NOTE: new default montage file is mont88.mat (LJT 2012.12.06)
%   units: a character string that names the units of the measures
%   step: the grain of the topo map as the spacing of grid points across and down (>0 & <1)
%   label: a boolean variable, 1 = label the electrodes, 0 = don't label (default = 1)
%   clevels: the number of contour levels to compute and plot (default = 10)
%   clines:  a boolean variable, 1 = plot contour lines, 0 = don't plot (default = 1)
%   cmap: name of the Matlab colormap object for contour filling (default = 'jet')
%   cbar: a boolean variable, 1 = plot a colorbar of z values, 0 = don't plot (default = 1)
% Outputs:
%   mapobject: the computed contour matrix
%   h: handle for filled contour object
%%% Copyright © 2012. Pacific Development and Technology, LLC (www.pacdel.com)
%%% Proprietary algorithm and code.
%%% Author: L. J. Trejo (ltrejo@pacdel.com)

% Check arguments or set defualts
if isempty(channels)
    error('Channels must be specified')
end

if isempty(measures)
    error('Measures must be specified')
end
if size(measures) ~= size(channels)
    error('Number of measures must be the same as the number of channels')
end
if isempty(montage)
    if exist('mont88.mat','file') == 2
        load mont88;
        montage = mont88;
    else
        error('No montage specified and default mont88.mat not in PATH')
    end
end
% The x,y coordinate ranges must be within [-1 1] or unit circle
if ( (min(montage.x2d) < -1) | (max(montage.x2d) > 1) | (min(montage.y2d) < -1) | (max(montage.y2d) > 1))
    error('The electrode x,y coordinate ranges must both be within [-1 1]')
end
if isempty(units)
    units = 'Arbitrary Units';
end
if isempty(step)
    step=.001;   % set step size for 2-D map. 0.001 is pretty small, giving a smooth map but big file
    % recommend keeping step in range .001 to .1
end
if isempty(clevels)
    clevels = 10;
end
if isempty(clines)
    clines = 1;
end
if isempty(cmap)
    colormap jet % Default is Matlab's "rainbow" colormap; change to "gray" or others as desired
else
    colormap cmap;
end
if isempty(label)
    label = 1;
end
if isempty(cbar)
    cbar = 1;
end

% First create a grid for the map
% Compute effective minimum step from the maximum ranges of the electrode x,y coordinates
% The x,y coordinate ranges must be within [-1 1] or unit circle
% Make a square grid, even if x*y is not square

% Some big data sets take a long time to interpolate. The wait bar tells you
% the code is working, not crashed. You can take out all the waitbar 
% statements if they are annoying in fast plots
%w = waitbar(0,'1','Name','Creating contour map ...', ... 
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
%setappdata(w,'canceling',0)
%waitbar(.25,w,'Creating grid...')

% Interpolate and grid the data for plotting (makes a regularly spaced interpolated map from randomly spaced x,y,z triplets)
% Assign to z the measures (z values) for the selected channels in the map
% Measures can be a vector of any real values but must have the same length as 'channels'
%waitbar(.5,w,'Interpolating and gridding the measures ...')
x = montage.x2d(channels);
y = montage.y2d(channels);
z = measures;

% ---- MODIFICATION MADE ----
% adjust coordinates to fit used electrodes tightly

% gpv = -1:step:1; % grid point vector for gridding
gpvX = (floor( 100*min(x) )/100) : step : (ceil( 100*max(x) )/100);
gpvY = (floor( 100*min(y) )/100) : step : (ceil( 100*max(y) )/100);
[XI,YI] = meshgrid(gpvX,gpvY);

ZI = griddata(x,y,z,XI,YI,'cubic');
% Mathworks recommends TriScatteredInterp vs. griddata
% That function is slower and with the natural method it is similar
% to gridddata/cubic, but seems to smooth the features too much
% For reference the alternate code is as follows. Use these two lines
% to replace the line aboove <ZI = griddata(x,y,z,XI,YI,'cubic')>:
%    F = TriScatteredInterp(x,y,z,'natural');
%    ZI = F(XI,YI);

%waitbar(.75,w,'Plotting the contours and labels ...')
% Draw the filled contour plot with contour lines or omit contour lines if requested
% Make the plot z limits 10% bigger than the z data limits
% Square the plot box and data aspect ratios

if (clines == 1)
    [mapobject, h] = contourf(XI,YI,ZI,clevels,'Color',[.8 .8 .8]);
else
    [mapobject, h] = contourf(XI,YI,ZI,clevels,'LineStyle','none');
end 
zlim = 1.1*[min(ZI(:)) max(ZI(:))];

% x label modification
if min(x) < 0
    if max(x) < 0
        xlabel('-Left','FontName','AvantGarde','FontWeight','b');
    else
        xlabel('-Left          +Right','FontName','AvantGarde','FontWeight','b');
    end
else
    xlabel('+Right','FontName','AvantGarde','FontWeight','b');
end

% y label modification
if min(y) < 0
    if max(y) < 0
        ylabel('-Posterior','FontName','AvantGarde','FontWeight','b');
    else
        ylabel('-Posterior   +Frontal','FontName','AvantGarde','FontWeight','b');
    end
else
    ylabel('+Frontal','FontName','AvantGarde','FontWeight','b');
end

% xlabel('-Left          +Right','FontName','AvantGarde','FontWeight','b');
% ylabel('-Posterior   +Frontal','FontName','AvantGarde','FontWeight','b');

%%%%% R.R. on 2 July 2018: commneted this out - doesnot work with zlim for
%%%%% Matalb v.16 and up  
% set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1],'ZLim',zlim); % square plot
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]); % square plot

% Add electrode labels or omit them if requested
% Label the channels using names in the .names cell array
% Use xor mode so text is readable on any color beneath
if (label == 1)
    hold on
    % e=cell2mat(montage.name(channels));
    for n = 1:length(channels)
        %text(x(n),y(n),z(n)+.2,e(n,:),'FontSize',10,'EraseMode','xor',...
            % 'HorizontalAlignment','center','FontName','AvantGarde','FontWeight','b')
        text(x(n),y(n),z(n)+.2,montage.name(channels(n)),'FontSize',10,'EraseMode','xor',...
            'HorizontalAlignment','center','FontName','AvantGarde','FontWeight','b')
    end
end

% Add a colorbar or omit it if requested
% Label the colorbar with the units variable
if (cbar == 1)
    colorbar
    text(1.1,-1.1,units)
end
hold off
%waitbar(1,w,'Done.')
%pause(1)
%delete(w)       % DELETE the waitbar