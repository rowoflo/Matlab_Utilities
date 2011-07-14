function result = isrealnumber(input,varargin)
% The "isrealnumber" function checks if the input is a real number that
% satisfies the given conditions.
%
% USAGE:
%   result = isrealnumber(input,[checkType],[condition],[sizeOfDim1],[sizeOfDim2],...)
% 
% INPUTS:
%   input - (any)
%       The argument that is being checked. If the input is a cell array
%       each cell will be checked by the conditions. If input or the
%       contents of a cell of the "input" is a matrix each element of that
%       matrix will be checked by the conditions according to the
%       "checkType".
%
%   [checkType] - ('all','any','element') [Default 'all']
%       If 'all' all the elements of the matrix must match the conditions,
%       if 'any' any of the elements of the matrix must match the
%       conditions. If 'element' results for each element are returned, if
%       size does not match a false is returned.
%       
%   [condition] - (1 x 1 string or '') [Default ''] 
%       Checks the input against the given conditions. Condition strings
%       are in standard matlab format with the argument replaced by a '?'.
%       For example: '?>0' would require the input to be greater than zero
%       and '?>=-1 & ?<=1' would require the input to be between -1 and 1.
%       If condition isempty no conditions will be checked against the
%       input.
%
%   [sizeOfDim?] - (1 x 1 semi-positive integer or empty) [Default 1]
%       Checks that the size of dimision ? of the input. If empty
%       nothing for that dimision is checked.
% 
% OUTPUTS:
%   result - (logical) 
%       True if the input is a number and satifies all the conditions and
%       size checks, otherwise false. If "input" is a cell array result
%       will be a cell of array of the same size and each cell will
%       correspond to that cell's results from the corresponding cell in
%       "input".
%
% DESCRIPTION:
%   This functions allows for an easy way to check inputs without writing a
%   huge condition statement.
%
% EXAMPLES:
%     isrealnumber({[1 2],'a';a,[2;1]},'any','?>1',1,[])
%     ans = 
%         [1]    [0]
%         [0]    [0]
%
% NOTES:
%   "checkType" and "condition" arguments can come in any order and are not
%   required arguments, but must be before "sizeOfDim?" arguments, which
%   have to come in order.
%
% NECESSARY FILES:
%
% SEE ALSO:
% issize, isinteger
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

% Check each cell
result = cellfun(@cellLoop,input,'UniformOutput',false);

    function thisOutput = cellLoop(thisInput)
        % Check size
        if ~isempty(sizeInd) && any(sizeInd)
            sizeResult = issize(thisInput,varargin{sizeInd});
        else
            sizeResult = true;
        end
        
        % Check condition
        if isempty(conditionInd)
            condResult = isnumeric(thisInput) && isreal(thisInput);
        else
            if isnumeric(thisInput) && isreal(thisInput)
                condResult = eval(regexprep(varargin{conditionInd},'\?','thisInput'));
            else
                condResult = false;
            end
        end
        
        switch checkType
            case 'all'
                condResult = all(condResult(:));
            case 'any'
                condResult = any(condResult(:));
            case 'element'
                 % condResult = condResult; % This is line is just to make clear what is going on
        end
        
        if sizeResult 
            thisOutput = condResult;
        else
            thisOutput = false;
        end
    end

if ~cellFlag
    result = result{:};
end

end
