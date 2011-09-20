function mat2Latex(M,varargin)
% The "mat2Latex" function prints to the command window the matrix "M" in a
% form that can be copied and pasted directly into a Latex document.
%
% SYNTAX:
%   mat2Latex(M)
% 
% INPUTS:
%   M - (? x ? number) 
%       The matrix to convert to Latex form.
%
% PROPERTIES: TODO: Add properties
%   'propertiesName' - (size type) [defaultPropertyValue]
%       Description.
% 
% OUTPUTS: TODO: Add outputs
%   output - (size type) 
%       Description.
%
% EXAMPLES:
%   mat2Latex(eye(2))
%
%   \left[ \begin{array}{cc}
%      1 & 0 \\
%      0 & 1 \\
%   \end{array} \right]
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
error(nargchk(1,1,nargin))

% Apply default values

% Check input arguments for errors TODO: Add error checks
assert(isnumeric(M),...
    'mat2Latex:M',...
    'Input argument "M" must be a ? x ? matrix of numbers.')
 
% % Get and check properties
% propargin = size(varargin,2);
% 
% assert(mod(propargin,2) == 0,'mat2Latex:properties',...
%     'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')
% 
% propStrs = varargin(1:2:propargin);
% propValues = varargin(2:2:propargin);
% 
% for iParam = 1:propargin/2
%     switch lower(propStrs{iParam})
%         case lower('propertyName')
%             propertyName = propValues{iParam};
%         otherwise
%             error('mat2Latex:options',...
%               'Option string ''%s'' is not recognized.',propStrs{iParam})
%     end
% end
% 
% % Set to default value if necessary TODO: Add property defaults
% if ~exist('propertyName','var'), propertyName = defaultPropertyValue; end
% 
% % Check property values for errors TODO: Add property error checks
% assert(isnumeric(propertyName) && isreal(propertyName) && isequal(size(propertyName),[1,1]),...
%     'mat2Latex:propertyName',...
%     'Property "propertyName" must be a ? x ? matrix of real numbers.')

%% Info on M
[nRows nCols] = size(M);

%% Print M
fprintf(1,'\\left[ \\begin{array}{');
for iCol = 1:nCols
    fprintf(1,'c');
end
fprintf(1,'}\n');

for iRow = 1:nRows
    fprintf(1,'\t');
    for iCol = 1:nCols
        if isint(M(iRow,iCol))
            fprintf(1,'%d',M(iRow,iCol));
        else
            fprintf(1,'%.2f',M(iRow,iCol));
        end
        if iCol ~= nCols
            fprintf(1,' & ');
        else
            fprintf(1,' \\\\');
        end
    end
    fprintf(1,'\n');
end
fprintf(1,'\\end{array} \\right]\n');

end

function output = isint(input)
output = mod(input,1) == 0;
end