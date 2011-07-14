function timeInSeconds = day2sec(timeInDays)
% The day2sec function converts time from days to seconds
%
% USAGE:
%   timeInSeconds = day2sec(timeInDays)
%
% INPUTS:
%   timeInDays - (number) Time in days.
%  
% OUTPUTS:
%   timeInSeconds - (number) Time is seconds with diminsions the same size as
%       timeInDays.
%
% DESCRIPTION:
%
% EXAMPLES:
%   sec2day(1/86400)
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   sec2day.m
%
% REVISION:
%   16-Feb-2009 by Rowland O'Flaherty
%       Iniital Revision.
%  
%--------------------------------------------------------------------------

timeInSeconds = timeInDays.*86400;

end