function [C,SorI] = minm(A,type)
% The "minm" function finds the smallest element in a matrix.
%
% SYNTAX:
%   C = minm(A)
%   [C,S] = minm(A,type)
%   [C,S] = minm(A,'subscript')
%   [C,I] = minm(A,'index')
% 
% INPUTS:
%   A - (N x M number) 
%       Matrix  to find minimum value.
%
%   type - ('subscript' or 'index') ['subscript'] 
%       Determines if the second return value is the linear index of the
%       minimum value in the matrix or the subscript index of the matrix.
% 
% OUTPUTS:
%   C - (1 x 1 number) 
%       The value of the minimum element in the matrix.
%
%   S - (1 x 2 positive integer)
%       Subscript indices of the minimum element in the matrix.
%
%   I - (1 x 1 positive integer)
%       Linear index of the minimum element in the matrix.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES: TODO: Add necessary files
%   +somePackage, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 15-JAN-2013
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,2)

% Apply default values
if nargin < 2, type = 'subscript'; end

% Check input arguments for errors TODO: Add error checks
assert(isnumeric(A) && isreal(A) && numel(size(A)) == 2,...
    'minm:A',...
    'Input argument "A" must be a M x N matrix of real numbers.')

assert(ischar(type) && (strcmpi(type,'subscript') || strcmpi(type,'index')),...
    'minm:type',...
    'Input argument "type" must be either ''subscript'' or ''index''.');

%% Find minimum of matrix
[minColVals,minColInds] = min(A);
[C,minRowInd] = min(minColVals);
S = [minColInds(minRowInd) minRowInd];

if strcmpi(type,'subscript')
    SorI = S;
else
    SorI = sub2ind(size(A),S(1),S(2));
end

end
