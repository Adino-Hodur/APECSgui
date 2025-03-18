function clearFolders

%set(0,'fontSize',14,'fontWeight','bold')
%set(0, 'FontWeight', 'bold')
dirN='./Data/EpochedData/';
str = ['Clear subolders and files of ',dirN,' subolders'];
options.Interpreter = 'tex';
options.Default = 'Yes';
options.FontSize=20;
options.FontWight='bold';
choice = questdlg(str,'Clear subfolders and files','Yes','No',options);
if strcmpi(choice,'Yes')
    d=dir(dirN);
    if ~isempty(d)
        for i=1:length(d)
            if d(i).isdir && ~strcmp(d(i).name(1),'.')
                rmdir([dirN d(i).name],'s')
            elseif ~d(i).isdir
                delete([dirN,d(i).name])
            end
        end
    end
end

dirN='./Data/FeaturesData/';
str = ['Clear subolders and files of ',dirN,' subolders'];
options.Interpreter = 'tex';
options.Default = 'Yes';
options.FontSize=20;
options.FontWight='bold';
choice = questdlg(str,'Clear subfolders and files','Yes','No',options);
if strcmpi(choice,'Yes')
    d=dir(dirN);
    if ~isempty(d)
        for i=1:length(d)
            if d(i).isdir && ~strcmp(d(i).name(1),'.')
                rmdir([dirN d(i).name],'s')
            elseif ~d(i).isdir
                delete([dirN,d(i).name])
            end
        end
    end
end

% dirN='./Data/RawData/';
% str = ['Clear subolders and files of ',dirN,' subolders'];
% options.Interpreter = 'tex';
% options.Default = 'No';
% options.FontSize=20;
% options.FontWight='bold';
% choice = questdlg(str,'Clear subfolders and files','Yes','No',options);
% if strcmpi(choice,'Yes')
%     d=dir(dirN);
%     if ~isempty(d)
%         for i=1:length(d)
%             if d(i).isdir && ~strcmp(d(i).name(1),'.')
%                 rmdir([dirN d(i).name],'s')
%             elseif ~d(i).isdir
%                 delete([dirN,d(i).name])
%             end
%         end
%     end
% end

dirN='./Data/TrainValTest/';
str = ['Clear subolders and files of ',dirN,' subolders'];
options.Interpreter = 'tex';
options.Default = 'Yes';
options.FontSize=20;
options.FontWight='bold';
choice = questdlg(str,'Clear subfolders and files','Yes','No',options);
if strcmpi(choice,'Yes')
    d=dir(dirN);
    if ~isempty(d)
        for i=1:length(d)
            if d(i).isdir && ~strcmp(d(i).name(1),'.')
                rmdir([dirN d(i).name],'s')
            elseif ~d(i).isdir
                delete([dirN,d(i).name])
            end
        end
    end
end

dirN='./ParameterFiles/';
str = ['Clear subolders and files of ',dirN,' subolders'];
options.Interpreter = 'tex';
options.Default = 'Yes';
options.FontSize=20;
options.FontWight='bold';
choice = questdlg(str,'Clear subfolders and files','Yes','No',options);
if strcmpi(choice,'Yes')
    d=dir(dirN);
    if ~isempty(d)
        for i=1:length(d)
            if d(i).isdir && ~strcmp(d(i).name(1),'.')
                rmdir([dirN d(i).name],'s')
            elseif ~d(i).isdir
                delete([dirN,d(i).name])
            end
        end
    end
end