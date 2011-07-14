function [img,refMat,latLim,lonLim] = getGoogleMap(location,varargin)
% The "getGoogleMap" function retrieves a google map image at the specified
% location. 
%
% USAGE:
%   [img,[refMat],[latLim],[lonLim]] = getGoogleMap(location,[optionStr1,optionVal1])
% 
% INPUTS:
%   location - (1 x 2 number) or (string) 
%       Is the location of the center of the image that the function will
%       retrieve. This can either be a 2 element vector specifying the
%       latitude and longitude coordinates, e.g. [38.897675 -77.036597]. Or
%       a string specifying the address, e.g. '1600 Pennselvania Ave
%       Washington DC 20500'.
%
% OPTIONS LIST:
%   'savePath' - (string) [Default '']
%       Path to where the image will be saved. If empty the image will not
%       be saved to file. If the file extension is not included the
%       appropriate extension will be added. If the directory of the save
%       path doesn't exist it will be created.
%
%   'mapType' - (string) [Default 'satellite']
%       The type of map that will be returned. Other map types can be
%       viewed from Google's website.
%
%
%   'zoomLevel' - (1 x 1 semi-positive integer) [Default 17]
%       The Google zoom level of the image. 0 is the whole world 20 is from
%       a view of about 150m. It is on a log scale.
%
%   'imgSize' -  (2 x 1 positive integer) [Default is [512 512]]
%       Image size in pixels [width height]. Note largest image Google will
%       return is [640 640].
%
%   'imgFormat' - (string) [Default 'png']
%       Specifies the graphics format of the image. Other option can be
%       seen on Google's website.
%
%   'openImg' - (1 x 1 logical) [Default false]
%       If true and the savePath is not empty the image file will open in
%       the appropriate application.
% 
% OUTPUTS:
%   img - (? x ? x 3 doubles) 
%       Matrix of true RGB values. The size will be equal to the 'imgSize'
%       opition. The default orientation for the image is that img(1,1) is
%       in the north west corner of the image.
%
%   [refMat] - (3 x 2 numbers)
%      Affine spatial-referencing matrix. This can be used in Matlab's
%      Mapping toolbox to geolocate the image. This is only returned if
%      location is specified in [latitude, longitude], not as an address
%      string. For more info on the referencing matrix do a help on
%      "makerefmat".
%
%   [latLim] - (1 x 2 number)
%       Latitude limits of the image, which were used to make "refMat".
%
%   [lonLim] - (1 x 2 number)
%       Longitude limits of the image, which were used to make "refMat".
%
% DESCRIPTION:
%   This function uses Google's Static Maps V2 API to grab static
%   geolocated images from the internet. These are the same images that you
%   get from Google Maps.
%
% EXAMPLES:
%   % Example 1
%   [img,refMat,latLim,lonLim] = getGoogleMap([38.897675,-77.036597],...
%       'zoomLevel',14,'mapType','hybrid','imgSize',[640 640]); 
%   mapshow(img,refMat); xlim(lonLim); ylim(latLim);
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
% NOTES:
%   It is recommend to use "mapshow" in the Mapping toolbox to display the
%   image.
%
%   See http://code.google.com/apis/maps/documentation/staticmaps/#Locations
%   for more information on the Google Maps API.
%
%   Google puts a limit of 1000 image request per day.
%
%   It has beened noticed that when "imgFormat" is set to 'png32' the
%   geolocation of the image is incorrect.
%
% NECESSARY FILES:
%   cell2str.m
%
% SEE ALSO:
%    getGoogleElevation, getDTED
%
% REVISION:
%   1.0 13-MAY-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%   1.1 17-MAY-2010 by Rowland O'Flaherty
%       Added latLim and lonLim to the output. And removed flipImg
%       option.
%
%   1.2 22-Feb-2011 by Rowland O'Flaherty
%       Added examples and updated error dialogue
%
%--------------------------------------------------------------------------

%% Check number of inputs
error(nargchk(1,inf,nargin))

% Check input arguments for errors
assert((isnumeric(location) && isreal(location) && numel(location) == 2) || ischar(location),...
    'getGoogleMap:locationChk',...
    'Input argument "location" must be a 1 x 2 vector of numbers or a string.')
if isnumeric(location)
    locationIsLatLon = true;
    location = location(:)';
else
    locationIsLatLon = false;
