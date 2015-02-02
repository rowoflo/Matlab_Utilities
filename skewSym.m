function skewMat = skewsym(vec)
% The "skew" function production a skew-symmetric matrix from a vector of
% values. If "vec" if of length 3 this function outputs the matrix cross
% product operator, for any other size vector (length "n") it outputs some
% element in so(n).
%
% SYNTAX:
%   skewMat = skew(vec)
% 
% INPUTS:
%   vec - (l x 1 number) 
%       Input vector
%
% OUTPUTS:
%   skewMat - (n x n number) 
%       Skew symmetric matrix (i.e element of so(n)).
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
%   Created 29-JAN-2015
%-------------------------------------------------------------------------------

%% Check Inputs
% Check number of inputs
narginchk(1,1)

% Check input arguments for errors
assert(isnumeric(vec) && isreal(vec) && isvector(vec),...
    'skew:vec',...
    'Input argument "vec" must be a vector of real numbers.')
vec = vec(:)/norm(vec);
l = length(vec);
n = 1/2+sqrt(1/4 + 2*l);
assert(mod(n,1) == 0,...
    'skew:vec',...
    'Input argument "vec" must be of a valid length to make a skew-symmetric matrix')


%% Calculate skew-symmetric matrix
skewMat = zeros(n);
cnt = 0;
for j = 1:n
    for i = 1:n
        if j >= i
            continue
        end
        cnt = cnt + 1;
        skewMat(i,j) = (-1)^(cnt+1)*vec(end-cnt+1);
        skewMat(j,i) = (-1)^(cnt)*vec(end-cnt+1);
    end
end

end
