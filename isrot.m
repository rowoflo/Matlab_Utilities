function result = isrot(input)
% The "isrot" function checks if the input is a rotation matrix.
%
% USAGE:
%   result = isrot(input)
% 
% INPUTS:
%   input - (any) 
%       Input to check.
% 
% OUTPUTS:
%   result - (1 x 1 logical) 
%       True is the input is a rotation matrix.
%
% DESCRIPTION:
%   A rotation matrix is a matrix that is square, the matrix transpose
%   equals the matrix inverse, and the determinant equals 1.
%
% EXAMPLES:
%
% NOTES:
%   Numbers in "input" that are smaller or equal to 100*eps are rounded to
%   zero.
%
% NECESSARY FILES:
%   smallToZero.m
%
% SEE ALSO:
%    isskew
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
        thisResult = isequal(smallToZero(thisInput*thisInput'),eye(3)) && det(smallToZero(thisInput)) == 1;
    end

if ~cellFlag
    result = result{:};
end

end
