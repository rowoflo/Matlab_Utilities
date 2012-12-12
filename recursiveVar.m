function sigma2Plus = recursiveVar(x,n,mu,sigma2)
% The "recursiveVar" function return as updated variance "sigma2Plus" given
% a new sample "x", the number of updates "n", previous mean "mu", and
% previous variance "sigma2".
%
% SYNTAX:
%   sigma2Plus = recursiveVar(x,n,mu,sigma2)
% 
% INPUTS:
%   x - (number) 
%       New sample.
%
%   n - (1 x 1 integer >= 2) 
%       Total number of updates, including the new sample "x".
%
%   mu - (number)
%       Previous value of the mean.
%
%   sigma2 - (number)
%       Previous value of the variance.
% 
% OUTPUTS:
%   sigma2Plus - (number) 
%       New value of the variance.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%   recursiveMean.m
%
% SEE ALSO:
%    recursiveMean
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 25-NOV-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(4,4)

% Check input arguments for errors
assert(isnumeric(x) && isreal(x),...
    'recursiveVar:x',...
    'Input argument "x" must be a real number or matrix.')
S = size(x);

assert(isnumeric(n) && isreal(n) && numel(n) == 1 && mod(n,1) == 0 && n >= 2,...
    'recursiveVar:n',...
    'Input argument "n" must be a real integer >= 2.')

assert(isnumeric(mu) && isreal(mu) && isequal(size(mu),S),...
    'recursiveVar:mu',...
    'Input argument "mu" must be a real number with dimension equal to the sample "x".')

assert(isnumeric(sigma2) && isreal(sigma2) && isequal(size(sigma2),S),...
    'recursiveVar:sigma2',...
    'Input argument "sigma2" must be a real number with dimension equal to the sample "x".')


%% Calculate recurisive variance
muPlus = recursiveMean(x,n,mu);
sigma2Plus = (1 - 1/(n-1))*sigma2 + n*(muPlus - mu)^2;

end
