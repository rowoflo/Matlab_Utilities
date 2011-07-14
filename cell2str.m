function str = cell2str(cellstr,varargin)
% The "cell2str" function converts a cell array of strings to one string.
%
% USAGE:
%   str = cell2str(cellstr,[optionStr,optionVal])
%
% INPUTS:
%   cellstr - (? x ? cell array of strings)
%       Input set of strings that will be concatenated into one string.
%
% OPTIONS LIST:
%   [includeAnd] - (1 x 1 logical) [Default false]
%       True will put an 'and' before the last string in every row.
%
%   [includeOr] - (1 x 1 logical) [Default false]
%       True will put an 'or' before the last string in every row.
%
%   [singleQuotes] - (1 x 1 logical) [Default true]
%       True will put single quotes around each string.
%
% OUTPUTS:
%   str - (1 x 1 str)
%       String formed from all the strings from cellstr
%
% DESCRIPTION:
%   This function creates one string from a cell array of strings. Strings
%   are concatenated horizontally, separated by commas, then vertically
%   separated by semi-colons.
%
% EXAMPLES:
%   str = cell2str({'hi','bye';'yes','no'},'includeAnd',true)
%
% NOTES:
%   If both "includeAnd" and "includeOr" is set to true an 'and/or'
%   will be added before the last string in every row.
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% REVISION:
%   05-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%   25-AUG-2010 by Rowland O'Flaherty
%       Added "includeOr"
%
%--------------------------------------------------------------------------

%% Check number of input arguments
error(nargchk(1,inf,nargin))

%% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'cell2str:optionsChk1','options must have optStr and optValue pairs')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iparam = 1:optargin/2
    switch lower(optStrs{iparam})
        case lower('includeAnd')
            includeAnd = optValues{iparam};
        case lower('includeOr')
            includeOr = optValues{iparam};
        case lower('singleQuotes')
            singleQuotes = optValues{iparam};
        otherwise
            error('cell2str:optionsChk2','options string %s not recognized',optStrs{iparam})
    end
end

% Set to default value if necessary
if ~exist('includeAnd','var'), includeAnd = false; end
if ~exist('includeOr','var'), includeOr = false; end
if ~exist('singleQuotes','var'), singleQuotes = true; end

%% Check input arguments

assert(iscellstr(cellstr),'cell2str:cellstrChk','Input must be a cell array of strings')

assert(islogical(includeAnd),'cell2str:includeAndChk','"includeAnd" option must be a logical variable')

assert(islogical(includeOr),'cell2str:includeOrChk','"includeOr" option must be a logical variable')

assert(islogical(singleQuotes),'cell2str:singleQuotesChk','"singleQuotes" option must be a logical variable')

%% Run
[M,N] = size(cellstr);

str = '';

if ~includeAnd && ~includeOr % Without 'and' and without 'or'
    for iM = 1:M
        for iN = 1:N
            if singleQuotes, cellstr{iM,iN} = ['''' cellstr{iM,iN} '''']; end
            str = [str cellstr{iM,iN} ', ']; %#ok<*AGROW>
        end
        str(end-1) = ';';
    end
    str = str(1:end-2);
elseif includeAnd && ~includeOr % With 'and' and without 'or'
    for iM = 1:M
        for iN = 1:N
            if singleQuotes, cellstr{iM,iN} = ['''' cellstr{iM,iN} '''']; end
            if iN ~= N
                str = [str cellstr{iM,iN} ', '];
            else
                if N == 1
                    str = [cellstr{iM,iN} '  '];
                elseif N == 2
                    str = [str(1:end-2) ' and ' cellstr{iM,iN} ', '];
                else
                    str = [str 'and ' cellstr{iM,iN} ', '];
                end
            end
        end
    end
    str = str(1:end-2);
elseif ~includeAnd && includeOr % Without 'and' and with 'or'
    for iM = 1:M
        for iN = 1:N
            if singleQuotes, cellstr{iM,iN} = ['''' cellstr{iM,iN} '''']; end
            if iN ~= N
                str = [str cellstr{iM,iN} ', '];
            else
                if N == 1
                    str = [cellstr{iM,iN} '  '];
                elseif N == 2
                    str = [str(1:end-2) ' or ' cellstr{iM,iN} ', '];
                else
                    str = [str 'or ' cellstr{iM,iN} ', '];
                end
            end
        end
    end
    str = str(1:end-2);
else % With 'and' and with 'or'
    for iM = 1:M
        for iN = 1:N
            if singleQuotes, cellstr{iM,iN} = ['''' cellstr{iM,iN} '''']; end
            if iN ~= N
                str = [str cellstr{iM,iN} ', '];
            else
                if N == 1
                    str = [cellstr{iM,iN} '  '];
                elseif N == 2
                    str = [str(1:end-2) ' and/or ' cellstr{iM,iN} ', '];
                else
                    str = [str ' and/or ' cellstr{iM,iN} ', '];
                end
            end
        end
    end
    str = str(1:end-2);
end

end
