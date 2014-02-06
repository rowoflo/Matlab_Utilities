function muPlus = recursiveMean(x,l,mu)
% The "recursiveMean" function returns an updated mean "muPlus" given a new
% sample "x", the number of previous updates "l", and the previous mean "mu".
%
% SYNTAX:
%   muPlus = recursiveMean(x,l,mu)
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
% OUTPUTS:
%   muPlus - (1 x 1 number or multiple dimension matatrix)
%       New value of the mean.
%
% EXAMPLES:
%     l = 1; % Previoun number of updates
%     mu = 1; % Previous mean;
%     x = [2, 3, 4]; % New samples
%     muPlus = recursiveMean(x,1,mu);
%
%     l = 1; % Previoun number of updates
%     mu = [1;1;1]; % Previous mean;
%     x = [2;3;4]; % One new sample;
%     muPlus = recursiveMean(x,1,mu);
%
% NOTES:
%   If "mu" is a vector it must be a column vector to be treated correctly.
%   Row vectors are treated as 1 x P matrices.
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
assert(isnumeric(mu) && isreal(mu),...
    'recursiveMean:mu',...
    'Input argument "mu" must be a composed of real numbers.')
S = size(mu);

assert(isnumeric(l) && isreal(l) && numel(l) == 1 && mod(l,1) == 0 && l >= 1,...
    'recursiveMean:l',...
    'Input argument "l" must be a real positive integer.')

assert(isnumeric(x) && isreal(x),...
    'recursiveMean:x',...
    'Input argument "x" must be a real number or matrix.')
T = size(x);

if length(S) <= 2
    if S(2) == 1
        assert(T(1) == S(1),...
            'recursiveMean:x',...
            'Input argument "x" first dimesion must be equal to %d.',S(1))
        D = 2;
    elseif S(2) > 1
        assert(isequal(T(1:2),S(1:2)),...
            'recursiveMean:x',...
            'Input argument "x" first and second dimesions must be equal to [%d,%d].',S(1),S(2))
        D = 3;
    end
else
    assert(isequal(T(1:end-1),S),...
        'recursiveMean:x',...
        'Input argument "x" dimesions must be equal to %s.',mat2str(S))
    D = length(S) + 1;
end


%% Calculate recurisive mean
m = size(x,D);
n = l + m;
muPlus = l/n * mu  + m / n * mean(x,D);

end
