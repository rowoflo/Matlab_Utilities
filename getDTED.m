function [dtedData,refMat,level] = getDTED(latLim,lonLim,DTEDDirHead)
% The "getDTED" function grabs DTED for a given patch of ground. Remember
% DTED is referenced to MSL, which is defined by the WGS84 EGS96 Geoid.
%
% USAGE:
%   [dtedData,refMat,level] = getDTED(latLim,lonLim,DTEDDirHead)
% 
% INPUTS:
%   latLim - (1 x 2 number) 
%       Latitude limits of the ground patch of DTED data.
%
%   lonLim - (1 x 2 number) 
%       Longitude limits of the ground patch of DTED data.
%
%   DTEDDirHead - (string)
%       Path to directory where the DTED file structure begins.
% 
% OUTPUTS:
%   dtedData - (? x ? number) 
%       DTED data elevation grid in meters.
%
%   refMat - (3 x 2 number)
%       Associated referencing matrix that geolocates the
%       DTED data.
%
%   level - (0, 1, or 2)
%       Level of the DTED data.
%
% DESCRIPTION:
%
% EXAMPLES:
%   % Example 1
%   latLim = [42.45 42.47];
%   lonLim = [-71.27 -71.25];
%   DTEDDirHead = '~/Matlab/MappingData/DTED';
%   [dtedData,refMat,level] = getDTED(latLim,lonLim,DTEDDirHead);
%   imagesc(dtedData)
%   axis xy
%
%   % Example 2
%	latCenter = 37.746470; lonCenter = -119.533054; % Half Dome
%	[img,imgRefMat,latLim,lonLim] = getGoogleMap([latCenter,lonCenter],...
%       'zoomLevel',14); % Get satelite image data
%	[imgLatMesh,imgLonMesh] = meshgrat(img(:,:,1),imgRefMat);
%	DTEDDirHead = '~/Matlab/MappingData/DTED'; % Set path to DTED data
%	[dtedData,dtedRefMat,level] = getDTED(latLim,lonLim,DTEDDirHead); % Get DTED data
%	dtedImg = ltln2val(dtedData,...
%	dtedRefMat,imgLatMesh,imgLonMesh,'bicubic'); % Resample DTED data to image data
%	surfH = surface(imgLonMesh,imgLatMesh,dtedImg,img,...
%       'FaceColor','texturemap',...
%       'EdgeColor','none',...
%       'CDataMapping','direct');
%   grid on; view(-90,30)
%	title('Half Dome')
%	xlabel('Longitude'); ylabel('Latitude') ; zlabel('Elevation')
%
%
% NOTES:
%   Most of the code is copied from Dave Barrett's function readDTED.m.
%
%   To plot either use:
%       mapshow(dtedData,refMat,'DisplayType','texturemap')
%   or
%       imagesc(dtedData)
%       axis xy
%
%   For a detailed explanation of DTED heigth referenced to WGS84 EGM96
%   geoid see:
%   Defining Mean Sea Level in Military Simulations with DTED by Nicolas H.
%   Durland from Northrop Grumman Corporation
%   http://delivery.acm.org/10.1145/1640000/1639931/a115-durland.pdf?key1=1639931&key2=7114424921&coll=DL&dl=ACM&CFID=4574267&CFTOKEN=92655428
%
% NECESSARY FILES:
%   Matlab Mapping Toolbox
%
% SEE ALSO:
%    getGoogleElevation, getGoogleMap
%
% REVISION:
%   1.0 17-MAY-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%   1.1 02-Jun-2010 by Rowland O'Flaherty
%       Removed flipupFlag
%
%   1.2 22-Feb-2011 by Rowland O'Flaherty
%       Added examples
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(3,3,nargin))

% Check input arguments for errors
assert(isnumeric(latLim) && isreal(latLim) && numel(latLim) == 2,...
    'getDTED:latLimChk',...
    'Input argument "latLim" must be a 1 x 2 real number.')

assert(isnumeric(lonLim) && isreal(lonLim) && numel(lonLim) == 2,...
    'getDTED:lonLimChk',...
    'Input argument "lonLim" must be a 1 x 2 real number.')

assert(ischar(DTEDDirHead) && isdir(DTEDDirHead),...
    'getDTED:DTEDDirHeadChk',...
    'Input argument "DTEDDirHead" must be a string for a valid directory.')

%% Get files
% Find the necessary files in the highest level possible
dtedDir = '';
for level = 2:-1:0
    dtedFilename = dteds(latLim, lonLim, level);
    allExist = true;
    for dI = 1:length(dtedFilename)
        if ~exist([DTEDDirHead filesep 'level' num2str(level) filesep dtedFilename{dI}], 'file')
            allExist = false;
            break;
        end
    end
    if allExist
        dtedDir = [DTEDDirHead filesep 'level' num2str(level)];
        break;
    end
end

%% Read the DTED
if ~isempty(dtedDir)
    [dtedData, refVec] = dted(dtedDir, 1, latLim, lonLim);
    refMat = refvec2mat(refVec,size(dtedData));
else
    error('getDTED:dtedDirChk','DTED files not available');
end

end
