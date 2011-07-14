function fig2html(varargin)
% The "fig2html" function saves the given figures to file and writes an
% HTML document to display the figures.
%
% USAGE:
%   fig2html([figureHandles],[optionStr1,optionVal1])
% 
% INPUTS:
%   [figureHandles] - (figure handles) [Default all open figures]
%       A set of figure handles that will be added to an html document.
%
% OPTIONS LIST:
%   [htmlName]  - (string) [Default Figures_YYYY-MM-DD-HH-MM]
%       Name of HTML file without .html extension.
%
%   [htmlLocation] - (string) [Default pwd]
%       Location of where HTML file will be saved. If "htmlLocation"
%       directory does not exist function attempts to create it.
%
%   [htmlTitle] - (string) [Default htmlName]
%       Title of HTML page.
%
%   [numOfColumns] - (1 x 1 positve integer) [Default 1]
%       Specifies how the figures will be laid out in the html file.
%
%   [defaultFigFormat] - (string) [Default '-dpng']
%       Sets default figure format.
%
%   [defaultFigPathType] - ('relative' or 'absolute') [Default 'relative']
%       Sets default figure path type.
%
%   [defaultFigLocation] - (string) [Default htmlLocation]
%       Sets default location of where the figures will be saved.
%
%   [defaultFigWidth] - (1 x 1 positive integer) [Default 400]
%       Sets default figure width.
%
%   [defaultFigHeight] - (1 x 1 positive integer) [Default 400]
%       Sets default figure height.
%
%   [figName] - (string or cell array of strings) [Default figure window title]
%       File name of figure.
%
%   [figFormat] - (string or cell array of strings) [Default defaultFigFormat]
%       File format of figure. Valid formats are can be found in the help
%       file under "print" and "Grapics Format Files".
%
%   [figPathType] - ('relative' or 'absolute' or cell array of strings) [Default defaultFigPathType]
%       Type of path that will link each figure to the HTML document. If
%       'relative' is selected the "figLocation" must be a path to a folder that is
%       within "htmlLocation".
%
%   [figLocation] - (string or cell array of strings) [Default defaultFigLocation]
%       Location of where figures will be stored.
%   
%   [figTitle] - (string or cell array of strings) [Default figName]
%       Title of figure.
%
%   [figDescription] - (string or cell array of strings) [Default '']
%       Description of figure.
%
%   [figWidth] - (positive integers) [Default defaultFigWidth]
%       Width of figure in pixels.
%
%   [figHeight] - (positive integers) [Default defaultFigHeight]
%       Height of figure in pixels.
%
%   [saveFigure] - (1 x 1 logical) [Default true]
%       Saves the given figure to file if true, otherwise only the html
%       text will be written. The function runs faster if the figures are
%       not saved to file.
%
% DESCRIPTION:
%   This function creats an HTML document containing figures that are
%   currently open in Matlab. It has a number of opitions to customize the
%   HTML document.
%
% EXAMPLES:
% fig2html([1 2 4]...
%     'htmlName','SomeFigures',...
%     'htmlLocation','~/Matlab/Working/Output',...
%     'htmlTitle','TheseFigures',...
%     'numOfColumns',4 ...
%     )
%
% NOTES:
%   - Might not work properly on a Windows machine.
%
%   - Use sort(get(0,'Children')) to get all open figure windows.
%
% NECESSARY FILES:
%
% SEE ALSO:
%    figTile, figForward
%
% REVISION:
%   1.0 22-JAN-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check platform
if ~isunix
    warning('fig2html:platformChk','This function may not run properly on a Windows machine.')
end

% Get figure handles
if nargin == 0 || ischar(varargin{1})
    figureHandles = sort(get(0,'Children'));
else
    figureHandles = varargin{1};
    varargin = varargin(2:end);
end

% Check input arguments for errors
assert(all(ishandle(figureHandles)),...
    'fig2html:figureHandlesChk',...
    'Input argument "figureHandles" must all be valid graphics handles.')
