function result = isrealinteger(input,varargin)
% The "isrealinteger" function checks if the input is a integer number that
% satisfies the given conditions..
%
% USAGE:
%   result = isrealinteger(input,[checkType],[condition],[sizeOfDim1],[sizeOfDim2],...)
%
% INPUTS:
%   SEE DOCUMENTATION FOR isrealnumber
%
% OUTPUTS:
%   SEE DOCUMENTATION FOR isrealnumber
%
% DESCRIPTION:
%   This function calls the isrealnumber function then also checks that
%   input is an integer.
%
% EXAMPLES:
%   isrealinteger({3.4,3,2},'?>2')
%
% NOTES:
%
% NECESSARY FILES:
%   isrealnumber.m
%
% SEE ALSO:
%   issize, isrealnumber
%
% REVISION:
%   1.0 28-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of arguments
error(nargchk(1,inf,nargin))

% Get number of optional arguments
noptargin = size(varargin,2);

% Get size arguments
sizeInd = cellfun(@(optarg) (isnumeric(optarg) && isreal(optarg) && issize(optarg,1) && mod(optarg,1)==0 && optarg>=0) || (isempty(optarg) && ~ischar(optarg)),varargin);

% Get checkType and condition arguments
checkTypeList = {'all','any','element'};
charInd = find(cellfun(@ischar,varargin));
memberInd = ismember(varargin(charInd),checkTypeList);
checkTypeInd = charInd(memberInd);
conditionInd = charInd(~memberInd);

assert(length(checkTypeInd) <= 1 && length(conditionInd) <= 1 && sum(sizeInd) + length(checkTypeInd) + length(conditionInd) == noptargin,...
    'isrealnumber:optarginChk','Invalid input argument')

% Apply default values if necessary
if isempty(checkTypeInd)
    checkType = 'all';
else
    checkType = varargin{checkTypeInd};
end

% Convert to cell
if iscell(input)
    cellFlag = true;
else
    cellFlag = false;
    input = {input};
end

% Check if input is a real number
numResult = isrealnumber(input,varargin{conditionInd},varargin{sizeInd},'element');

% Loop through each cell
result = cellfun(@cellLoop,input,numResult,'UniformOutput',false);

    function thisResult = cellLoop(thisInput,thisNumResult)
        switch checkType
            case 'all'
                thisResult = all(thisNumResult & mod(thisInput,1) == 0);
            case 'any'
                thisResult = any(thisNumResult & mod(thisInput,1) == 0);
            case 'element'
                thisResult = thisNumResult & mod(thisInput,1) == 0;
        end
    end

if ~cellFlag
    result = result{:};
end

end
