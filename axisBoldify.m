function axisBoldify(axH,varargin)
% The "axisBoldify" function boldifies axes so they look better in
% presentations. The fonts are set to bold, fonts sizes are increased, and line
% widths thickend.
%
% SYNTAX:
%   axisBoldify()
%   axisBoldify(axH)
%   axisBoldify(axH,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   axH - (? x ? axis handle) [gca]
%       Axes to get boldified. "[]" can also be used for default
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
%   To have handle objects be ignored by the axisBoldify function set the
%   'UserData' property of the handle object to 'boldifyIgnore'.
%
% EXAMPLES:
%   ylabel('$$u$$','Interpreter','latex','FontSize',20,'UserData','boldifyIgnore')
%   axisBoldify();
%
% NECESSARY FILES:
%
% AUTHOR:
%   11-APR-2014 by Rowland O'Flaherty
%
% SEE ALSO:
%    figTile | figForward
%
%-------------------------------------------------------------------------------

%% Check Inputs

% Apply default values
if nargin < 1, axH = gca; end
if isempty(axH), axH = gca; end

% Check input arguments for errors
assert(all(ishghandle(axH)),...
    'axisBoldify:axH',...
    'Input argument "axH" must be a valid axis handle.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'axisBoldify:properties',...
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
            error('axisBoldify:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('fontSize','var'), fontSize = 14; end
if ~exist('lineWidth','var'), lineWidth = 2; end
if ~exist('boldText','var'), boldText = true; end

% Check property values for errors
assert(isnumeric(fontSize) && isreal(fontSize) && isequal(size(fontSize),[1,1]) && fontSize > 0,...
    'axisBoldify:fontSize',...
    'Property "fontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(lineWidth) && isreal(lineWidth) && isequal(size(lineWidth),[1,1]) && lineWidth > 0,...
    'axisBoldify:lineWidth',...
    'Property "lineWidth" must be a 1 x 1 positive real numbers.')

assert(islogical(boldText) && isequal(size(boldText),[1,1]),...
    'axisBoldify:boldText',...
    'Property "boldText" must be a 1 x 1 logical.')

%% Get handles
% Ignore handles
ignoreH = findall(axH,'UserData','boldifyIgnore');

% Line handles
lineH = findall(axH,'Type','line');
lineH = setdiff(lineH,ignoreH);

% Text handles
textH = findall(axH,'Type','text');
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
