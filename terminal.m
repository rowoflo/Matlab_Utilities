function terminal(directory)
% The "terminal" function opens the Mac Terminal app to the given directory.
%
% SYNTAX:
%   output = terminal()
%   output = terminal(directory)
% 
% INPUTS:
%   directory - (string) [pwd] 
%       Path to open terminal to. Must be a valid directory.
%
% EXAMPLES:
%   terminal('~/Dropbox')
%
% NOTES:
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 05-FEB-2014
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(0,1)

% Apply default values
if nargin < 2, directory = pwd; end

% Check input arguments for errors
assert(ischar(directory),...
    'terminal:directory',...
    'Input argument "directory" must be a string.')
if ~isdir(directory)
    status = mkdir(directory);
    if ~status
        error('terminal:directory','Input argument "directory" is not a valid directory: %s',directory)
    end
end

%% Execute
system(['open -a Terminal ', directory]);

end
