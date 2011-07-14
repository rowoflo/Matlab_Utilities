function [elevation,lat,lon] = getGoogleElevation(locations)
% The "getGoogleElevation" function elevation information for the specified
% points from Google.
%
% USAGE:
%   elevation = getGoogleElevation(locations)
%
% INPUTS:
%   locations - (? x 2 number)
%       Latitude and longitude locations for the points that will get
%       elevation data for.
%
% OUTPUTS:
%   elevation - (? x 1 number)
%       Mean sea level elevations for each lat long pair of points.
%
%   lat - (? x 1 number)
%       Latitude that Google used to get the associated elevation value.
%
%   lon - (? x 1 number)
%       Longitude that Google used to get the associated elevation value.
%
% DESCRIPTION:
%   This function uses Google's Maps Elevation Web Services to grab
%   elevation data for a given set of latitudes and longitude points. These
%   are the same values you get from Google Earth.
%
% EXAMPLES:
%   lat = 38+linspace(0,.01,50)';
%   lon = -120+linspace(0,.01,50)';
%   [elevation,latOut,lonOut] = getGoogleElevation([lat lon]);
%
% NOTES:
%   See http://code.google.com/apis/maps/documentation/elevation/ for more
%   information on the Google Maps Elevation Web Service.
%
%   Google puts a limit of 25,000 request per day.
%
% NECESSARY FILES:
%
% SEE ALSO:
%   getGoogleMap
%
% REVISION:
%   1.0 13-MAY-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

%% Check number of inputs
error(nargchk(1,1,nargin))

% Check input arguments for errors
assert(isnumeric(locations) && isreal(locations) && (size(locations,2) == 2 || size(locations,1) == 2),...
    'getGoogleElevation:locationsChk',...
    'Input argument "locations" must be a ? x 2 matrix of real numbers.')
if size(locations,1) == 2 && size(locations,1) < size(locations,2)
    locations = locations';
end


%% Build URL
nLocations = size(locations,1);
locationPerCallLimit = 5;
nCalls = ceil(nLocations/locationPerCallLimit);

lat = zeros(nLocations,1);
lon = zeros(nLocations,1);
elevation = zeros(nLocations,1);

for iCall = 1:nCalls
    urlStr = 'http://maps.google.com/maps/api/elevation/xml?sensor=false&locations=';
    
    if iCall ~= nCalls
        thisNLocations = locationPerCallLimit;
    else
        thisNLocations = mod(nLocations,locationPerCallLimit);
    end
    for iLoc = 1:thisNLocations
        aLatStr = sprintf('%3.6f',locations((iCall-1)*locationPerCallLimit+iLoc,1));
        aLonStr = sprintf('%3.6f',locations((iCall-1)*locationPerCallLimit+iLoc,2));
        if iLoc ~= thisNLocations
            urlStr = [urlStr aLatStr ',' aLonStr '|']; %#ok<*AGROW>
        else
            urlStr = [urlStr aLatStr ',' aLonStr];
        end
    end
    xmlStr = urlread(urlStr);
    
    %% Parse XML
    statusCellStr = regexp(xmlStr,'(?<=<status>).*?(?=</status>)','match');
    assert(strcmp(statusCellStr{1},'OK'),...
        'getGoogleElevation:statusChk',...
        'Invalid request. Check latituted-longitude points.\nLatitudes must be between -90 and 90 and longitudes must between -180 and 180.')
    
    latCellStrs = regexp(xmlStr,'(?<=<lat>).*?(?=</lat>)','match');
    lonCellStrs = regexp(xmlStr,'(?<=<lng>).*?(?=</lng>)','match');
    elevationCellStrs = regexp(xmlStr,'(?<=<elevation>).*?(?=</elevation>)','match');
    
    lat((iCall-1)*locationPerCallLimit+(1:thisNLocations)) = cellfun(@str2num,latCellStrs)';
    lon((iCall-1)*locationPerCallLimit+(1:thisNLocations)) = cellfun(@str2num,lonCellStrs)';
    elevation((iCall-1)*locationPerCallLimit+(1:thisNLocations)) = cellfun(@str2num,elevationCellStrs)';
end

end
