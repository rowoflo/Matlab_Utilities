function figBoldify(figH,varargin)
% The "figBoldify" function boldifies figures so they look better in
% presentations. The fonts are set to bold, fonts sizes are increased, and line
% widths thickend.
%
% SYNTAX:
%   figBoldify()
%   figBoldify(figH)
%   figBoldify(figH,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   figH - (? x ? figure handle) [gcf]
%       Figures to get boldified. "[]" can also be used for default
%       value.
%
% PROPERTIES:
%   'TitleFontSize' - (1 x 1 positive number) [20] 
%       New font size for axis title text in the figure.
%
%   'LabelFontSize' - (1 x 1 positive number) [18] 
%       New font size for axis label text in the figure.
%
%   'AxisFontSize' - (1 x 1 positive number [16] 
%       New font size for axis tick mark text in the figure.
%
%   'LineWidth' - (1 x 1 positive number) [2]
%       New width of lines in the figures.
%
%   'BoldText' - (1 x 1 logical) [true]
%       If true the text will be bold. Other the font weight will be
%       normal.
%
%   'Interpreter' - ('tex', 'latex', 'none') ['tex']
%       Set the text character interpretation.
% 
% OUTPUTS:
%
% NOTES:
%   To have handle objects be ignored by the figBoldify function set the
%   'UserData' property of the handle object to 'figBoldifyIgnore'.
%
% EXAMPLES:
%   ylabel('$u$','Interpreter','latex','FontSize',20,'UserData','figBoldifyIgnore')
%   figBoldify();
%
% NECESSARY FILES:
%
% AUTHOR:
%   27-OCT-2010 by Rowland O'Flaherty
%
% SEE ALSO:
%    figTile | figForward
%
%-------------------------------------------------------------------------------

%% Check Inputs

% Apply default values
if nargin < 1, figH = get(0,'Children'); end
if isempty(figH), figH = get(0,'Children'); end

% Check input arguments for errors
assert(all(ishghandle(figH)),...
    'figBoldify:figH',...
    'Input argument "figH" must be a valid figure handle.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'figBoldify:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('titleFontSize')
            titleFontSize = propValues{iParam};
        case lower('labelFontSize')
            labelFontSize = propValues{iParam};
        case lower('axisFontSize')
            axisFontSize = propValues{iParam};
        case lower('lineWidth')
            lineWidth = propValues{iParam};
        case lower('boldText')
            boldText = propValues{iParam};
        case lower('interpreter')
            interpreter = propValues{iParam};
        otherwise
            error('figBoldify:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('titleFontSize','var'), titleFontSize = 20; end
if ~exist('labelFontSize','var'), labelFontSize = 18; end
if ~exist('axisFontSize','var'), axisFontSize = 16; end
if ~exist('lineWidth','var'), lineWidth = 2; end
if ~exist('boldText','var'), boldText = true; end
if ~exist('interpreter','var'), interpreter = 'tex'; end

% Check property values for errors
assert(isnumeric(titleFontSize) && isreal(titleFontSize) && isequal(size(titleFontSize),[1,1]) && titleFontSize > 0,...
    'figBoldify:titleFontSize',...
    'Property "titleFontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(labelFontSize) && isreal(labelFontSize) && isequal(size(labelFontSize),[1,1]) && labelFontSize > 0,...
    'figBoldify:labelFontSize',...
    'Property "labelFontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(axisFontSize) && isreal(axisFontSize) && isequal(size(axisFontSize),[1,1]) && axisFontSize > 0,...
    'figBoldify:axisFontSize',...
    'Property "axisFontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(lineWidth) && isreal(lineWidth) && isequal(size(lineWidth),[1,1]) && lineWidth > 0,...
    'figBoldify:lineWidth',...
    'Property "lineWidth" must be a 1 x 1 positive real numbers.')

assert(islogical(boldText) && isequal(size(boldText),[1,1]),...
    'figBoldify:boldText',...
    'Property "boldText" must be a 1 x 1 logical.')

assert(ischar(interpreter) && ismember(interpreter,{'tex','latex','none'}),...
    'figBoldify:interpreter',...
    'Property "interpreter" must be either: ''tex'', ''latex'', or ''none''.')

%% Get handles
% Ignore handles
ignoreH = findall(figH,'UserData','figBoldifyIgnore');

% Axes handles
axH = findall(figH,'Type','axes');
axH = setdiff(axH,ignoreH);

% Colorbar handles
cbH = findall(figH,'Type','colorbar');
cbH = setdiff(cbH,ignoreH);
cbLabelH = get(cbH,'Label');
if ~iscell(cbLabelH)
    cbLabelH = {cbLabelH};
end

% Line handles
lineH = [findall(figH,'Type','line'); findall(figH,'Type','contour')];
lineH = setdiff(lineH,ignoreH);

% Title handles
titleHCell = get(axH,'Title');
titleH = [];
if iscell(titleHCell)
    for i = 1:numel(titleHCell)
        titleH(i,1) = titleHCell{i};
    end
titleH = setdiff(titleH,ignoreH);
end

% Label handles
labelHCell = [...
    get(axH,'XLabel');...
    get(axH,'YLabel');...
    get(axH,'ZLabel');...
    cbLabelH];
labelHCell = labelHCell(~cellfun(@isempty, labelHCell)); % Remove emptys
labelH = [];
if iscell(labelHCell)
    for i = 1:numel(labelHCell)
        labelH(i,1) = labelHCell{i};
    end
else
    labelH = labelHCell;
end
labelH = setdiff(labelH,ignoreH);

% Text handles
textH = findall(figH,'Type','text');
textH = setdiff(textH,[titleH;labelH]);
textH = setdiff(textH,ignoreH);


%% Set properties
% Font
set([axH; cbH; textH],'FontSize',axisFontSize)
set(titleH,'FontSize',titleFontSize)
set(labelH,'FontSize',labelFontSize)

set([titleH;labelH],'Interpreter',interpreter)
set([axH; cbH],'TickLabelInterpreter',interpreter)

if boldText
    set([axH; textH; titleH; labelH],'FontWeight','demi')
else
    set([axH; textH; titleH; labelH],'FontWeight','normal')
end

% Line width
set(lineH,'LineWidth',lineWidth)

end
