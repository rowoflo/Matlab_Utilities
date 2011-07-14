function aColorMap = customColorMap(varargin)
% The "customColorMap" function creates a custom made colormap.
%
% USAGE:
%   aColorMap = customColorMap({i1,[r1,g1,b1]},{i2,[r2,g2,b2]},...)
% 
% INPUTS:
%   i1 - (1 x 1 positive integer) The index in the color map indexing where
%       the color [r1,g1,b1] will be placed.
%
%   [r1,g1,b1] - (1 x 3 numbers between 0 and 1) The RGB colors for the
%       point p1.
% 
% OUTPUTS:
%   aColorMap - (N x 3 numbers) A new colormap matrix.
%
% DESCRIPTION:
%   This function creates custom colormaps. The colormaps will vary
%   linearly from the index and colors given in each cell of the input
%   argument. If one of the indexes is not equal to 1 the color of the
%   lowest point will be held constant from that index until the index of
%   1. The value of the largest index will be the number of indexes in the
%   outputed colormap.
%
% EXAMPLES:
%   myColorMap = customColorMap({100,[0 1 0]},{85,[1 1 0]},{70,[1 0 0]})
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% REVISION:
%   27-AUG-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(1,inf,nargin))

inds = zeros(nargin,1);
colors = zeros(nargin,3);

for iArg = 1:nargin
    if ~iscell(varargin{iArg})
        error('customColorMap:vararginChk','All input arguments must be cells')
    end
    if ~isnumeric(varargin{iArg}{1}) ||~isscalar(varargin{iArg}{1}) || mod(varargin{iArg}{1},1) ~= 0 || varargin{iArg}{1} < 1
        error('customColorMap:indexChk','Index values must be positive integers')
    end
    if ~isnumeric(varargin{iArg}{2}) ||~isvector(varargin{iArg}{2}) || length(varargin{iArg}{2}) ~= 3 || ~(all(varargin{iArg}{2}) >= 0 && all(varargin{iArg}{2}) <= 1)
        error('customColorMap:colorChk','Color values must be 1 x 3 vector of numbers between 0 and 1')
    end
    inds(iArg) = varargin{iArg}{1};
    colors(iArg,:) = varargin{iArg}{2}(:)';
end

% Sort arguments
[inds,sortedInds] = sort(inds,'descend');
colors = colors(sortedInds,:);

% Build colormap
aColorMap = zeros(inds(1),3);
for iInds = 1:length(inds)-1
    nInds = (inds(iInds) - inds(iInds+1));
    aColorMap(inds(iInds):-1:inds(iInds+1),1) = linspace(colors(iInds,1),colors(iInds+1,1),nInds+1)';
    aColorMap(inds(iInds):-1:inds(iInds+1),2) = linspace(colors(iInds,2),colors(iInds+1,2),nInds+1)';
    aColorMap(inds(iInds):-1:inds(iInds+1),3) = linspace(colors(iInds,3),colors(iInds+1,3),nInds+1)';
end
if inds(end) ~= 1
    aColorMap(1:inds(end)-1,:) = repmat(aColorMap(inds(end),:),inds(end)-1,1);
end
end
