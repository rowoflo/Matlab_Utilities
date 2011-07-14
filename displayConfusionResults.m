function displayConfusionResults(confusionMat,varargin)
%--------------------------------------------------------------------------
% The displayConfusionResults function nicely displays the contents of the
% confusion matrix to standard out.
%
% USAGE:
%   displayConfusionResults(confusionMat,[optionStr1,optionVal1])
%
% INPUTS:
%   confusionMat - (M x N number)
%       Confusion matrix for truth classes vs. computed classes.
%
% OPTIONS LIST:
%   'title' - (string) [Default 'The Confusion Matrix']
%       The displayed titled.
%
%   'truthLabels' - (1 x M cell array of strings)  [Default {'Class 1'...}]
%       The truth class labels.
%
%   'computedLabels' - (1 x N cell array of strings) [Default {'Class 1'...}]
%       The computed class labels.
%
%   'printIDs' - (1 x ? file IDs) [Default 1]
%       File IDs to where the output text is printed to. 0 is nothing, 1 is
%       standard out, 2 is standard error, other# is some file.
%
%   'columnSize' - (1 x 1 positive integer) [Default automatically changes]
%       Size of columns.
%
%   'display' - ('count','percent','both') [Default 'both']
%       Selects what is displayed. 'count' is just the count of each class.
%       'percent' is just the percentage of each class to the total in the
%       truth class. 'both' is both the count and the percetage.
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
%   printTo.m
%
% SEE ALSO:
%
% REVISION:
%   18-Jun-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%   18-NOV-2009 by Rowland O'Flaherty
%       Added printTo functionality.
%
%   05-MAY-2009 by Rowland O'Flaherty
%       Removed classLabels and classTags. Added truthLabels and
%       computedLabels. Added options list.
%
%   08-JAN-2010 by Rowland O'Flaherty
%       Moved "truthLabels" and "computedLabels" from required inputs to
%       opitional inputs. Added "title" option.
%
%--------------------------------------------------------------------------

%% Check input arguments
error(nargchk(1,inf,nargin))

% Check input arguments for errors
assert(isnumeric(confusionMat) & isreal(confusionMat),...
    'displayConfusionResults:confusionMatChk',...
    'Input argument "confusionMat" must be a matrix of real numbers.')
