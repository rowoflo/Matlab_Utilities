function windowMat = slidingWindow(signal,windowLength)
% The "slidingWindow" function creates a matrix that is the sliding windows
% of a given length of the signal.
%
% USAGE:
%   windowMat = slidingWindow(signal,windowLength)
% 
% INPUTS:
%   signal - (1 x ? number) 
%       Input signal.
%
%   windowLength - (1 x 1 number)
%       Window length.
% 
% OUTPUTS:
%   windowMat - (? x windowLength number) 
%       Matrix made up of windows of input signal.
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
%
% REVISION:
%   1.0 09-AUG-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(2,2,nargin))

% Check input arguments for errors
assert(isnumeric(signal) && size(signal,1) == 1,...
    'slidingWindow:signalChk',...
    'Input argument "signal" must be a 1 x ? number.')

assert(isnumeric(windowLength) && numel(windowLength) == 1,...
    'slidingWindow:windowLengthChk',...
    'Input argument "windowLength" must be a 1 x 1 number.')

%%
sigLength = length(signal);
nWins = sigLength-windowLength+1;
windowMat = zeros(nWins,windowLength);
for iWin = 1:nWins
    windowMat(iWin,:) = signal(iWin:windowLength+iWin-1);
end

end
