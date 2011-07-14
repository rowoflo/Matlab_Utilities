function z = nanXCorr(x,varargin)
% The "nanXCorr" function outputs the cross-correlation between inputs that
% contain NaNs in them.
%
% USAGE:
%   z = nanXCorr(x,[y],[optionStr1,optionVal1])
% 
% INPUTS:
%   x - (1 x ? number) 
%       Input 1.
%
%   [y] - (1 x ? number) [Default x] 
%       Input 2. If not provided performs the auto-correlation on input 1.
%
% OPTIONS LIST:
%   'normalize' - (1 x 1 logical) [Default false]
%       If true normalizes the sequence so the correlations at zero lag is
%       equal to 1.
% 
% OUTPUTS:
%   z - (1 x ? number) 
%       Output with NaNs.
%
% DESCRIPTION:
%   This function produces the same results as "xcorr" except it allows the
%   inputs to have NaNs. A NaN in the input is treated like a zero, except
%   an all NaN shift is outputed as a NaN not a zero.
%
%   This function is not written efficiently.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   nanMovingAvgFilt.m
%
% REVISION:
%   1.0 18-AUG-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,4,nargin))

% Apply default values
if isempty(varargin)
    y = x;
else
    if ischar(varargin{1})
        y = x;
    else
        y = varargin{1};
        varargin = varargin(2:end);
    end
end

% Check input arguments for errors
assert(isnumeric(x) && isreal(x) && size(x,1) == 1,...
    'nanXCorr:xChk',...
    'Input argument "x" must be a 1 x ? real number.')

assert(isnumeric(y) && isreal(y) && size(y,1) == 1,...
    'nanXCorr:yChk',...
    'Input argument "y" must be a 1 x ? real number.')

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'nanMovingAvgFilt:optionsChk1','Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('normalize')
            normalize = optValues{iParam};
        otherwise
            error('nanMovingAvgFilt:optionsChk2','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('normalize','var'), normalize = false; end

% Check optional arguments for errors
assert(islogical(normalize) && isequal(size(normalize),[1,1]),...
    'nanMovingAvgFilt:normalizeChk',...
    'Optional argument "normalize" must be a 1 x 1 logical.')

%% Run

% Get lengths
xLen = length(x);
yLen = length(y);
nShifts = xLen + yLen - 1;

% Pad signals with NaNs
xPad = [nan(1,yLen-1) x nan(1,yLen-1)];
yPad = [nan(1,xLen-1) y nan(1,xLen-1)];

% Preallocate z
z = zeros(1,nShifts);
% Loop through all shifts
for iShift = 1:nShifts
    % Multiply indexes that line up
    tmp = xPad .* circshift(yPad,[1 (-yLen + iShift)]);
    
    % Check if all are NaN, if so set to Nan for this shift
    if all(isnan(tmp))
        z(1,iShift) = NaN;
    else
        % Set NaNs to zero for sum
        tmp(isnan(tmp)) = 0;
        % Sum for given shift
        z(1,iShift) = sum(tmp);
    end
end

% Normalize if necessary
if normalize
    z = z / z(yLen);
end

end
