function h = dockFig(varargin)
%--------------------------------------------------------------------------
% The dockFig function is the same as the figure() function but it will
% automatically dock the figure.
%
% USAGE:
%   varargout = dockFig(varargin)
% 
% INPUTS:
%   varargin - Same inputs as figure() function.
%
% OUTPUTS:
%   [h] - (1 x 1 handle) Handle to the figure object.
%
% DESCRIPTION:
%
% EXAMPLES:
%   dockFig(1)
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   figure
%
% REVISION:
%   12-Jun-2009 by Rowland O'Flaherty
%       Iniital Revision.
%
%--------------------------------------------------------------------------

figH = figure(varargin{:});
set(gcf,'WindowStyle','Docked')

if nargout == 1
    h = figH;
end

end
