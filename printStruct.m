function printStruct(aStruct,varargin)
% The "printStruct" function recursively prints all the field names and sub
% field names from the given variable.
%
% USAGE:
%   printStruct(aStruct,[optionStr1,optionVal1])
% 
% INPUTS:
%   aStruct - (stucture) 
%       The structure variable to print.
%
% OPTIONS LIST:
%   'printIDs' - (? x ? x ... file identifier) [1]
%       File ID for where the text will be printed to. See "printTo"
%       function.
%
%   'verbose' - (1, 2, or 3) [1]
%       Level 1 only prints structure field names. Level 2 adds field
%       size and type. Level 3 addes field values. 
%
%   'depth' - (1 x 1 positive integer) [1]
%       Current depth of stucture print.
% 
% OUTPUTS:
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%   printTo.m, cell2str.m
%
% SEE ALSO:
%   printTo
%
% REVISION:
%   1.0 04-NOV-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check input arguments for errors
assert(isstruct(aStruct),...
    'printStruct:aStruct',...
    'Input argument "aStruct" must be a structure.')

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'printStruct:options','Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('printIDs')
            printIDs = optValues{iParam};
        case lower('verbose')
            verbose = optValues{iParam};
        case lower('depth')
            depth = optValues{iParam};
        otherwise
            error('printStruct:options','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('printIDs','var'), printIDs = 1; end
if ~exist('verbose','var'), verbose = 1; end
if ~exist('depth','var'), depth = 1; end

% Check optional arguments for errors
verboseLevels = [1 2 3];
assert(isnumeric(verbose) && isreal(verbose) && isequal(size(verbose),[1,1]) && ismember(verbose,verboseLevels),...
    'printStruct:verbose',...
    'Optional argument "verbose" must be 1, 2, or 3.');

assert(isnumeric(depth) && isreal(depth) && isequal(size(depth),[1,1]) && depth > 0 && mod(depth,1) == 0,...
    'printStruct:depth',...
    'Optional argument "depth" must be a 1 x 1 positive integer.')

%% Get field names
fieldNames = fields(aStruct);
nFields = length(fieldNames);

%% Print field names
for iField = 1:nFields
    % Check type
    fieldVar = aStruct.(fieldNames{iField});
    
    % Print depth
    for iD = 1:depth
        printTo(printIDs,' -');
    end
    printTo(printIDs,' %s',fieldNames{iField});
    
    if verbose < 2
        printTo(printIDs,'\n');
    else
        printTo(printIDs,' - %s  %s',strrep(num2str(size(fieldVar)),'  ','x'),class(fieldVar));
        if verbose < 3
            printTo(printIDs,'\n');
        else
            if ischar(fieldVar)
                printTo(printIDs,' - ''%s''\n',aStruct.(fieldNames{iField}));
            elseif isnumeric(fieldVar)
                if numel(fieldVar) == 1
                    printTo(printIDs,' - %s\n',num2str(aStruct.(fieldNames{iField})));
                elseif isvector(fieldVar)
                    printTo(printIDs,' - [%s]\n',num2str(aStruct.(fieldNames{iField})));
                end
            elseif iscellstr(fieldVar)
                printTo(printIDs,' - {%s}\n',cell2str(aStruct.(fieldNames{iField})));
            else
                printTo(printIDs,'\n');
            end
        end
    end
    
    % Recursive call
    if isstruct(fieldVar)
        printStruct(fieldVar,'printIDs',printIDs,'verbose',verbose,'depth',depth+1);
    end
end

end
