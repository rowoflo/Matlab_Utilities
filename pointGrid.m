function Y = pointGrid(X)
% The "pointGrid" function creates a grid of points based on the rows in
% the input "X".  Every combination of points in the vectors make
% one point in the output grid.
%
% SYNTAX:
%   Y = pointGrid(X)
% 
% INPUTS:
%   X - (n x m) 
%       The rows of the matrix are the vectors used for the points in the
%       grid.
%
%   X - (n x 1 cells of vectors with lengths m1, m2, ..., mn)
%       If the rows are of different lengths they must be stored in an
%       array of cells.
% 
% OUTPUTS:
%   Y - (n x m^n) or (n x (m1 x m2 x ... x mn))
%       n-dim points in the grid.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    meshgrid
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 11-APR-2014
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,1)

% Check input arguments for errors
assert(length(size(X)) == 2 || ...
    (iscell(X) && all(cellfun(@isvector,X))),...
    'pointGrid:X',...
    'Input argument "X" must be a 2 dimensional matrix or a cell array of vectors.')

if ~iscell(X)
    X = mat2cell(X,ones(1,size(X,1)),size(X,2));
end

%% Create grid
m = cellfun(@length,X);
n = length(m);

Y = nan(n,prod(m));
for i = 1:n
    Yrow = repmat(X{i},prod(m(1:i-1)),prod(m(i+1:end)));
    Y(i,:) = Yrow(:)';
end

end
