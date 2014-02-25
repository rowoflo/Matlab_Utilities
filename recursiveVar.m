function [sigma2Plus,n] = recursiveVar(x,l,mu,sigma2,muPlus)
% The "recursiveVar" function return as updated variance "sigma2Plus" given
% a new sample "x", the number of previous updates "l", previous mean "mu", and
% previous variance "sigma2".
%
% SYNTAX:
%   [sigma2Plus,n] = recursiveVar(x,l,mu,sigma2)
%   [sigma2Plus,n] = recursiveVar(x,l,mu,sigma2,muPlus)
% 
% INPUTS:
%   x - (vector) 
%       New samples. If "mu" is a multi-dimensional, and "x" has multiple
%       samples the multiple samples must come in the next dimension.
%
%   l - (1 x 1 positive integer) 
%       Total number of previous updates, does not include the new samples "x".
%
%   mu - (1 x 1 number or multiple dimension matatrix)
%       Previous value for the mean.
%
%   sigma2 - (1 x 1 number or multiple dimension matatrix)
%       Previous value of the variance.
%
%   muPlus - (1 x 1 number or multiple dimension matatrix) [recursiveMean(x,l,mu)]
%       New value of the mean if it has already been calculated, other new
%       value will be calculated.
% 
% OUTPUTS:
%   sigma2Plus - (1 x 1 number or multiple dimension matatrix)
%       New value of the variance.
%
%   n - (1 x 1 positive integer)
%       Total number of updates.
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
narginchk(4,5)

% Check input arguments for errors
assert(isnumeric(mu) && isreal(mu),...
    'recursiveVar:mu',...
    'Input argument "mu" must be a composed of real numbers.')
S = size(mu);

assert(isnumeric(l) && isreal(l) && numel(l) == 1 && mod(l,1) == 0 && l >= 0,...
    'recursiveVar:l',...
    'Input argument "l" must be a real positive integer.')

assert(isnumeric(x) && isreal(x),...
    'recursiveVar:x',...
    'Input argument "x" must be a real number or matrix.')
T = size(x);

if length(S) <= 2
    if S(2) == 1
        assert(T(1) == S(1),...
            'recursiveVar:x',...
            'Input argument "x" first dimesion must be equal to %d.',S(1))
        D = 2;
    elseif S(2) > 1
        assert(isequal(T(1:2),S(1:2)),...
            'recursiveVar:x',...
            'Input argument "x" first and second dimesions must be equal to [%d,%d].',S(1),S(2))
        D = 3;
    end
else
    assert(isequal(T(1:end-1),S),...
        'recursiveVar:x',...
        'Input argument "x" dimesions must be equal to %s.',mat2str(S))
    D = length(S) + 1;
end

assert(isnumeric(sigma2) && isreal(sigma2) && isequal(size(sigma2), S),...
    'recursiveVar:x',...
    'Input argument "x" must be a real number or matrix of dimension %s.',mat2str(S))

% Apply default values
if nargin < 5, muPlus = recursiveMean(x,l,mu); end

%% Calculate recurisive variance
m = size(x,D);
n = l + m;

sigma2Plus = 1/(n-1) * ((l-1)*sigma2 + (m-1)*var(x,0,D) + l*(mu - muPlus).^2 + m*(mean(x,D) - muPlus).^2);

end
