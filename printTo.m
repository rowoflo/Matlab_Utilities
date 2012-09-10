function count = printTo(fids,format,varargin)
% The "printTo" function works similar to fprintf but can print to multiple
% files.
%
% USAGE:
%   count = printTo(fids,format,[A],...)
% 
% INPUTS:
%   fids - (? x ? x ... file identifier) 
%       An array of file of identifier associated with files that will be
%       written to. Use a fid=1 for standard output, fid=2 for standard
%       error, and fid=0 to not print anything. Logicals are also accepted
%       as a valid fid, true=1 and false=0;
%
%   format - (1 x 1 string)
%       String formatting command, see Formatting Strings in the MATLAB
%       Programming Fundamentals documentation.
%
%   [A] - (1 x 1 any)
%       Data used in the format string.
% 
% OUTPUTS:
%   count - (? x ? x ... number) 
%       Array the same size as fids with number of bytes written to each
%       file.
%
% DESCRIPTION:
%   This function acts in exactly the same way as fprintf except that it
%   can print to multiple files at one time, or not print anything at all.
%
% EXAMPLES:
%   printTo([-1 0 1 2],'Hello %s!\n','world')
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   fprintf
%
% REVISION:
%   09-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%   19-MAY-2010 by Rowland O'Flaherty
%       Delete output if there is no output argument.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(2,inf,nargin))

assert(iscell(fids) || isnumeric(fids) || islogical(fids),'printTo:fidsChk','Invalid array of file identifiers.')

if ~iscell(fids)
    fids = mat2cell(fids,1,ones(numel(fids),1));
end

count = nan(size(fids));

for ifid = 1:numel(fids)
    % Convert logicals to 0 and 1
    if islogical(fids{ifid})
        if fids{ifid}
            afid = 1;
        else
            afid = 0;
        end
    else
        afid = fids{ifid};
    end
    
    % Check if fid is 0 and skip if so
    if afid == 0, continue, end
    try
        if ~strcmp(class(afid), 'serial')
            count(ifid) = fprintf(afid,format,varargin{:});
            
            % Throw an error if the file doesn't not have write permissions
            assert(count(ifid) ~= 0 || isempty(format),'printTo:countChk','Unable to write to file with fid=%d. Be sure to open file with ''write'' permissions.',afid);
        else
            fprintf(afid,format,varargin{:});
        end

    catch ME % Catch errors so other files still get written to even if one file throws an error
        fprintf(2,'??? Error using fid=%d\n',afid);
        fprintf(2,'%s\n\n',ME.message);
        for ierr = 1:length(ME.stack)
            fprintf(2,'Error in ==> %s at %d\n\n',ME.stack(ierr).file,ME.stack(ierr).line);
        end
    end
end

if nargout == 0
    clear count
end

end
