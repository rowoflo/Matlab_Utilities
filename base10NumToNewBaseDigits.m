function digitVector = base10NumToNewBaseDigits(numInBase10,newBase,minDigits)
% The "base10NumToNewBaseDigits" function converts a number in base 10 to
% the digits of another base's number.
%
% USAGE:
%   digitVector = base10NumToNewBaseDigits(numInBase10,newBase,[minDigits])
% 
% INPUTS:
%   numInBase10 - (? x 1 semi-positive integer) 
%       Base 10 number.
%
%   newBase - (1 x 1 positive integer)
%       New base.
%
%   [minDigits] - (1 x 1 positive integer) [Default 1]
%       Sets the minimun number of digits to output.
% 
% OUTPUTS:
%   digitVector - (? x ? postive integer) 
%       Digits of input "numInBase10" represented in a new base "newBase".
%       The rows correspond to the rows of "numInBase10" and the columns
%       are the digits.
%
% DESCRIPTION:
%
% EXAMPLES:
%     base10NumToNewBaseDigits(6,2,4)
%     ans =
%          0     1     1     0
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    baseDigitsToBase10Num
%
% REVISION:
%   1.0 11-AUG-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(2,3,nargin))

% Apply default values
if nargin < 3, minDigits = 1; end

% Check input arguments for errors
assert(isnumeric(numInBase10) && isreal(numInBase10) && isequal(size(numInBase10,2),1) && all(numInBase10 >= 0) && all(mod(numInBase10,1) == 0),...
    'base10NumToNewBaseDigits:numInBase10Chk',...
    'Input argument "numInBase10" must be a ? x 1 semi-positive real integer.')

assert(isnumeric(newBase) && isreal(newBase) && isequal(size(newBase),[1 1]) && newBase > 0 && mod(newBase,1) == 0,...
    'base10NumToNewBaseDigits:newBaseChk',...
    'Input argument "newBase" must be a 1 x 1 positive real integer.')

assert(isnumeric(minDigits) && isreal(minDigits) && isequal(size(minDigits),[1 1]) && minDigits > 0 && mod(minDigits,1) == 0,...
    'base10NumToNewBaseDigits:minDigitsChk',...
    'Input argument "minDigits" must be a 1 x 1 positive real integer.')

%%
nNums = size(numInBase10,1);
nDigits = max(minDigits,floor(log(max(numInBase10))/log(newBase))+1);
digitVector = zeros(nNums,nDigits);
for iNum = 1:nNums
    for iDigit = 1:nDigits
        digitVector(iNum,iDigit) = floor(numInBase10(iNum)/newBase^(nDigits-iDigit));
        numInBase10(iNum) = numInBase10(iNum) - (newBase^(nDigits-iDigit))*floor(numInBase10(iNum)/newBase^(nDigits-iDigit));
    end
end


end
