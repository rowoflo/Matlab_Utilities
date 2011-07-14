function newDoc(docName,docType,docLocation,templatesLocation)
%--------------------------------------------------------------------------
% The "newDoc" function opens up the editor with a new document ready for
% editing.
%
% USAGE:
%   newDoc([docName],[docType],[docLocation],[templatesLocation])
% 
% INPUTS:
%   docName - (1 x 1 string) [Default 'myNewFunction']
%       This is the name of the new document with no '.m'.
%
%   docType - (1 x 1 string) [Default 'function']
%       This type of document that will be created.
%   
%   docLocation - (1 x 1 string) [Default pwd]
%       This is the directory where the document will be saved to.
%
%   templatesLocation -(1 x 1 string) [Default ~/MATLAB/Templates]
%       This is the location of the directory where the templates live.
%
% OUTPUTS:
%
% DESCRIPTION:
%   This function uses the varies templates that are stored in
%   MATLAB\templates folder. The docType decides which template to use.
%   The opitions are 'function', 'script', 'class', and 'method'.
%
% EXAMPLES:
%   newDoc('myNewScript','script','~/')
%
% NOTES:
%
% NECESSARY FILES:
%   function_template.m, script_template.m, class_template.m,
%   method_template.m, html_template.m
%
% SEE ALSO:
%   
% REVISION:
%   1.0 21-MAY-2009 by Rowland O'Flaherty
%       Iniital Revision.
%
%   1.1 12-JUN-2009 by Rowland O'Flaherty
%       New documents will have name and date automatically inserted into
%       the template.
%
%   1.2 22-JAN-2010 by Rowland O'Flaherty
%       Added html type document.
%
%--------------------------------------------------------------------------

%% Check input arguments
error(nargchk(0,4,nargin))

if nargin < 1, docName = 'myNewFunction'; end
if nargin < 2, docType = 'function'; end
if nargin < 3, docLocation = pwd; end
if nargin < 4
    mat = regexp(userpath,'(\<(\w:|\\\\)[^;]*|\</[^:]*|)','match');
    templatesLocation = fullfile(mat{1},'Templates'); 
end

validTypes = {'function','script','class','method','html','gui'}; % Holds the valid document types

% Throw errors on bad input arguments
assert(ischar(docName),...
    'newDoc:docNameChk1',...
    'Input argument "docName" must be a string.')

docType = lower(docType);
if all(~ismember(validTypes,docType))
    for aTypeInd = 1:length(validTypes)
        if aTypeInd == 1
            errorStr = ['''' validTypes{aTypeInd} ''', '];
        elseif aTypeInd ~= length(validTypes)
            errorStr = [errorStr '''' validTypes{aTypeInd} ''', ']; %#ok<AGROW>
        else
            errorStr = [errorStr 'and ''' validTypes{aTypeInd} '''']; %#ok<AGROW>
        end
    end
    error('newDoc:docTypeChk1','Input argument "docType" must be one of these types: %s.',errorStr)
end

assert(ischar(docLocation),...
    'newDoc:docLocationChk1',...
    'Input argument "docLocation" must be a string.')
if ~isdir(docLocation)
    status = mkdir(docLocation);
    if ~status
        error('newDoc:docLocationChk2','Input argument "docLocation" is not a valid directory: %s',docLocation)
    end
end

assert(isempty(dir([fullfile(docLocation,docName) '.m'])),...
    'newDoc:docNameChk2',...
    '%s.m already exist in %s.',docName,docLocation)

assert(isdir(templatesLocation),...
    'newDoc:templatesLocationChk1',...
    'Input argument "templatesLocation" must be a valid directory.')

%% Get User Name
defaultName = 'SET DEFAULT NAME IN newDoc.m LINE 105';
if ismac
    [status, fullName] = unix('osascript -e "long user name of (system info)"');
    fullName = fullName(1:end-1);
    if status
        fullName = 'AUTHOR_NAME_HERE';
    end
else
    fullName = defaultName;
end

%% Get Package Name and Class Name
% Extract from path
if strcmp(docLocation(1),'/')
    docPath = docLocation;
else
    docPath = fullfile(pwd,docLocation);
end

packageName = regexp(docPath,'(?<=\+)\w*(?=/)|(?<=\+)\w*$','match'); % Get package name from path
if isempty(packageName)
    packageName = [];
else
    packageName = packageName{1};
end

className = regexp(docPath,'(?<=\@)\w*(?=/)|(?<=\@)\w*$','match'); % Get class name from path
if isempty(className)
    className = [];
else
    className = className{1};
end

%% Make new document
% Open template
switch lower(docType)
    case 'function'
        templateName = 'function_template.m';
        docExt = '.m';
    case 'script'
        templateName = 'script_template.m';
        docExt = '.m';
    case 'class'
        templateName = 'class_template.m';
        docExt = '.m';
    case 'method'
        templateName = 'method_template.m';
        docExt = '.m';
    case 'html'
        templateName = 'html_template.html';
        docExt = '.html';
    case 'gui'
        templateName = 'gui_template.m';
        docExt = '.m';
end
templateFullPath = fullfile(templatesLocation,templateName);
templateFileID = fopen(templateFullPath,'r');

docFullPath = fullfile(docLocation,[docName docExt]);

% Customize new document
docFileID = fopen(docFullPath,'w');

while 1 % Loop through each line looking for specific words
    try
        aLine = fgetl(templateFileID);
        if ~ischar(aLine),   break,   end
        aLine = regexprep(aLine,[docType '_name'],docName); % Replaces [docType _name'] (e.g. 'function_name') with the name of the new document
        aLine = regexprep(aLine,'DD-MMM-YYYY',upper(date)); % Sets the current date
        aLine = regexprep(aLine,'FULL_NAME',fullName); % Set the author's name
        if ~isempty(packageName)
            aLine = regexprep(aLine,'package_name',packageName); % Set the package name
        else
            aLine = regexprep(aLine,'package_name:',''); % Remove 'package_name' keyword if not in a package
        end
        if ~isempty(className) && ~strcmp(docType,'class')
            aLine = regexprep(aLine,'class_name',className); % Set the class name
        end
        fprintf(docFileID,'%s\n',aLine);
    catch ME
        fclose('all'); % If error close all open files
        rethrow(ME)
    end
end
fclose(templateFileID);
fclose(docFileID);
     
% Open new document in editor
edit(docFullPath);

end