nTruthClasses = size(confusionMat,1);
nComputedClasses = size(confusionMat,2);

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'displayConfusionResults:optionsChk1','"options" must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('title')
            title = optValues{iParam};
        case lower('truthLabels')
            truthLabels = optValues{iParam};
        case lower('computedLabels')
            computedLabels = optValues{iParam};            
        case lower('printIDs')
            printIDs = optValues{iParam};
        case lower('columnSize')
            columnSize = optValues{iParam};
        case lower('display')
            display = optValues{iParam};
        otherwise
            error('displayConfusionResults:optionsChk2','Option string %s is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('title','var'), title = 'The Confusion Matrix'; end
if ~exist('truthLabels','var')
    truthLabels = cell(1,nTruthClasses);
    for iClass = 1:nTruthClasses
        truthLabels{iClass} = ['Class ' num2str(iClass)];
    end
end
if ~exist('computedLabels','var')
    computedLabels = cell(1,nComputedClasses);
    for iClass = 1:nComputedClasses
        computedLabels{iClass} = ['Class ' num2str(iClass)];
    end
end
if ~exist('printIDs','var'), printIDs = 1; end
if ~exist('columnSize','var'), columnSize = max([cellfun(@length,truthLabels) cellfun(@length,computedLabels) 5 size(num2str(confusionMat(:)),2)+9])+2; end
if ~exist('display','var'), display = 'both'; end

% Check optional arguments for errors
assert(ischar(title),...
    'displayConfusionResults:title',...
    'Optional argument "title" must be a string.')

assert(iscellstr(truthLabels) & numel(truthLabels) == nTruthClasses,...
    'displayConfusionResults:truthLabels',...
    'Optional argument "truthLabels" must be a %d element cell array of strings.',nTruthClasses)
truthLabels = truthLabels(:)';

assert(iscellstr(computedLabels) & numel(computedLabels) == nComputedClasses,...
    'displayConfusionResults:truthLabels',...
    'Optional argument "computedLabels" must be a %d element cell array of strings.',nComputedClasses)
computedLabels = computedLabels(:)';

assert((isnumeric(printIDs) || islogical(printIDs)) & isreal(printIDs) & all(printIDs >= 0) & all(mod(printIDs,1) == 0),...
    'displayConfusionResults:printIDs',...
    'Optional argument "printIDs" must be an array of positive real integers.')
printIDs = printIDs(:)';

assert(isnumeric(columnSize) & isreal(columnSize) & isequal(size(columnSize),[1 1]) & columnSize > 0 & mod(columnSize,1) == 0,...
    'displayConfusionResults:columnSize',...
    'Optional argument "columnSize" must be a 1 x 1 positive real integer.')

assert(ischar(display) & ismember(display,{'count','percent','both'}),...
    'displayConfusionResults:display',...
    'Optional argument "display" must be either ''count'', ''percent'', or ''both''.')

%% Set some variables
percentMat = round(confusionMat./repmat(sum(confusionMat,2),1,nComputedClasses)*1000)/10;

%% Print
titleSize = length(title);
printTo(printIDs,'+');
for s = 1:titleSize
    printTo(printIDs,'-');
end
printTo(printIDs,'+\n');
printTo(printIDs,'|%s|\n',title);
printTo(printIDs,'+');
for s = 1:titleSize
    printTo(printIDs,'-');
end
printTo(printIDs,'+\n');
printTo(printIDs,'Truth');
for s = 1:floor((columnSize+1)+(columnSize+1)*nComputedClasses/2-7)-5
    printTo(printIDs,' ');
end
printTo(printIDs,'Computed Class\n');
printTo(printIDs,'Class');
for s = 1:columnSize-length('Class')
    printTo(printIDs,' ');
end
printTo(printIDs,'|');
for j = 1:nComputedClasses
    for s = 1:columnSize-length(computedLabels{j})
        printTo(printIDs,' ');
    end
    printTo(printIDs,'%s',computedLabels{j});
    printTo(printIDs,'|');
end
if ~strcmp(display,'percent')
    printTo(printIDs,'|');
    for s = 1:columnSize-length('Total')
        printTo(printIDs,' ');
    end
    printTo(printIDs,'Total');
end
printTo(printIDs,'\n');
for j = 1:nComputedClasses+1
    for s = 1:columnSize
        printTo(printIDs,'-');
    end
    printTo(printIDs,'|');
end
if ~strcmp(display,'percent')
printTo(printIDs,'|');
    for s = 1:columnSize
        printTo(printIDs,'-');
    end
end

printTo(printIDs,'\n');

for i = 1:nTruthClasses
    printTo(printIDs,'%s',truthLabels{i});
    for s = 1:columnSize-length(truthLabels{i})
        printTo(printIDs,' ');
    end
    printTo(printIDs,'|');
    
    for j = 1:nComputedClasses
        switch display
            case 'count'
                formatedStr = sprintf('%d',confusionMat(i,j));
            case 'percent'
                formatedStr = sprintf('%-3.1f%%',percentMat(i,j));
            case 'both'
                formatedStr = sprintf('%d (%-3.1f%%)',confusionMat(i,j),percentMat(i,j));
        end
        for s = 1:columnSize-length(formatedStr)
            printTo(printIDs,' ');
        end
        printTo(printIDs,'%s',formatedStr);
        printTo(printIDs,'|');
    end
    if ~strcmp(display,'percent')
        printTo(printIDs,'|');
        for s = 1:columnSize-length(num2str(sum(confusionMat(i,:),2)))
            printTo(printIDs,' ');
        end
        printTo(printIDs,'%s',num2str(sum(confusionMat(i,:),2)));
    end
    printTo(printIDs,'\n');
end
if ~strcmp(display,'percent')
    for j = 1:nComputedClasses+2
        for s = 1:columnSize
            printTo(printIDs,'=');
        end
        if j ~= nComputedClasses+2
            printTo(printIDs,'|');
        end
        if j == nComputedClasses+1
            printTo(printIDs,'|');
        end
    end
    printTo(printIDs,'\n');
    
    printTo(printIDs,'Total');
    for s = 1:columnSize-length('Total')
        printTo(printIDs,' ');
    end
    printTo(printIDs,'|');
    for j = 1:nComputedClasses
        for s = 1:columnSize-length(num2str(sum(confusionMat(:,j),1)))
            printTo(printIDs,' ');
        end
        printTo(printIDs,'%d',sum(confusionMat(:,j),1));
        printTo(printIDs,'|');
    end
    printTo(printIDs,'|');
    for s = 1:columnSize-length(num2str(sum(confusionMat(:))))
        printTo(printIDs,' ');
    end
    printTo(printIDs,'%s',num2str(sum(confusionMat(:))));
end
printTo(printIDs,'\n\n');

end
