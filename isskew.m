function result = isskew(input)
% The "isskew" function checks if the input is a skew matrix.
%
% USAGE:
%   result = isskew(input)
% 
% INPUTS:
%   input - (any) 
%       Input to check.
% 
% OUTPUTS:
%   result - (1 x 1 logical) 
%       True is the input is a skew matrix.
%
% DESCRIPTION:
%   A skew matrix is a matrix that is square, the diagonal elements are all
%   zero, and the matrix is equal to the negative transpose of itself.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    isrot
%
% REVISION:
%   1.0 03-DEC-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,1,nargin))

% Convert to cell
if iscell(input)
    cellFlag = true;
else
    cellFlag = false;
    input = {input};
end

% Loop through each cell
result = cellfun(@cellLoop,input,'UniformOutput',false);

    function thisResult = cellLoop(thisInput)
        % Check skew conditions
        thisResult = isequal(thisInput,-thisInput') && all(diag(thisInput) == 0);
    end

if ~cellFlag
    result = result{:};
end

end
