function numInBase10 = baseDigitsToBase10Num(digitVector,base)
% The "baseDigitsToBase10Num" function converts the digits of a number in
% base "base" to the equivalent number in base 10.
%
% USAGE:
%   numInBase10 = baseDigitsToBase10Num(digitVector,base)
% 
% INPUTS:
%   digitVector - (? x ? semi-positive integer) 
%       Digits of number in given base to convert to baes 10. The rows are
%       the different numbers and the columns are the different digits. The
%       right most digit is the least significant bit to the the left most
%       digit is the most significant bit.
%
%   base - (1 x 1 positive integer)
%       Base of give digits.
% 
% OUTPUTS:
%   numInBase10 - (? x 1 positive integer) 
%       Base 10 number. Each row corresponds to the rows of "digitVector"
%
% DESCRIPTION:
%
% EXAMPLES:
%   baseDigitsToBase10Num([0 1 1 0],2)
%   ans =
%          6
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    base10NumToNewBaseDigits
%
% REVISION:
%   1.0 11-AUG-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(2,2,nargin))


% Check input arguments for errors
assert(isnumeric(digitVector) && isreal(digitVector) && all(digitVector(:) >= 0) && all(mod(digitVector(:),1) == 0),...
    'baseDigitsToBase10Num:digitVectorChk',...
    'Input argument "digitVector" must be a ? x ? semi-positive real integer.')

assert(isnumeric(base) && isreal(base) && isequal(size(base),[1 1]) && base > 0 && mod(base,1) == 0,...
    'baseDigitsToBase10Num:baseChk',...
    'Input argument "base" must be a 1 x 1 positive real integer.')

%%
nNums = size(digitVector,1);
nDigits = size(digitVector,2);
numInBase10 = sum(digitVector .* repmat(base .^ ((nDigits:-1:1) - 1),nNums,1),2);

end
