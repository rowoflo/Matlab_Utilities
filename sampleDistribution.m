function [sample,index] = sampleDistribution(values,weights)
% The "sampleDistribution" function samples the elements of "values" based
% on a distribution that is proportional to "weights".
%
% SYNTAX:
%   [sample,index] = sampleDistribution(values)
%   [sample,index] = sampleDistribution(values,weights)
%   [sample,index] = sampleDistribution(values,weights,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   values - (number) 
%       The values to be sampled. size(values) = [M,N].
%
%   weights - (M x N semi-positive number) [ones(M,N)] 
%       The weights associated with each element in "values". Must be the
%       same size as "values".
%
% PROPERTIES: TODO: Add properties
%   'propertiesName' - (size type) [defaultPropertyValue]
%       Description.
% 
% OUTPUTS:
%   sample - (1 x 1 number) 
%       A sample element from "values".
%
%   index - (1 x 1 positive integer)
%       Index of the element from "values"
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
%   Created 14-NOV-2012
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(2,2)

% Check input arguments for errors
assert(isnumeric(values),...
    'sampleDistribution:values',...
    'Input argument "values" must be a matrix of numbers.')
valuesSize = size(values);

% Apply default values
if nargin < 2, weights = ones(valuesSize); end

assert(isnumeric(weights) && isreal(weights) && isequal(size(weights),valuesSize) && all(weights(:) >= 0),...
    'sampleDistribution:weights',...
    'Input argument "weights" must be a matrix of semi-positive numbers the same size as the "values": %d x %d.',size(values,1),size(values,2))

% % Get and check properties
% propargin = size(varargin,2);
% 
% assert(mod(propargin,2) == 0,...
%     'sampleDistribution:properties',...
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
%             error('sampleDistribution:options',...
%               'Option string ''%s'' is not recognized.',propStrs{iParam})
%     end
% end
% 
% % Set to default value if necessary TODO: Add property defaults
% if ~exist('propertyName','var'), propertyName = defaultPropertyValue; end
% 
% % Check property values for errors TODO: Add property error checks
% assert(isnumeric(propertyName) && isreal(propertyName) && isequal(size(propertyName),[1,1]),...
%     'sampleDistribution:propertyName',...
%     'Property "propertyName" must be a ? x ? matrix of real numbers.')

%% Sample

values = values(:);
weights = weights(:);
weightsSum = sum(weights);
weightsCum = cumsum(weights);

index = find(weightsCum > weightsSum*rand,1,'first');
sample = values(index);

end
