function output = loadVarsFromCSV(filePath,varargin)
% The "loadVarsFromCSV" function loads variables from a CSV file.
%
% USAGE:
%   loadVarsFromCSV(filePath,[var1],[var2],[var3],...)
% 
% INPUTS:
%   filePath - (1 x 1 string) 
%       String path to where the CSV file is located.
%
%   var? - (1 x 1 string)
%       Name of variable to load. If no variable arguments are provided all
%       the variables are loaded.
% 
% OUTPUTS:
%  [output] - (struct)
%       A structure with fields names that correspond to header names of
%       the CSV file. If this output variable is not used the variables are
%       loaded directly into the workspace.
%
% DESCRIPTION:
%   This functions loads variables into the calling workspace that are
%   stored in a CSV file. The CSV file must be in a special format. Each
%   variable must be listed in the first row of the CSV file separated by
%   commas. The variable will contain a cell array of strings corresponding
%   to the entries in the same column and the rows below the first row in
%   the file. These entries are also sparated by commas.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% REVISION:
%   05-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(1,inf,nargin))

nOpt = size(varargin,2);

assert(ischar(filePath),'loadVarsFromCSV:filePathChk1',...
    'Input argument must be a string')

assert(iscellstr(varargin),'loadVarsFromCSV:optargChk',...
    'Opitional arguments must be strings')


[fileDir, fileName, fileExt] = fileparts(filePath);
assert(strcmp(fileExt,'.csv'),'loadVarsFromCSV:filePathChk2','Input argument must be .csv file')
clear fileDir fileName fileExt

% Open file
fileID = fopen(filePath);
if fileID == -1
    error('loadVarsFromCSV:filePathChk3','%s is not a valid file',filePath)
end
% Get number of variable fields
varCnt = textscan(fileID,'%s',1,'delimiter','\n');
varCnt = textscan(varCnt{1}{1},'%s','delimiter',',');
varCnt = length(varCnt{1});
% Create format string
formatStr = repmat('%s ',1,varCnt);
formatStr = formatStr(1:end-1);
% Gather header titles and data
frewind(fileID);
header = textscan(fileID,formatStr,1,'delimiter',',','CollectOutput',1);
header = regexp(header{1},'[a-zA-Z_0-9]*','match'); % Remove bad characters
header = cellfun(@(aCell) aCell{:},header,'UniformOutput',false);
data = textscan(fileID,formatStr,'delimiter',',','CollectOutput',1);
data = data{1};
fclose(fileID);

% Create variables named after header titles
if nargout == 0
    for iVar = 1:length(header)
        if nOpt == 0
            assignin('caller',header{iVar},data(:,iVar))
        else
            if ismember(header{iVar},varargin)
                assignin('caller',header{iVar},data(:,iVar))
            end
        end
    end
elseif nargout == 1
    for iVar = 1:length(header)
        output.(header{iVar}) = data(:,iVar);
    end
else
    error('loadVarsFromCSV:outArgChk','Invalid number of output arguments.')
end