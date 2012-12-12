function [muPlus,omegaPlus] = recursiveWeightedMean(x,w,mu,omega)
% The "recursiveWeightedMean" function returns an updated weighted mean "muPlus"
% given a new sample "x", a new weight value "w", the previous weighted mean
% "mu", and the previous total weight "omegaPlus".
%
% SYNTAX:
%   [muPlus,omegaPlus] = recursiveWeightedMean(x,w,mu,omega)
% 
% INPUTS: TODO: Add inputs
%   x - (number) 
%       New sample.
%
%   w - (positive number) 
%       The new weight value for this sample.
%
%   mu - (number)
%       Previous value for the weighted mean.
%
%   omega - (positive number)
%       Previous total sum of all previous weights.
% 
% OUTPUTS:
%   muPlus - (number) 
%       New value of the weighted mean.
%
%   omegaPlus - (1 x 1 positive number)
%       New total sum of weights.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO: TODO: Add see alsos
%    recursiveMean | recursiveVar
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 27-NOV-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(4,4)

% Check input arguments for errors
assert(isnumeric(x) && isreal(x),...
    'recursiveWeightedMean:x',...
    'Input argument "x" must be a real number or matrix.')
S = size(x);

assert(isnumeric(w) && isreal(w) && isequal(size(w),S) && all(w(:) >= 0),...
    'recursiveWeightedMean:w',...
    'Input argument "w" must be a real positive number with dimension equal to the sample "x".')

assert(isnumeric(mu) && isreal(mu) && isequal(size(mu),S),...
    'recursiveWeightedMean:mu',...
    'Input argument "mu" must be a real number with dimension equal to the sample "x".')

assert(isnumeric(omega) && isreal(omega) && isequal(size(omega),S) && all(omega(:) >= 0),...
    'recursiveWeightedMean:omega',...
    'Input argument "omega" must be a real positive number with dimension equal to the sample "x".')

%% Calculated recursive weighted mean
omegaPlus = w + omega;
muPlus = (omega.*mu + w.*x) ./ omegaPlus;

muPlus(isnan(muPlus)) = mu(isnan(muPlus));

end
