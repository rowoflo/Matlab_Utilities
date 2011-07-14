function timeInDays = sec2day(timeInSeconds)
% The sec2day function converts time from seconds to days
%
% USAGE:
%   timeInDays = sec2day(timeInSeconds)
%
% INPUTS:
%   timeInSeconds - (number) Time is seconds.
%  
% OUTPUTS:
%   timeInDays - (number) Time in days with diminsions the same size as
%       timeInSeconds.
%
% DESCRIPTION:
%
% EXAMPLES:
%   sec2day(86400)
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   day2sec.m
%
% REVISION:
%   16-Feb-2009 by Rowland O'Flaherty
%       Iniital Revision.
%  
%--------------------------------------------------------------------------

timeInDays = timeInSeconds./86400;

end