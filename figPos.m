function pos = figPos(screenName,figLoc)
% The "figPos" function returns figure position vector for a given
% configuration.
%
% SYNTAX:
%   pos = figPos(screenName,figLoc)
% 
% INPUTS:
%   screenName - ('main','external','top','side') ['main']
%       Screen figure will appear on.
%
%   figLoc - ('full','left','right',etc.) ['full']
%       Portion of screen figure will appear at.
% 
% OUTPUTS:
%   pos - ([x y h w]) 
%       Figure position vector.
%
% EXAMPLES:
%     figure(1)
%     set(1,'Position',figPos('top','full'))
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    figBoldify
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 04-FEB-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(0,3)

% Apply default values
if nargin < 1, screenName = 'main'; end
if nargin < 2, figLoc = 'full'; end

%% Do
nScreens = size(get(0,'MonitorPositions'),1);

pos = get(0,'defaultFigurePosition');

switch nScreens
    case 1
        switch screenName
            case 'main'
                switch figLoc
                    case 'full'
                        
                    case 'left'
                        pos = [5       1   718   805];
                    case 'right'
                        pos = [723     1   718   805];
                    case 'top'
                        pos = [843   515   838   441];
                    case 'bottom'
                        pos = [843     1   838   441];
                        
                end
        end
    case 2
        switch screenName
            case 'main'
                switch figLoc
                    case 'full'
                        pos = [-239  901  1680  954];
                    case 'left'
                        pos = [5     151   718   805];
                    case 'right'
                        pos = [723   151   718   805];
                end
            case 'external'
                switch figLoc
                    case 'full'
                        pos = [1441           1        1920         984];
                    case 'left'
                        pos = [1441           1         960         984];
                    case 'right'
                        pos = [2401           1         960         984];
                    case 'right_top'
                        pos = [2641         440         960         516];
                    case 'right_bottom'
                        pos = [2641        -149         960         516];
                    case 'right_2_3'
                        pos = [2081           1        1280         984];
                        
                end
        end
    case 3
        switch screenName
            case 'main'
                switch figLoc
                    case 'full'
                        pos = [1 1 1440 804];
                    case 'left'
                        pos = [5     1   718   805];
                    case 'right'
                end
            case 'top'
                switch figLoc
                    case 'full'
                        pos = [-239         901        1680         954];
                    case 'left'
                        pos = [-239   901   840   954];
                    case 'right'
                        pos = [601   901   840   954];
                    case 'left_2_3'
                        pos = [321 901 1120 954];
                        
                end
            case 'side'
                switch figLoc
                    case 'full'
                        pos = [1441         271        1050        1584];
                    case 'left'
                    case 'right'
                    case 'top'
                         pos = [1441        1099        1050         756];
                    case 'bottom'
                        pos = [1441         272        1050         755];
                end
        end
end
   
end