end

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'getGoogleMap:optionsChk1','Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case 'savepath'
            savePath = optValues{iParam};
        case 'maptype'
            mapType = optValues{iParam};
        case 'zoomlevel'
            zoomLevel = optValues{iParam};
        case 'imgsize'
            imgSize = optValues{iParam};
        case 'imgformat'
            imgFormat = optValues{iParam};
        case 'openimg'
            openImg = optValues{iParam};
        otherwise
            error('getGoogleMap:optionsChk2','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('savePath','var'), savePath = ''; end
if ~exist('mapType','var'), mapType = 'satellite'; end
if ~exist('zoomLevel','var'), zoomLevel = 17; end
if ~exist('imgSize','var'), imgSize = [512 512]; end
if ~exist('imgFormat','var'), imgFormat = 'png'; end
if ~exist('openImg','var'), openImg = false; end

% Check optional arguments for errors
assert(isempty(savePath) || (ischar(savePath)),...
    'getGoogleMap:savePathChk',...
    'Optional argument "savePath" must be empty of or a string.')
if ~isempty(savePath)
    saveFlag = true;
    [saveDir,saveFileName,saveFileExt] = fileparts(savePath);
    if ~isdir(saveDir)
        [status,message,messageid] = mkdir(saveDir);
        assert(status == 1,messageid,message)
    end
else
    saveDir = pwd;
    saveFileName = 'getGoogleMap_tmpImage';
    saveFileExt = '';
    saveFlag = false;
end

assert(ischar(mapType),...
    'getGoogleMap:mapTypeChk1',...
    'Optional argument "mapType" must be a string.')
mapType = lower(mapType);
validMapTypes = {'roadmap','satellite','terrain','hybrid'};
if ~ismember(mapType,validMapTypes)
    warning('getGoogleMap:mapTypeChk2','Optional argument ''%s'' may not be a valid map type.\nValid types are: %s',mapType,cell2str(validMapTypes,'singleQuotes',true))
end

assert(isnumeric(zoomLevel) && isreal(zoomLevel) && numel(zoomLevel) == 1 && mod(zoomLevel,1) == 0 && zoomLevel >= 0,...
    'getGoogleMap:zoomLevelChk',...
    'Optional argument "zoomLevel" must be a semi-positive integer.')

assert(isnumeric(imgSize) && isreal(imgSize) && numel(imgSize) == 2 && all(mod(imgSize,1) == 0) && all(imgSize > 0),...
    'getGoogleMap:imgSizeChk',...
    'Optional argument "imgSize" must be a 1 x 2 vector of positive integers.')
imgSize = imgSize(:)';

assert(ischar(imgFormat),...
    'getGoogleMap:imgFormatChk1',...
    'Optional argument "imgFormat" must be a string.')
mapType = lower(mapType);
validImgFormats = {'png','png8','png32','gif','jpg','jpg-baseline'};
if ~ismember(imgFormat,validImgFormats)
    warning('getGoogleMap:imgFormatChk2','Optional argument ''%s'' may not be a valid format.\nValid formats are: %s',imgFormat,cell2str(validImgFormats,'singleQuotes',true))
end

if isempty(saveFileExt)
    saveFileExt = ['.' imgFormat(1:3)];
end
savePath = [saveDir filesep saveFileName saveFileExt];

assert(islogical(openImg) && numel(openImg) == 1,...
    'getGoogleMap:openImgChk',...
    'Optional argument "openImg" must be a 1 x 1 logical.')

% Check ouptput arguments
if ~locationIsLatLon
    assert(nargout <= 1,...
        'getGoogleMap:nargoutChk',...
        'If "location" is a string the number of output arguments must be less than or equal to 2.')
end

%% Build URL string
if locationIsLatLon
    centerStr = [sprintf('%3.6f',location(1)) ',' sprintf('%3.6f',location(2))];
else
    centerStr = urlencode(location);
end
urlStr = ['http://maps.google.com/maps/api/staticmap?'...
    'center=' centerStr '&'...
    'maptype=' mapType '&'...
    'zoom=' num2str(zoomLevel) '&'...
    'size=' num2str(imgSize(1)) 'x' num2str(imgSize(2)) '&'...
    'format=' imgFormat '&'...
    'sensor=false'];

%% Download and save image
if ~saveFlag
    try
        [img map] = imread(urlStr);
    catch exceptionBase
        exceptionAdd = MException('getGoogleMap:download','Unable to download file: %s.\nCheck Matlab proxy settings.',urlStr);
        exception = addCause(exceptionBase,exceptionAdd);
        throw(exception)
    end
else
    [~,status] = urlwrite(urlStr,savePath);
    assert(status == 1,'getGoogleMap:urlwriteChk','Unable to download file: %s.\nCheck Matlab proxy settings.',urlStr)
    [img map] = imread(savePath);
end


%% Convert image
switch imgFormat
    case {'png','png8','gif'}
        img = cast(img,'double') + 1;
        imgVec = map(img(:),:);
        imgR = reshape(imgVec(:,1),size(img,1),size(img,2));
        imgG = reshape(imgVec(:,2),size(img,1),size(img,2));
        imgB = reshape(imgVec(:,3),size(img,1),size(img,2));
        img = cat(3,imgR,imgG,imgB);
    case {'png32','jpg','jpg-baseline'}
        img = cast(img,'double');
        img = img/255;     
end

%% Create reference matrix
% To form the reference matrix the image pixel have to translated into lat, long
% coordinates. This is done by knowing that Google uses a Mercator
% projection onto a coordinate plane defined by pixels. The number of
% pixels in this plane is eqaul to 2^zoomLevel*256 x 2^zoomLevel*256.
% More information including projection equations can be found on
% Wikipedia: http://en.wikipedia.org/wiki/Mercator_projection

if locationIsLatLon
    lat = location(1);
    lon = location(2);
    sizeX = imgSize(1);
    sizeY = imgSize(2);
    
    radiusInPixels = 2^zoomLevel*256/(2*pi);
    
    % Longitude limits of image
    lonPixel = deg2rad(lon)*radiusInPixels;
    lonPixelLim = lonPixel+[-sizeX/2,sizeX/2];
    lonLim = rad2deg(lonPixelLim/radiusInPixels);
    
    % Latitude limits of image
    latPixel = log(tan(pi/4+deg2rad(lat)/2))*radiusInPixels;
    latPixelLim = latPixel+[-sizeY/2,sizeY/2];
    latLim = rad2deg(2*atan(exp(latPixelLim/radiusInPixels))-pi/2);
    
    refMat = makerefmat('RasterSize',size(img),'Latlim', latLim,'Lonlim', lonLim,'ColumnsStartFrom','north');
end

%% Open image
if openImg && saveFlag
    if ispc
        winopen(savePath)
    else
        system(['open ' savePath]);
    end
end

%% Clear output variables
if nargout == 0
    clear img refMat latLim lonLim
end

end
