function figTile(varargin)
% The "figTile" function tiles the given figures across the screen for easy
% viewing.
%
% USAGE:
%   figTile([figureHandles])
% 
% INPUTS:
%   [figureHandles] - (figure handles) [Default all open figures]
%       A set of figure handles that will be tiled.
%
% OPTIONS LIST:
%   [screens]  - (positve integers) [Default all screens]
%       A list of which screens will be included in the tiling.
%
% DESCRIPTION:
%   This function tiles the given figures across multiple screens for easy
%   viewing. The largest screen determines the tiling size. Thus the figure
%   tiles will fit perfectly with the largest screen and be added to the
%   smaller screens once at least one tile can fit in the smaller screen in
%   all dimesions. The figure tiles are positioned so the lowest handle
%   figure is will start in the upper right hand corner of the lowest
%   screen handle (or the primary screen).
%
% EXAMPLES:
%   figTile([1 2 4],'screens',1)
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   figForward, fig2html
%
% REVISION:
%   1.0 19-JAN-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Get figure handles
if nargin == 0 || ischar(varargin{1})
    figureHandles = sort(get(0,'Children'));
else
    figureHandles = varargin{1};
    varargin = varargin(2:end);
end

% Check inputs for errors
assert(all(ishandle(figureHandles)),...
    'figTile:figureHandlesChk',...
    'Input argument "figureHandles" must all be valid graphics handles.')

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'figTile:optionsChk1','"options" must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case 'screens'
            screens = optValues{iParam};
        otherwise
            error('figTile:optionsChk2','Option string %s is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('screens','var'), screens = 1:size(get(0,'MonitorPositions'),1); end

% Check optional arguments for errors
assert(isreal(screens) && isnumeric(screens) && all(screens > 0) && all(mod(screens,1) == 0),...
    'figTile:screensChk',...
    'Optional argument "figTile" must be a set of positive real integers.')
screens = screens(:);

%% Get Info
if ismac
    winTopBorder = 23;
    winBottomBorder = 0;
    winLeftBorder = 0;
    winRightBorder = 0;
    menubar = 23;
    toolbar = 28;
else
    warning('figTile:platformChk','This function was designed for Mac OS X')
    winTopBorder = 73;
    winBottomBorder = 0;
    winLeftBorder = 0;
    winRightBorder = 0;
    menubar = 23;
    toolbar = 28;
end


nFigs = numel(figureHandles);
screenPos = get(0,'MonitorPositions');
screenPos = screenPos(screens,:);
screenSizes = screenPos(:,[4 3]);
[val,ind] = max(prod(screenSizes,2));
validScreenLogi = screenSizes(:,1) == screenSizes(ind,1) & screenSizes(:,2) == screenSizes(ind,2); % ? x 1

validScreenInds = find(validScreenLogi); % ? x 1
invalidScreenInds = find(~validScreenLogi); % ? x 1
tiling = ones(length(validScreenInds),2);

%% Make screen tiles
nTiles = sum(prod(tiling,2),1);
tileSize = screenSizes(validScreenInds(1),:);
while nTiles < nFigs
    [val,ind] = max(tileSize);
    tileSize(ind) = val/2;
    
    screenOkLogi = screenSizes(invalidScreenInds,1) >= tileSize(1) & screenSizes(invalidScreenInds,2) >= tileSize(2);
    if any(screenOkLogi)
        validScreenInds = [validScreenInds;invalidScreenInds(screenOkLogi)]; %#ok<AGROW>
        invalidScreenInds = setdiff(invalidScreenInds,invalidScreenInds(screenOkLogi));
    end
    
    tiling = floor(screenSizes(validScreenInds,:)./repmat(tileSize,length(validScreenInds),1));
    nTiles = sum(prod(tiling,2),1); 
end

[validScreenInds, ind] = sort(validScreenInds);
tiling = tiling(ind,:);

%% Tile
iScreen = 1;
iXTile = 1;
iYTile = 1;
w = tileSize(2)-(winLeftBorder+winRightBorder);

for iFig = 1:nFigs
    x = screenPos(validScreenInds(iScreen),1) + tileSize(2)*(iXTile-1);
    y = screenPos(validScreenInds(iScreen),4) - tileSize(1)*iYTile+1;
    h = tileSize(1)-(winTopBorder+winBottomBorder);
    if strcmp(get(figureHandles(iFig),'Menubar'),'figure')
        h = h - menubar;
        if ~strcmp(get(figureHandles(iFig),'Toolbar'),'none')
            h = h - toolbar;
        end
    end
    
    set(figureHandles(iFig),'Position',[x,y,w,h])
    
    iXTile = iXTile + 1;
    if iXTile > tiling(iScreen,2)
        iXTile = 1;
        iYTile = iYTile + 1;
        if iYTile > tiling(iScreen,1)
           iYTile = 1;
           iScreen = iScreen + 1;
        end
    end
end

end
