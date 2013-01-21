%% cccc.m
% This script clears the workspace, the the command window, closes all
% figures, and clear the classes.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
% SEE ALSO:
%   cc, ccc
%
% REVISION:
%   1.0 18-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------


%% Delete Class Objects
types = {'char','double','logical','cell','struct','function_handle','quaternion'}; % Class types not to delete

s = whos;
delInd = ~ismember({s.class},types);
s = s(delInd);

for i = 1:numel(s);
    eval(['delete(' s(i).name ')']);
end

%% Clear Everything
clc
clear
close all
clear classes