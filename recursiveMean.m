function muPlus = recursiveMean(x,n,mu)
% The "recursiveMean" function returns an updated mean "muPlus" given a new
% sample "x", the number of updates "n", and the previous mean "mu".
%
% SYNTAX:
%   muPlus = recursiveMean(x,n,mu)
% 
% INPUTS:
%   x - (number) 
%       New sample.
%
%   n - (1 x 1 positive integer) 
%       Total number of updates, including the new sample "x".
%
%   mu - (number)
%       Previous value for the mean.
% 
% OUTPUTS:
%   muPlus - (number) 
%       New value of the mean.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    recursiveWeightedMean | recursiveVar
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 25-NOV-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(3,3)

% Check input arguments for errors
assert(isnumeric(x) && isreal(x),...
    'recursiveMean:x',...
    'Input argument "x" must be a real number or matrix.')
S = size(x);

assert(isnumeric(n) && isreal(n) && numel(n) == 1 && mod(n,1) == 0 && n >= 1,...
    'recursiveMean:n',...
    'Input argument "n" must be a real positive integer.')

assert(isnumeric(mu) && isreal(mu) && isequal(size(mu),S),...
    'recursiveMean:mu',...
    'Input argument "mu" must be a real number with dimension equal to the sample "x".')

%% Calculate recurisive mean
muPlus = ((n-1)*mu + x) / n;

end
