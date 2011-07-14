function printStat(mat,dim,varargin)
% The "printStat" function prints varies statistical information about the
% input "mat".
%
% USAGE:
%   printStat(mat,[dim],[optionStr1,optionVal1])
% 
% INPUTS:
%   mat - (numeric) 
%       Input matrix
%
%   [dim] - (1 x 1 positive integer or empty) [1] 
%       The dimension  to operate over. If empty default is used.
%
% OPTIONS LIST:
%   'stats' - ('basic' or 'all') ['basic']
%       Sets how many different statistical measures are printed. 'basic'
%       includeds mean, std, min, max, and median. 
%
%   'varName' - (string) ['']
%       Name of variable associated with "mat".
%
%   'format' - (string or integer) ['%11.4f']
%       The format the number are printed in. See help for "num2str".
%
%   'printIDs' - (? x ? x ... file identifier) [1]
%       File ID for where the text will be printed to. See "printTo"
%       function.
% 
% OUTPUTS:
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%   Mode is only computed if "mat" if at least one values comes up more
%   than once.
%
% NECESSARY FILES:
%   printTo.m
%
% SEE ALSO:
%    printStruct
%
% REVISION:
%   1.0 11-NOV-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,inf,nargin))

% Apply default values
if nargin < 2, dim = 1; end

% Check input arguments for errors
assert(isnumeric(mat),...
    'printStat:mat',...
    'Input argument "mat" must be numeric.')
if isvector(mat), mat = mat(:); end % Make column vector

assert((isnumeric(dim) && isreal(dim) && numel(dim) == 1 && dim > 0 && mod(dim,1) == 0) || isempty(dim),...
    'printStat:dim',...
    'Input argument "dim" must be a 1 x 1 positive real integer.')
if isempty(dim), dim = 1; end

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'printStat:options','Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('stats')
            stats = optValues{iParam};
        case lower('varName')
            varName = optValues{iParam};
        case lower('format')
            format = optValues{iParam};
        case lower('printIDs')
            printIDs = optValues{iParam};
        otherwise
            error('printStat:options','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('stats','var'), stats = 'basic'; end
if ~exist('varName','var'), varName = ''; end
if ~exist('format','var'), format = '%11.4f'; end
if ~exist('printIDs','var'), printIDs = 1; end

statsSet = {'basic','all'};
assert(ischar(stats) && ismember(lower(stats),statsSet),...
    'printStat:stats',...
    'Optional argument "stats" must be either ''basic'' or ''all''')
stats = lower(stats);

assert(ischar(varName),...
    'printStat:varName',...
    'Optional argument "varName" must be a string.')
if ~isempty(varName)
    varName = [varName ' '];
end

%% Print stats

if strcmp(stats,'basic')
    
    printTo(printIDs,'--- %sStat Info ---\n',varName)
    printTo(printIDs,'     count: %s\n',num2str(size(mat,dim)))
    printTo(printIDs,'      mean: %s\n',charMat2charRow(num2str(mean(mat,dim),format)))
    printTo(printIDs,'       std: %s\n',charMat2charRow(num2str(std(mat,0,dim),format)))
    printTo(printIDs,'       min: %s\n',charMat2charRow(num2str(min(mat,[],dim),format)))
    printTo(printIDs,'    median: %s\n',charMat2charRow(num2str(median(mat,dim),format)))
    printTo(printIDs,'       max: %s\n',charMat2charRow(num2str(max(mat,[],dim),format)))
    
elseif strcmp(stats,'all')
    
    printTo(printIDs,'--- %sStat Info ---\n',varName)
    printTo(printIDs,'         count: %s\n',num2str(size(mat,dim)))
    printTo(printIDs,'          mean: %s\n',charMat2charRow(num2str(mean(mat,dim),format)))
    printTo(printIDs,'  mean abs dev: %s\n',charMat2charRow(num2str(mad(mat,0,dim),format)))
    printTo(printIDs,'           std: %s\n',charMat2charRow(num2str(std(mat,0,dim),format)))
    printTo(printIDs,'           var: %s\n',charMat2charRow(num2str(var(mat,0,dim),format)))
    printTo(printIDs,'      skewness: %s\n',charMat2charRow(num2str(skewness(mat,1,dim),format)))
    printTo(printIDs,'      kurtosis: %s\n',charMat2charRow(num2str(kurtosis(mat,1,dim),format)))
    printTo(printIDs,'           min: %s\n',charMat2charRow(num2str(min(mat,[],dim),format)))
    printTo(printIDs,'       5%% tile: %s\n',charMat2charRow(num2str(prctile(mat,5,dim),format)))
    printTo(printIDs,'      25%% tile: %s\n',charMat2charRow(num2str(prctile(mat,25,dim),format)))
    printTo(printIDs,'        median: %s\n',charMat2charRow(num2str(median(mat,dim),format)))
    printTo(printIDs,'      75%% tile: %s\n',charMat2charRow(num2str(prctile(mat,75,dim),format)))
    printTo(printIDs,'      95%% tile: %s\n',charMat2charRow(num2str(prctile(mat,95,dim),format)))
    printTo(printIDs,'           max: %s\n',charMat2charRow(num2str(max(mat,[],dim),format)))
    printTo(printIDs,'           iqr: %s\n',charMat2charRow(num2str(iqr(mat,dim),format)))
    printTo(printIDs,'         range: %s\n',charMat2charRow(num2str(range(mat,dim),format)))
    printTo(printIDs,'median abs dev: %s\n',charMat2charRow(num2str(mad(mat,1,dim),format)))
    printTo(printIDs,'          mode: %s\n',charMat2charRow(num2str(mode(mat,dim),format)))
    
end
end

%% Helper function
function charRow = charMat2charRow(charMat)
nRows = size(charMat,1);
nCols = size(charMat,2);

extraChars = ';    ';
nExtraChars = length(extraChars);
charRow = repmat(' ',1,nRows * (nCols+nExtraChars));
for iRow = 1:nRows
    charRow((iRow-1)*(nCols+nExtraChars)+1:iRow*(nCols+nExtraChars)) = [charMat(iRow,:) extraChars];
end

end