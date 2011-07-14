function y = nanMovingAvgFilt(x,len,varargin)
% The "nanMovingAvgFilt" function outputs the non-causal moving average of
% an input that contains NaNs in it.
%
% USAGE:
%   y = nanMovingAvgFilt(x,len,[optionStr1,optionVal1])
% 
% INPUTS:
%   x - (1 x ? number) 
%       Input signal with NaNs.
%
%   len - (1 x 1 positive odd integer)
%       Length of the moving average window.
%
% OPTIONS LIST:
%   'interpolate' - (1 x 1 logical) [Default false]
%       A true value will output interpolated values for NaN locations.
% 
% OUTPUTS:
%   y - (1 x ? number) 
%       Filtered output.
%
% DESCRIPTION:
%   This function does a moving average of the input signal with a given
%   window size. NaNs in the input signal are ignored but temporal
%   information is maintained.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
%
% SEE ALSO:
%    nanXCorr.m
%
% REVISION:
%   1.0 18-AUG-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(2,4,nargin))

% Check input arguments for errors
assert(isnumeric(x) && isreal(x) && size(x,1) == 1,...
    'nanMovingAvgFilt:xChk',...
    'Input argument "x" must be a 1 x ? real number.')

assert(isnumeric(len) && isreal(len) && isequal(size(len),[1,1]) && mod(len,1) == 0 && len > 0 && mod(len,2) == 1,...
    'nanMovingAvgFilt:lenChk',...
    'Input argument "len" must be a 1 x 1 positve odd integer.')

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'nanMovingAvgFilt:optionsChk1','Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('interpolate')
            interpolate = optValues{iParam};
        otherwise
            error('nanMovingAvgFilt:optionsChk2','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('interpolate','var'), interpolate = false; end

% Check optional arguments for errors
assert(islogical(interpolate) && isequal(size(interpolate),[1,1]),...
    'nanMovingAvgFilt:interpolateChk',...
    'Optional argument "interpolate" must be a 1 x 1 logical.')

%% Run

% Pad x with NaNs
xPadNan = [nan(1,floor(len/2)),x,nan(1,floor(len/2))];

% Matrix of shifted x's in each row
xMat = repmat(xPadNan,len,1);
for iLen = 1:len
    xMat(iLen,:) = circshift(xPadNan,[1 -iLen+1]);
end

% Replace NaNs with zeros
xMatNoNan = xMat;
xMatNoNan(isnan(xMat)) = 0;

% Count NaNs in each column
nNan = sum(isnan(xMat),1);

% Mark columns that are all NaNs
isNanLogi = nNan == len;

% Sum and average columns that are not all NaNs
% All NaN columns are set to NaN
y = nan(1,length(xPadNan));
y(~isNanLogi) = sum(xMatNoNan(:,~isNanLogi),1) ./ (len - nNan(~isNanLogi));

% Crop to correct length
y = y(1:length(x));
if ~interpolate
    % Only output locations that are not NaN in input
    y(isnan(x)) = nan;
end

end
