function figForward(figureHandles)
% The "figForward" function brings the given figures forward or the front
% of other windows.
%
% USAGE:
%   figForward([figureHandles])
% 
% INPUTS:
%   [figureHandles] - (? figure handles) [Default all figures]
%       A set of figure handles that will be tiled.
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
%
% SEE ALSO:
%    figTile, fig2html
%
% REVISION:
%   1.0 21-JAN-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(0,1,nargin))

if nargin < 1, figureHandles = sort(get(0,'Children')); end

% Check inputs for errors
assert(all(ishandle(figureHandles)),...
    'figForward:figureHandlesChk',...
    'Input argument "figureHandles" must all be valid graphics handles.')

%% Bring forward
for iFig = 1:numel(figureHandles)
    figure(figureHandles(iFig));
end

end
