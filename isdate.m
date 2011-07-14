function tf = isdate(dateStr,format)
% The isdate function determines if a string is in a valid datestr format.
%
% USAGE:
%   tf = isdate(dateStr,format)
% 
% INPUTS:
%   dateStr - (1 x 1 string) Date string.
%
%   [format] - (1 x 1 string) Date format of dateStr, e.g. 'dd-mmm-yyyy'.
%       See datenum documentation for a list of all format types.
% 
% OUTPUTS:
%   tf - (1 x 1 logical) True if dateStr is a valid date in the
%       correct format.
%
% DESCRIPTION:
%   This function is intended to be used like other is* functions but
%   specifically for dates.
%
% EXAMPLES:
%   tf = isdate('2009-08-11','YYYY-MM-DD')
%
% NOTES:
%   This function doesn't work for formats containing 'mmmm' or 'dddd'.
%
% NECESSARY FILES:
%
% SEE ALSO:
%   datenum, datestr, datevec
%
% REVISION:
%   11-Aug-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(2,2,nargin))

if ~ischar(dateStr)
    error('isdate:dateStrChk','dateStr variable must be a string')
end

if ~ischar(format)
    error('isdate:formatChk1','format variable must be a string')
end

fourLetterMatch = regexp(format,'mmmm|dddd','match');
if ~isempty(fourLetterMatch)
    error('isdate:formatChk2','isdate does not work for formats containing ''mmmm'' or ''dddd''')
end
clear fourLetterMatch

%% Check
tf = true;

strLength = length(format);
if strLength ~= length(dateStr)
    tf = false;
    return
end

letters = {'d','D','m','M','y','Y','h','H','s','S','a','A','p','P','q','Q','t','T','f','F'};
iChar = 1;
while iChar <= strLength
   if ismember({format(iChar)},letters)
       if strcmpi(format(iChar),'a') || strcmpi(format(iChar),'p')
           if iChar == strLength
               tf = false;
               return
           end
           if (~strcmpi(dateStr(iChar),'a') && ~strcmpi(dateStr(iChar),'p')) || ~strcmpi(dateStr(iChar+1),'m')
               tf = false;
               return
           else
               iChar = iChar + 1;
           end
       else
           if isnan(str2double(dateStr(iChar)))
               tf = false;
               return
           end
       end
   else
        if ~strcmp(dateStr(iChar),format(iChar))
            tf = false;
            return
        end
   end
   iChar = iChar + 1;
end

try datenum(dateStr,format);
catch %#ok<CTCH>
    tf = false;
end

end
