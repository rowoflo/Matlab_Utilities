function [outlierInds,outlierVals] = findOutliers(data,multiplierDist)
% The "findOutliers" function returns the indexes of the outliers in the
% "data".
%
% USAGE:
%   [outlierInds,outlierVals] = findOutliers(data,[multiplierDist])
% 
% INPUTS:
%   data - (? x 1 number) 
%       Data set. Vector of numbers.
%
%   multiplierDist - (1 x 1 positive number) [Default 1.5]
%       Number of the inter-quartile ranges outside the 1st and 3rd
%       quartiles which marks the threshold for outliers.
%
% DESCRIPTION:
% This function finds outliers by finding the inter-quartile range (IQR) of
% the data, which is the distance between the 25th percentile and 75th
% percentile of the data. The IQR is multiplied by the "multiplierDist" and
% then subtracted from the 25th percentile and added to the 75th
% percentile. These two numbers set the outlier threshold values for the
% data. Any number outside the threshold values are considered outliers.
%
% EXAMPLES:
% data = [ones(1,10) 10 11];
% [i,v] = findOutliers(data)
% 
% i =
%     11
%     12
% 
% v =
%     10
%     11
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    related_function
%
% REVISION:
%   1.0 02-FEB-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,2,nargin))

% Apply default values
if nargin < 2, multiplierDist = 1.5; end

% Check inputs arguments for errors
assert(isnumeric(data) && isvector(data),...
    'findOutliers:dataChk',...
    'Input argument "data" must be a vector of numbers.')
data = data(:);

assert(isnumeric(multiplierDist) && isreal(multiplierDist) && isequal(size(multiplierDist),[1 1]) && multiplierDist > 0,...
    'findOutliers:multiplierDistChk',...
    'Input argument "multiplierDist" must be a positive real number.')

%% Find thresholds
quartile = prctile(data,[25 50 75]);
IQR = quartile(3) - quartile(1);
cutOff(1) = quartile(1) - multiplierDist*IQR;
cutOff(2) = quartile(3) + multiplierDist*IQR;

%%
outlierLogic = (data < cutOff(1) | data > cutOff(2));
outlierInds = find(outlierLogic);
outlierVals = data(outlierLogic);

end
