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
%   'fontSize' - (1 x 1 positive number) [14] 
%       New font size for text in the figure.
%
%   'lineWidth' - (1 x 1 positive number) [2]
%       New width of lines in the figures.
%
%   'boldText' - (1 x 1 logical) [true]
%       If true the text will be bold. Other the font weight will be
%       normal.
% 
% OUTPUTS:
%
% NOTES:
%   To have handle objects be ignored by the figBoldify function set the
%   'UserData' property of the handle object to 'boldifyIgnore'.
%
% EXAMPLES:
%   ylabel('$$u$$','Interpreter','latex','FontSize',20,'UserData','boldifyIgnore')
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
        case lower('fontSize')
            fontSize = propValues{iParam};
        case lower('lineWidth')
            lineWidth = propValues{iParam};
        case lower('boldText')
            boldText = propValues{iParam};
        otherwise
            error('figBoldify:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('fontSize','var'), fontSize = 14; end
if ~exist('lineWidth','var'), lineWidth = 2; end
if ~exist('boldText','var'), boldText = true; end

% Check property values for errors
assert(isnumeric(fontSize) && isreal(fontSize) && isequal(size(fontSize),[1,1]) && fontSize > 0,...
    'figBoldify:fontSize',...
    'Property "fontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(lineWidth) && isreal(lineWidth) && isequal(size(lineWidth),[1,1]) && lineWidth > 0,...
    'figBoldify:lineWidth',...
    'Property "lineWidth" must be a 1 x 1 positive real numbers.')

assert(islogical(boldText) && isequal(size(boldText),[1,1]),...
    'figBoldify:boldText',...
    'Property "boldText" must be a 1 x 1 logical.')

%% Get handles
% Ignore handles
ignoreH = findall(figH,'UserData','figBoldifyIgnore');

% Axes handles
axH = findall(figH,'Type','axes');
axH = setdiff(axH,ignoreH);

% Line handles
lineH = findall(figH,'Type','line');
lineH = setdiff(lineH,ignoreH);

% Text handles
textH = findall(figH,'Type','text');
textH = setdiff(textH,ignoreH);


%% Set properties
% Font
set(axH,'FontSize',fontSize)
set(textH,'FontSize',fontSize)

if boldText
    set(axH,'FontWeight','bold')
    set(textH,'FontWeight','bold')
else
    set(axH,'FontWeight','normal')
    set(textH,'FontWeight','normal')
end

% Line width
set(lineH,'LineWidth',lineWidth)

end
