function output = smallToZero(input,tolFactor)
% The "smallToZero" function changes small numbers to zero.
%
% USAGE:
%   output = smallToZero(input,[tolFactor])
%
% INPUTS:
%   input - (number or cell array of numbers)
%       Scalar, array, matrix, or cell array of numbers that will be
%       checked and converted to zero if small enough.
%
%   [tolFactor] - (1 x 1 positive number) [Default 100]
%       Sets the threshold for what is considered a small number. The
%       threshold is anything <= tolFactor*eps.
%
% OUTPUTS:
%   output - (same as input)
%       Input with all small numbers converted to zero.
%
% DESCRIPTION:
%
% EXAMPLES:
%   smallToZero([eps eps*100 eps*100+eps])
%     ans =
%           0    0   2.2427e-14
%
% NOTES:
%
% NECESSARY FILES:
%   isrealnumber.m
%
% SEE ALSO:
%
% REVISION:
%   1.0 03-DEC-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,2,nargin))

% Apply default values
if nargin < 2, tolFactor = 100; end

assert(isrealnumber(tolFactor,'?>0',1),...
    'smallToZero:tolFactorChk',...
    '"tolFactor" must be a 1 x 1 positive real number')

if iscell(input)
    cellFlag = true;
else
    cellFlag = false;
    input = {input};
end

% Loop through each cell
output = cellfun(@cellLoop,input,'UniformOutput',false);

    function thisOutput = cellLoop(thisInput)
        % Check inputs for errors
        assert(isrealnumber(thisInput),'smallToZero:inputChk','"input" must be a real number')
        
        thisOutput = thisInput;
        thisOutput(abs(thisInput) <= tolFactor*eps) = 0;
    end

if ~cellFlag
    output = output{:};
end

end
