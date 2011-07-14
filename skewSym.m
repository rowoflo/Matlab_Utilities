function output = skewSym(input)
% The "skewSym" function converts a vector into a skew symmetric matrix or
% converts a skew symmetric matrix into a vector.
%
% USAGE:
%   output = skewSym(input)
%
% INPUTS:
%   input - (3 x 1 number or 3 x 3 number (must be skew symmetric))
%       A vector or skew symetric matrix.
%
% OUTPUTS:
%   output - (3 x 3 number (skew symmetric matrix) or 3 x 1 number)
%       A skew symetric matrix or a vector.
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%   Several conversions can be done at once by packaging
%   the input up into cells.
%
% NECESSARY FILES:
%   isrealnumber.m
%
% SEE ALSO:
%    HGRep, HGRepI, axisAngRep, rotRep
%
% REVISION:
%   1.0 01-DEC-2009 by Rowland O'Flaherty
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
output = cellfun(@cellLoop,input,'UniformOutput',false);

    function thisOutput = cellLoop(thisInput)
        % Check input for errors
        assert(isrealnumber(thisInput,3,1) || isrealnumber(thisInput,3,3),...
            'model:skewSym:inputChk','"input" must be a 3 x 1 real number vector or 3 x 3 real number skew symetric matrix')
        
        if isvector(thisInput) % Convert vector to skew matrix
            v = thisInput;
            thisOutput = [ 0   -v(3)   v(2);...
                          v(3)   0    -v(1);...
                         -v(2)  v(1)    0 ];
        
        else % Convert skew matrix to vector
            s = thisInput;
            
            % Check input to make sure it is skew symmtric matrix
            assert(isskew(s),...
                'model:skewSym:inputChk','"input" must be a 3 x 1 real number vector or 3 x 3 real number skew symetric matrix')
            
            thisOutput = [s(6) s(7) s(2)]';
        end
    end

if ~cellFlag
    output = output{:};
end

end
