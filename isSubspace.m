function isSubset = isSubspace(A,B,varargin)
% The "isSubspace" function is used to check if one subspace is a
% subspace of another subspace.
%
% SYNTAX:
%   output = isSubspace(A,B)
%   output = isSubspace(A,B,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   A - (? x ? real number) 
%       Span of vectors in for set "A".
%
%   B - (? x ? real number)
%       Span of vectors in for set "B".
%
% PROPERTIES:
%   'epsilon' - (1 x 1 postive number) [0]
%       Sets zero size. Useful for when there is a numerical imprecision
%       and numbers that should be zero are not but are close.
% 
% OUTPUTS:
%   isSubset - (1 x 1 logical) 
%       True if A is a subset of B.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES: TODO: Add necessary files
%   +package_name, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 15-SEP-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(2,4)

% Apply default values
% if nargin < 2, input2 = defaultInputValue; end

% Check input arguments for errors TODO: Add error checks
assert(isnumeric(A) && isreal(A) && size(size(A),2) == 2,...
    'isSubspace:A',...
    'Input argument "A" must be a 2-dim matrix of real numbers.')

assert(isnumeric(B) && isreal(B) && size(size(B),2),...
    'isSubspace:B',...
    'Input argument "B" must be a 2-dim matrix of real numbers.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,...
    'isSubspace:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('epsilon')
            epsilon = propValues{iParam};
        otherwise
            error('isSubspace:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('epsilon','var'), epsilon = 0; end

% Check property values for errors
assert(isnumeric(epsilon) && isreal(epsilon) && isequal(size(epsilon),[1,1]) && epsilon >= 0,...
    'isSubspace:epsilon',...
    'Property "epsilon" must be a number >= 0.')

%% Preprocess
A = A(:,~all(A == 0,1)); % Remove columns of entire zeros
B = B(:,~all(B == 0,1)); % Remove columns of entire zeros

%% Check
X = B \ A;

isSubset = all(all(abs(A - B*X) <= epsilon));

% isSubset = all(...
%     any(abs(X) > epsilon & ~isnan(X) & abs(X) ~= inf,1) & ...
%     ~all(abs(X) <= epsilon,1)...
%     ,2);

end
