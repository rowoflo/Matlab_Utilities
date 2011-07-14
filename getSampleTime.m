function Ts = getSampleTime(timeData)
% The getSampleTime function gets the approximate sampling time from the a time
% data vector.
%
% USAGE:
%   Ts = getSampleTime(timeData)
% 
% INPUTS:
%   timeData - (vector number) Vector of time data.
% 
% OUTPUTS:
%   Ts - (1 x 1 number) Sampling time.
%
% DESCRIPTION:
%   Finds the median difference between time samples in the timeData
%   vector.
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
%   16-Feb-2009 by Rowland O'Flaherty
%       Iniital Revision.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(1,1,nargin))

if ~isnumeric(timeData) || ~isvector(timeData)
    error('getSampleTime:timeDataChk','timeData variable must be numeric vector')
end

shiftedData = circshift(timeData,1);
offSet = timeData - shiftedData;
Ts = median(offSet(2:end));

end
