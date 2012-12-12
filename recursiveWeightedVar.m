function sigma2Plus = recursiveWeightedVar(x,n,w,mu,omega,sigma2)
% The "recursiveWeightedVar" function return an updated weighted variance
% "sigma2Plus" given a new sample "x", a new weight value "w", previous
% mean "mu", the previous total wieght "omegaPlus", and previous variance
% "sigma2".
%
% SYNTAX:
%   sigma2Plus = recursiveWeightedVar(x,n,w,mu,omega,sigma2)
% 
% INPUTS:
%   x - (number) 
%       New sample.
%
%   n - (1 x 1 positive integer >= 2) 
%       Total number of updates, including the new sample "x".
%
%   w - (positive number) 
%       The new weight value for this sample.
%
%   mu - (number)
%       Previous value of the mean.
%
%   omega - (positive number)
%       Previous total sum of all previous weights.
%
%   sigma2 - (positive number)
%       Previous value for the variance.
% 
% OUTPUTS:
%   sigma2Plus - (number) 
%       New value of the weighted variance.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%   recursiveWeightedMean.m
%
% SEE ALSO:
%    recursiveMean | recursiveWeightedMean | recursiveVar
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 25-NOV-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(6,6)

% Check input arguments for errors
assert(isnumeric(x) && isreal(x),...
    'recursiveWeightedVar:x',...
    'Input argument "x" must be a real number or matrix.')
S = size(x);

assert(isnumeric(n) && isreal(n) && numel(n) == 1 && mod(n,1) == 0 && n >= 2,...
    'recursiveWeightedVar:n',...
    'Input argument "n" must be a real integer >= 2.')

assert(isnumeric(w) && isreal(w) && isequal(size(w),S) && all(w(:) >= 0),...
    'recursiveWeightedVar:w',...
    'Input argument "w" must be a real positive number with dimension equal to the sample "x".')

assert(isnumeric(mu) && isreal(mu) && isequal(size(mu),S),...
    'recursiveWeightedVar:mu',...
    'Input argument "mu" must be a real number with dimension equal to the sample "x".')

assert(isnumeric(omega) && isreal(omega) && isequal(size(omega),S) && all(omega(:) >= 0),...
    'recursiveWeightedVar:omega',...
    'Input argument "omega" must be a real positive number with dimension equal to the sample "x".')

assert(isnumeric(sigma2) && isreal(sigma2) && isequal(size(sigma2),S) && all(sigma2(:) >= 0),...
    'recursiveWeightedVar:sigma2',...
    'Input argument "sigma2" must be a real positive number with dimension equal to the sample "x".')


%% Calculate recurisive variance
[muPlus,omegaPlus] = recursiveWeightedMean(x,w,mu,omega);

if n == 2
    sigma2 = zeros(size(sigma2));
end
e1 = w.*(x - mu).^2+(omega.*(1 - 1/(n-1))).*sigma2;
e2 = (mu - muPlus).*(w.*(x - mu));
e3 = (mu - muPlus).^2.*omegaPlus;
sigma2Plus = 1./(omegaPlus.*(1 - 1/n)) .* (e1+2*e2+e3);

sigma2Plus(isnan(sigma2Plus)) = sigma2(isnan(sigma2Plus));

end
