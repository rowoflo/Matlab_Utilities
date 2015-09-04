function mat2latex(M,varargin)
% The "mat2latex" function prints to the command window the matrix "M" in a
% form that can be copied and pasted directly into a Latex document.
%
% SYNTAX:
%   mat2latex(M)
% 
% INPUTS:
%   M - (? x ? number) 
%       The matrix to convert to Latex form.
%
% PROPERTIES:
%   'indent' - (string) ['  ']
%       Sets what is used as the indent for the matrix. A valid value is
%       '\t' for tab.
% 
% OUTPUTS: TODO: Add outputs
%   output - (size type) 
%       Description.
%
% EXAMPLES:
%   >> mat2latex(eye(2))
%
%   \begin{bmatrix}  1 & 0 \\
%     0 & 1
%   \end{bmatrix}
%
% NOTES:
%
% NECESSARY FILES:
%
% AUTHOR:
%   12-SEP-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,3)

% Apply default values

% Check input arguments for errors TODO: Add error checks
assert(isnumeric(M),...
    'mat2latex:M',...
    'Input argument "M" must be a ? x ? matrix of numbers.')
 
% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'mat2latex:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('indent')
            indent = propValues{iParam};
        otherwise
            error('mat2latex:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary TODO: Add property defaults
if ~exist('indent','var'), indent = '  '; end

% Check property values for errors TODO: Add property error checks
assert(ischar(indent),...
    'mat2latex:indent',...
    'Property "indent" must be a string')

%% Info on M
[nRows nCols] = size(M);

%% Print M
fprintf(1,'\\begin{bmatrix}');

for iRow = 1:nRows
    fprintf(1,indent);
    for iCol = 1:nCols
        if isint(M(iRow,iCol))
            fprintf(1,'%d',M(iRow,iCol));
        else
            fprintf(1,'%.2f',M(iRow,iCol));
        end
        if iCol ~= nCols
            fprintf(1,' & ');
        else
            if iRow ~= nRows
                fprintf(1,' \\\\');
            end
        end
    end
    fprintf(1,'\n');
end
fprintf(1,'\\end{bmatrix}\n');

end

function output = isint(input)
output = mod(input,1) == 0;
end