nFigs = numel(figureHandles);

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'fig2html:optionsChk1','"options" must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case 'htmlname'
            htmlName = optValues{iParam};
        case 'htmllocation'
            htmlLocation = optValues{iParam};
        case 'htmltitle'
            htmlTitle = optValues{iParam};
        case 'numofcolumns'
            numOfColumns = optValues{iParam};
        case 'defaultfigformat'
            defaultFigFormat = optValues{iParam};
        case 'defaultfigpathtype'
            defaultFigPathType = optValues{iParam};
        case 'defaultfiglocation'
            defaultFigLocation = optValues{iParam};
        case 'defaultfigwidth'
            defaultFigWidth = optValues{iParam};
        case 'defaultfigheight'
            defaultFigHeight = optValues{iParam};
        case 'figname'
            figName = optValues{iParam};
        case 'figformat'
            figFormat = optValues{iParam};
        case 'figpathtype'
            figPathType = optValues{iParam};
        case 'figlocation'
            figLocation = optValues{iParam};
        case 'figtitle'
            figTitle = optValues{iParam};
        case 'figdescription'
            figDescription = optValues{iParam};
        case 'figwidth'
            figWidth = optValues{iParam};
        case 'figheight'
            figHeight = optValues{iParam};
        case 'savefigure'
            saveFigure = optValues{iParam};
        otherwise
            error('fig2html:optionsChk2','Option string %s is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary and check optional arguments for errors
% For html options
if ~exist('htmlName','var'), htmlName = ['Figures_' datestr(now,'yyyy-mm-dd-HH-MM')]; end
if ~exist('htmlLocation','var'), htmlLocation = pwd; end
if ~exist('htmlTitle','var'), htmlTitle = htmlName; end
if ~exist('numOfColumns','var'), numOfColumns = 1; end

assert(ischar(htmlName),...
    'fig2html:htmlNameChk',...
    'Optional argument "htmlName" must be a string.')

assert(ischar(htmlLocation),...
    'fig2html:htmlLocationChk',...
    'Optional argument "htmlLocation" must be a string.')
if ~isdir(htmlLocation)
    [valid,errMsg,msgID] = mkdir(htmlLocation);
    if ~valid, error(msgID,errMsg), end
end
if isunix
    if htmlLocation(1) ~= filesep
        htmlLocation = [pwd filesep htmlLocation];
    end
end
if htmlLocation(end) ~= filesep
    htmlLocation = [htmlLocation filesep];
end

assert(ischar(htmlTitle),...
    'fig2html:htmlTitleChk',...
    'Optional argument "htmlTitle" must be a string.')

assert(isnumeric(numOfColumns) && isreal(numOfColumns) && isequal(size(numOfColumns),[1 1]) && mod(numOfColumns,1) == 0 && numOfColumns > 0,...
    'fig2html:numOfColumnsChk',...
    'Optional argument "numOfColumns" must be a 1 x 1 positive real integer.')

% For default options
if ~exist('defaultFigFormat','var')
    defaultFigFormat = '-dpng'; defaultFigExt = 'png';
else
    assert(ischar(defaultFigFormat),...
        'fig2html:defaultFigFormatChk1',...
        'Optional argument "defaultFigFormat" must be a string.')
    [isValidFigFormat,defaultFigExt] = figFormatChk(defaultFigFormat);
    assert(isValidFigFormat,...
        'fig2html:defaultFigFormatChk2',...
        'Optional argument "defaultFigFormat" is an invalid graphics format.')
end
if ~exist('defaultFigPathType','var')
    defaultFigPathType = 'relative';
else
    assert(ischar(defaultFigPathType) && ismember(defaultFigPathType,{'relative','absolute'}),...
    'fig2html:defaultFigPathTypeChk',...
    'Optional argument "defaultFigPathType" must be either ''relative'' or ''absolute''')
end
if ~exist('defaultFigLocation','var')
    defaultFigLocation = htmlLocation;
else
    assert(ischar(defaultFigLocation) && isdir(defaultFigLocation),...
    'fig2html:defaultFigLocationChk',...
    'Optional argument "defaultFigLocation" must be a string containing a valid directory path.')
end
if ~exist('defaultFigWidth','var')
    defaultFigWidth = 400;
else
    assert(isreal(defaultFigWidth) && isnumeric(defaultFigWidth) && isequal(size(defaultFigWidth),[1 1]) && defaultFigWidth > 0 && mod(defaultFigWidth,1) == 0,...
    'fig2html:defaultFigWidthChk',...
    'Optional argument "defaultFigWidth" must be a 1 x 1 positive integer.')
end
if ~exist('defaultFigHeight','var')
    defaultFigHeight = 400;
else
    assert(isreal(defaultFigHeight) && isnumeric(defaultFigHeight) && isequal(size(defaultFigHeight),[1 1]) && defaultFigHeight > 0 && mod(defaultFigHeight,1) == 0,...
    'fig2html:defaultFigHeightChk',...
    'Optional argument "defaultFigHeight" must be a 1 x 1 positive integer.')
end

% For figure options
if ~exist('figName','var'), figName = cell(nFigs,1); end
if ~exist('figFormat','var'), figFormat = repmat({defaultFigFormat},nFigs,1); end
if ~exist('figPathType','var'), figPathType = repmat({defaultFigPathType},nFigs,1); end
if ~exist('figLocation','var'), figLocation = repmat({defaultFigLocation},nFigs,1); end
if ~exist('figTitle','var'), figTitle = figName; end
if ~exist('figDescription','var'), figDescription = cell(nFigs,1); end
if ~exist('figWidth','var'), figWidth = defaultFigWidth*ones(nFigs,1); end
if ~exist('figHeight','var'), figHeight = defaultFigHeight*ones(nFigs,1); end
if ~exist('saveFigure','var'), saveFigure = true; end

if ~iscell(figName), figName = {figName}; end
assert(all(cellfun(@(aCell) ischar(aCell) | isempty(aCell),figName)),...
    'fig2html:figNameChk',...
    'Optional argument "figName" must be a string or a cell array of strings.')
figName = figName(:);
if numel(figName) < nFigs, figName = [figName;cell(nFigs-numel(figName),1)]; end

if ~iscell(figFormat), figFormat = {figFormat}; end
assert(all(cellfun(@ischar,figFormat)),...
    'fig2html:figFormatChk1',...
    'Optional argument "figFormat" must be a string or a cell array of strings.')
figFormat = figFormat(:);
[isValidFigFormat,figExt] = figFormatChk(figFormat);
assert(all(isValidFigFormat(:)),...
    'fig2html:figFormatChk2',...
    'Optional argument "figFormat" is an invalid graphics format.')
if numel(figFormat) < nFigs, figFormat = [figFormat;repmat({defaultFigFormat},nFigs-numel(figFormat),1)]; end
if numel(figExt) < nFigs, figExt = [figExt;repmat({defaultFigExt},nFigs-numel(figExt),1)]; end

if ~iscell(figPathType), figPathType = {figPathType}; end
assert(all(cellfun(@ischar,figPathType)) && all(ismember(figPathType,{'relative','absolute'})),...
    'fig2html:figPathTypeChk',...
    'Optional argument "figPathType" must be either ''relative'' or ''absolute'' or a cell array of strings of ethier opition.')
figPathType = figPathType(:);
if numel(figPathType) < nFigs, figPathType = [figPathType;repmat({defaultFigPathType},nFigs-numel(figPathType),1)]; end

if ~iscell(figLocation), figLocation = {figLocation}; end
assert(all(cellfun(@ischar,figLocation)) && all(cellfun(@isdir,figLocation)),...
    'fig2html:figLocationChk1',...
    'Optional argument "figLocation" must be a string or a cell array of strings of valid directory paths.')
figLocation = figLocation(:);
if numel(figLocation) < nFigs, figLocation = [figLocation;repmat({defaultFigLocation},nFigs-numel(figLocation),1)]; end
for iFig = 1:nFigs
    if isunix
        if figLocation{iFig}(1) ~= '/';
            figLocation{iFig} = [pwd filesep figLocation{iFig}];
        end
    else
        if figLocation{iFig}(2) ~= ':';
            figLocation{iFig} = [pwd filesep figLocation{iFig}];
        end
    end    
    if figLocation{iFig}(end) ~= filesep
        figLocation{iFig} = [figLocation{iFig} filesep];
    end
    if strcmp(figPathType{iFig},'relative')
        charInd = strfind(figLocation{iFig},htmlLocation);
        assert(~isempty(charInd),...
            'Optional argument "figLocation" must be a path to a folder that is within "htmlLocation".')
       figLocation{iFig} = figLocation{iFig}(end-(length(figLocation{iFig})-length(htmlLocation))+1:end); 
    end
end

if ~iscell(figTitle), figTitle = {figTitle}; end
assert(all(cellfun(@(aCell) ischar(aCell) | isempty(aCell),figTitle)),...
    'fig2html:figTitleChk',...
    'Optional argument "figTitle" must be a string or a cell array of strings.')
figTitle = figTitle(:);
if numel(figTitle) < nFigs, figTitle = [figTitle;cell(nFigs-numel(figTitle),1)]; end

if ~iscell(figDescription), figDescription = {figDescription}; end
assert(all(cellfun(@(aCell) ischar(aCell) | isempty(aCell),figDescription)),...
    'fig2html:figDescriptionChk',...
    'Optional argument "figDescription" must be a string or a cell array of strings.')
figDescription = figDescription(:);
if numel(figDescription) < nFigs, figDescription = [figDescription;cell(nFigs-numel(figDescription),1)]; end

assert(isreal(figWidth) && isnumeric(figWidth) && all(figWidth > 0) && all(mod(figWidth,1) == 0),...
    'fig2html:figWidthChk',...
    'Optional argument "figWidth" must be a vector of positive real integers.')
figWidth = figWidth(:);
if numel(figWidth) < nFigs, figWidth = [figWidth;defaultFigWidth*ones(nFigs-numel(figWidth),1)]; end

assert(isreal(figHeight) && isnumeric(figHeight) && all(figHeight > 0) && all(mod(figHeight,1) == 0),...
    'fig2html:figHeightChk',...
    'Optional argument "figHeight" must be a vector of positive real integers.')
figHeight = figHeight(:);
if numel(figHeight) < nFigs, figHeight = [figHeight;defaultFigHeight*ones(nFigs-numel(figHeight),1)]; end

assert(islogical(saveFigure) && isequal(size(saveFigure),[1 1]),...
    'fig2html:saveFigureChk',...
    'Optional argument "saveFigure" must be a 1 x 1 logical.')

%% Create new HTML file
userName = 'Rowland O''Flaherty';
htmlFilePath = [htmlLocation htmlName '.html'];
htmlFileID = fopen(htmlFilePath,'w');
fprintf(htmlFileID,'<!-- \n');
fprintf(htmlFileID,'%s.html\n',htmlName);
fprintf(htmlFileID,'The "%s" file displays a bunch of figures.\n',htmlName);
fprintf(htmlFileID,'\n');
fprintf(htmlFileID,'REVISION:\n');
fprintf(htmlFileID,'   1.0 %s by %s\n',upper(datestr(now,'dd-mmm-yyyy')),userName);
fprintf(htmlFileID,'       Initial Revision.\n');
fprintf(htmlFileID,'\n');
fprintf(htmlFileID,'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->\n');
fprintf(htmlFileID,'<html>\n');
fprintf(htmlFileID,'<title>%s</title>\n',htmlTitle);
fprintf(htmlFileID,'<body>\n');
fprintf(htmlFileID,'<table border="1">\n');

%% Loop through figures
colCnt = 0;
for iFig = 1:nFigs
    % Save figure to file
    if isempty(figName{iFig}),figName{iFig} = ['Figure ' num2str(figureHandles(iFig))]; end
    figFilePath = [figLocation{iFig} figName{iFig} '.' figExt{iFig}];
    if strcmp(figPathType{iFig},'relative') 
        figPath = [htmlLocation figFilePath];
    else
        figPath = figFilePath;
    end
    if saveFigure
        print(figureHandles(iFig),figFormat{iFig},figPath);
    end
    
    % Write HTML text
    colCnt = colCnt + 1;
    if mod(colCnt-1,numOfColumns) == 0
        fprintf(htmlFileID,'<tr>\n');
    end
    fprintf(htmlFileID,'<td align="center">\n');
    if ~isempty(figTitle{iFig})
        fprintf(htmlFileID,'%s<p>\n',figTitle{iFig});
    end
    fprintf(htmlFileID,'<img src="%s" width="%d" height="%d"><p>\n',figFilePath,figWidth(iFig),figHeight(iFig));
    if ~isempty(figDescription{iFig})
        fprintf(htmlFileID,'<div align="left">%s</div><p>\n',figDescription{iFig});
    end
    fprintf(htmlFileID,'</td>\n');
    if mod(colCnt,numOfColumns) == 0
        fprintf(htmlFileID,'</tr>\n');
    end
end

%% Close up file
fprintf(htmlFileID,'</table>\n');
fprintf(htmlFileID,'</body>\n');
fprintf(htmlFileID,'</html>\n');
fclose(htmlFileID);

%% Output
fprintf(1,'HTML figure file saved to:\n%s\n',htmlFilePath);
if isunix
    unix(['open ' htmlFilePath]);
end

end

%% Helper functions
function [isValidFigFormat,figExt] = figFormatChk(figFormat)
% The "figFormatChk" helper function checks if the "figFormat" input argument
% is a valid figure format from what is listed in the "print" help document
% page. This function also returns the corresponding file extension for the
% given format. If "figFormat" is a cell array this operation is done for
% each cell in the array. "isValidFigFormat" will be a matrix of logicals
% and "figExt" will be cell array each the same size as figFormat.

formatTable = {...
    '-dbmpmono','bmp';...
    '-dbmp16m','bmp';...
    '-dbmp256','bmp';...
    '-dbmp','bmp';...
    '-deps','eps';...
    '-depsc','eps';...
    '-deps2','eps';...
    '-depsc2','eps';...
    '-dhdf','hdf';...
    '-dill','ai';...
    '-djpeg','jpg';...
    '-dpbm','pbm';...
    '-dpbmraw','pbm';...
    '-dpcxmono','pcx';...
    '-dpcx24b','pcx';...
    '-dpcx256','pcx';...
    '-dpcx16','pcx';...
    '-dpdf','pdf';...
    '-dpgm','pgm';...
    '-dpgmraw','pgm';...
    '-dpng','png';...
    '-dppm','ppm';...
    '-dppmraw','ppm';...
    '-dtiff','tif';...
    '-dtiffn','tif';...
    };

if ~iscell(figFormat)
    figFormat = {figFormat};
    asCell = false;
else
    asCell = true;
end

nCells = numel(figFormat);
isValidFigFormat = false(size(figFormat));
figExt = cell(size(figFormat));

for iCell = 1:nCells
    figInd = ismember(formatTable(:,1),figFormat{iCell});
    isValidFigFormat(iCell) = any(figInd);
    if isValidFigFormat(iCell)
        figExt{iCell} = formatTable{figInd,2};
    end
end

if ~asCell
    figExt = figExt{1};
end

end