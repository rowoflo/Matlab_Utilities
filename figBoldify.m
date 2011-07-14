function figBoldify(figH,fontSize,lineWidth)
% The "figBoldify" function sets fonts to bold, sets fonts sizes, and line
% widthes.
%
% USAGE:
%   figBoldify([figH],[fontSize],lineWidth)
% 
% INPUTS:
%   [figH] - (? x ? figure handles) [gcf]
%       Figures to apply these modifications.
%
%   [fontSize] - (1 x 1 positive number) [12] 
%       Font size.
%
%   [lineWidth] - (1 x 1 positive number) [2]
%       Width of lines in figure.
%
% OPTIONS LIST:
%   [optionStr1] - (size type) [?]
%       Description.
% 
% OUTPUTS:
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%   +package_name, someFile.m
%
% SEE ALSO:
%    related_function
%
% REVISION:
%   1.0 27-OCT-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(0,3,nargin))

% Apply default values
if nargin < 1, figH = gcf; end
if nargin < 2, fontSize = 12; end
if nargin < 3, lineWidth = 2; end

% Check input arguments for errors
assert(all(ishandle(figH)),...
    'figBoldify:figH',...
    'Input argument "figH" must be an array of figure handles.')
figH = figH(:);

assert(isnumeric(fontSize) && isreal(fontSize) && isequal(size(fontSize),[1,1]) && fontSize > 0,...
    'figBoldify:fontSize',...
    'Input argument "fontSize" must be a 1 x 1 positive real numbers.')

assert(isnumeric(lineWidth) && isreal(lineWidth) && isequal(size(lineWidth),[1,1]) && lineWidth > 0,...
    'figBoldify:lineWidth',...
    'Input argument "lineWidth" must be a 1 x 1 positive real numbers.')


% % Get and check options
% optargin = size(varargin,2);
% 
% assert(mod(optargin,2) == 0,'figBoldify:options','Options must come in pairs of an "optionStr" and an "optionVal".')
% 
% optStrs = varargin(1:2:optargin);
% optValues = varargin(2:2:optargin);
% 
% for iParam = 1:optargin/2
%     switch lower(optStrs{iParam})
%         case lower('optionStr1')
%             optionStr1 = optValues{iParam};
%         otherwise
%             error('figBoldify:options','Option string ''%s'' is not recognized.',optStrs{iParam})
%     end
% end
% 
% % Set to default value if necessary
% if ~exist('optionStr1','var'), optionStr1 = ?; end
% 
% % Check optional arguments for errors
% assert(isnumeric(optionStr1) && isreal(optionStr1) && isequal(size(optionStr1),[?,?]),...
%     'figBoldify:optionStr1',...
%     'Optional argument "optionStr1" must be a ? x ? matrix of real numbers.')

%% Get handles
% Axes handles
axH = findall(figH,'Type','axes');

% Line handles
lineH = findall(figH,'Type','line');

% Text handles
textH = findall(figH,'Type','text');

%% Set properties
% Font
set(axH,'FontWeight','bold')
set(textH,'FontWeight','bold')
set(axH,'FontSize',fontSize)
set(textH,'FontSize',fontSize)

% Line width
set(lineH,'LineWidth',lineWidth)

end
