function w_hat = logmap(R,epsilon)
% The "logmap" function returns the matrix logarithm of a matrix.
%
% SYNTAX:
%   w_hat = logmap(R)
%   w_hat = logmap(R,epsilon)
% 
% INPUTS:
%   R - (n x n number) 
%       SO(n) matrix.
%
%   epsilon - (1 x 1 number) [1e-6] 
%       All values in the ouput smaller (in an absolute sense) than epsilon
%       will be set equal to 0.
% 
% OUTPUTS:
%   w_hat - (n x n number) 
%       so(n) matrix.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 30-JAN-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,2)

% Apply default values TODO: Add apply defaults
if nargin < 2, epsilon = 1e-6; end

% Check input arguments for errors
assert(isnumeric(R) && size(R,1) == size(R,2),...
    'logmap:R',...
    'Input argument "R" must be a n x n matrix numbers.')

assert(isnumeric(epsilon) && isreal(epsilon) && numel(epsilon) == 1 && epsilon >= 0,...
    'logmap:epsilon',...
    'Input argument "epsilon" must be a non-negative scalar.')

%% Calculate skew-symmetric generator
[V,D] = eig(R);
w_hat = V*diag(log(diag(D)))*V^-1;

%% Roundoff
w_hat_real = real(w_hat);
w_hat_imag = imag(w_hat);

w_hat_real(abs(w_hat_real) < epsilon) = 0;
w_hat_imag(abs(w_hat_imag) < epsilon) = 0;

w_hat = w_hat_real + 1i*w_hat_imag;

end
