function kmlStr = ge_track(time,lat,lon,varargin)
% DESCRIPTION:
%   The "ge_track" function is a Google Earth Toolbox fuction that creates
%   KML strings for track data.
%
% SYNTAX:
%   kmlStr = ge_track(time,lat,lon)
%   kmlStr = ge_track(time,lat,lon,alt)
%   kmlStr = ge_track(time,lat,lon,'parameterName',parameterValue)
%   kmlStr = ge_track(time,lat,lon,alt,'parameterName',parameterValue)
% 
% INPUTS:
%   time - (1 x ? number)
%       Vector of time values.
%
%   lat - (1 x ? number)
%       Vector of latitude values.
%
%   lon - (1 x ? number)
%       Vector of longitude values.
%
%   alt - (1 x ? number or 1 x 1 number) [ [] ]
%       Vector of altitude values. If constant the same value is used
%       across all time points. If empty 'altitudeMode' is set to
%       'clampToGround'.
%
% PARAMETERS:
%   'timeMode' - ('dateNum') ['dateNum']
%       Specifies how to interpret time values. 'dateNum' is Matlab's
%       serial date number.
%
%   'altitudeMode' - ('absolute', 'relativeToGround' or 'clampToGround')
%   ['relativeToGround']
%       Specifies how to interpret altitude values. 'absolute' is in
%       reference to MSL, 'relativeToGround' is in reference to Google
%       Earth elevation ground data, 'clampToGround' ignores altitude
%       information and is always ground level.
%
%   'name' - (string) ['']
%       Name of track used in Google Earth Viewer.
%
%   'description' - (string) ['']
%       A description of the object can be included using this parameter.
%       Its value must be passed as a character array. Including a
%       description will cause a text balloon to pop up from the map at the
%       object's location. This balloon contains the character array
%       included in 'description'.
%
%   'snippet' - (string) ['']
%       A short description of the feature. In Google Earth, this description
%       is displayed in the Places panel under the name of the feature.
%
%   'lineColor' - (string) ['#FF000000']
%       Line color specification, including transparency. Color value
%       format must be passed as a character array according to the format
%       string '#TTBBGGRR', with 'TT' representing transparency; 'RR',
%       'GG', and 'BB' representing red, green, and blue colors,
%       respectively. Intensity values are denoted as two-digit hexadecimal
%       numbers ranging from 00 to FF. For example, '#0000FF00' is fullly
%       transparent green and '#FF0000FF' is fully opaque red.
%
%   'lineWidth' - (1 x 1 positive number) [3]
%       Line width specification.
%
%   'visibility' - (1 x 1 logical) [true]
%       Defines whether the object is visible.
%
%   'extendedData' - (? x 2 cell array) [ [] ]
%       Used to add exteneded data associated with each time/position on
%       the track. This data is shown along side elevation and speed data
%       in the elevation profile in Google Earth. Each row of the cell
%       array is a different set of data. The 1st column is the name of the
%       data (the name displayed in the elevation profile) and must be a
%       string. The 2nd column is the data and must be a vector with same
%       the number of elements as the time/position points in the track.
% 
% OUTPUTS:
%   kmlStr - (string) 
%       String used in KML file.
%
% EXAMPLES:
%     nPoints = 50;
%     time = linspace(734560,734560+180/86400,nPoints);
%     lat = [linspace(42.352056,42.357071,nPoints/2) linspace(42.357071,42.360541,nPoints/2)];
%     lon = [linspace(-71.08992,-71.092374,nPoints/2) linspace(-71.092374,-71.081885,nPoints/2)];
%     heartRate = [linspace(130,130,nPoints/2) linspace(130,170,nPoints/2)];
%     
%     kmlStr = ge_track(time,lat,lon,...
%         'name','Nice Ride',...
%         'lineColor','#FF0000FF',...
%         'lineWidth',10,...
%         'extendedData',{'Heart Rate',heartRate});
%     ge_output('bikeRide.kml',kmlStr,'name','Around The Charles')
%
% NOTES:
%   If it doesn't work update line 32 of ge_output.m file with these lines:
%   <kml xmlns="http://www.opengis.net/kml/2.2"
%    xmlns:gx="http://www.google.com/kml/ext/2.2">
%
%   For information on many of the fields see:
%   http://code.google.com/apis/kml/documentation/mapsSupport.html
%
%   Parameters note yet included in this function are 'angle' and 'model'.
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% REVISION:
%   1.0 19-NOV-2010 by Rowland O'Flaherty
%       Initial Revision.
%
%-------------------------------------------------------------------------------

%% Check inputs

% Check number of inputs
error(nargchk(3,inf,nargin))

% Apply default values
if nargin < 4, alt = []; end

% Organize input
if ~isempty(varargin)
    if ischar(varargin{1})
        alt = [];
    else
        alt = varargin{1};
        varargin = varargin(2:end);
    end
end

% Check input arguments for errors
assert(isnumeric(time) && isreal(time) && isvector(time),...
    'ge_track:time',...
    'Input argument "time" must be a vector of real numbers.')
time = time(:)';
nTimes = length(time);

assert(isnumeric(lat) && isreal(lat) && isvector(lat) && length(lat) == nTimes,...
    'ge_track:lat',...
    'Input argument "lat" must be a 1 x %d of real numbers.',nTimes)
lat = lat(:)';

assert(isnumeric(lon) && isreal(lon) && isvector(lon) && length(lon) == nTimes,...
    'ge_track:lon',...
    'Input argument "lon" must be a 1 x %d of real numbers.',nTimes)
lon = lon(:)';

assert((isnumeric(alt) && isreal(alt) && isvector(alt) && (length(alt) == nTimes || length(alt) == 1)) || isempty(alt),...
    'ge_track:alt',...
    'Input argument "alt" must be a 1 x 1 or 1 x %d of real numbers or empty.',nTimes)

% Get and check parameters
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'ge_track:options',...
    'Options must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case lower('timeMode')
            timeMode = optValues{iParam};
        case lower('altitudeMode')
            altitudeMode = optValues{iParam};
        case lower('name')
            name = optValues{iParam};
        case lower('description')
            description = optValues{iParam};
        case lower('snippet')
            snippet = optValues{iParam};
        case lower('lineColor')
            lineColor = optValues{iParam};
        case lower('lineWidth')
            lineWidth = optValues{iParam};
        case lower('visibility')
            visibility = optValues{iParam};
        case lower('extendedData')
            extendedData = optValues{iParam};
        otherwise
            error('ge_track:options','Option string ''%s'' is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
timeModeList = {'dateNum'};
if ~exist('timeMode','var'), timeMode = 'dateNum'; end
altitudeModeList = {'absolute','relativeToGround','clampToGround'};
if ~exist('altitudeMode', 'var'), altitudeMode = 'relativeToGround'; end
if ~exist('name', 'var'), name = ''; end
if ~exist('description', 'var'), description = ''; end
if ~exist('snippet','var'), snippet = ''; end
if ~exist('lineColor', 'var'), lineColor = '#FF000000'; end
if ~exist('lineWidth', 'var'), lineWidth = 3; end
if ~exist('visibility', 'var'), visibility = true; end
if ~exist('extendedData', 'var'), extendedData = []; end

% Set altitude input and parameter
if isempty(alt)
    altitudeMode = 'clampToGround';
    alt = zeros(1,nTimes);
elseif length(alt) == 1
    alt = alt*ones(1,nTimes);
else
    alt = alt(:)';
end

% Check parameter arguments for errors
tmp = cellfun(@(elem) ['''' elem ''', '], timeModeList, 'UniformOutput', false);
assert(ischar(timeMode) && ismember(timeMode,timeModeList),...
    'ge_track:timeMode',...
    'Parameter argument "timeMode" must be a member of this list {%s}.',sprintf('%s',tmp{:}))

tmp = cellfun(@(elem) ['''' elem ''', '],altitudeModeList,'UniformOutput',false);
assert(ischar(altitudeMode) && ismember(altitudeMode,altitudeModeList),...
    'ge_track:altitudeMode',...
    'Parameter argument "altitudeMode" must be a member of this list {%s}.',sprintf('%s',tmp{:}))

assert(ischar(name),...
    'ge_track:name',...
    'Parameter argument "name" must be a string.')

assert(ischar(description),...
    'ge_track:description',...
    'Parameter argument "description" must be a string.')

assert(ischar(snippet),...
    'ge_track:snippet',...
    'Parameter argument "snippet" must be a string.')

assert(ischar(lineColor) && length(lineColor) == 9 && lineColor(1) == '#' && all(ismember(lineColor,'0123456789AaBaCcDdEeFf#')),...
    'ge_track:lineColor',...
    'Parameter argument "lineColor" must 8 digit hexidecimal representation of RGB and transparency (T B G R order 2 digits each) starting with a ''#''. Example ''#FF0000FF'' for opaque red.')
lineColor = upper(lineColor);

assert(isnumeric(lineWidth) && lineWidth > 0,...
    'ge_track:lineWidth',...
    'Parameter argument "lineWidth" must be a postive number.')
lineWidth = sprintf('%.2f',lineWidth);

assert((islogical(visibility) || ismember(visibility,[0 1])) && numel(visibility) == 1,...
    'ge_track:visibility',...
    'Parameter argument "visibility" must be a 1 x 1 logical.')
visibility = num2str(visibility);

assert((iscell(extendedData) && size(extendedData,2) == 2) || isempty(extendedData),...
    'ge_track:extendedData',...
    'Parameter argument "extendedData" must be a cell array with two columns.')
if isempty(extendedData)
    extendedDataFlag = false;
else
    extendedDataFlag = true;
    nSets = size(extendedData,1);
    for iSet = 1:nSets
        setName = extendedData{iSet,1};
        setData = extendedData{iSet,2};
        
        assert(ischar(setName),...
            'ge_track:setName',...
            'In the parameter argument "extendedData" the first column''s elements must be all strings.')
        
        assert(isnumeric(setData) && isreal(setData) && isvector(setData) && length(setData) == nTimes,...
            'ge_track:setData',...
            'In the parameter argument "extendedData" the second column''s elements must be all 1 x %d vectors. The data associated with the name ''%s'' is not correct.',nTimes,setName)
        extendedData{iSet,2} = extendedData{iSet,2}(:)';
    end
end

%% Make coordinate string
whenStr = [];
coordStr = [];
for iTime = 1:nTimes
    switch timeMode
        case 'dateNum'
            timeStr = datestr(time(iTime),'yyyy-mm-ddTHH:MM:SS.FFF');
    end
    whenStr = [whenStr...
        '       <when>',timeStr,'</when>' 10]; %#ok<*AGROW>
    
    latLonAltStr = sprintf('%3.6f %3.6f %3.6f',lon(iTime),lat(iTime),alt(iTime));        
    coordStr = [coordStr...
        '       <gx:coord>',latLonAltStr,'</gx:coord>' 10];
end

%% Make schema string
schemaStr = [];
if extendedDataFlag
    for iSet = 1:nSets
        schemaStr = [schemaStr,...
            '   <gx:SimpleArrayField name="',lower(strrep(extendedData{iSet,1},' ','_')),'" type="float">',10,...
            '       <displayName>',extendedData{iSet,1},'</displayName>',10,...
            '   </gx:SimpleArrayField>',10];
            
    end
else
    schemaStr = '';
end

%% Make extended data string
extDataStr = [];
if extendedDataFlag
    for iSet = 1:nSets
        extDataStr = [extDataStr,...
            '           <gx:SimpleArrayData name="',lower(strrep(extendedData{iSet,1},' ','_')),'">',10];
        for iTime = 1:nTimes
            dataStr = sprintf('%.2f',extendedData{iSet,2}(iTime));
            extDataStr = [extDataStr,...
                '               <gx:value>',dataStr,'</gx:value>',10];
        end
        extDataStr = [extDataStr,...
            '           </gx:SimpleArrayData>',10,...
            ]; 
    end
else
    extDataStr = '';
end

%% Build KML string
kmlStr = [...
    '<Schema id="schema">',10,...
    schemaStr,...
    '</Schema>',10,...
    '<Placemark id="track">',10,...
    '   <name>',name,'</name>',10,...
    '   <description><![CDATA[',description,']]></description>',10,...
    '   <Snippet>',snippet,'</Snippet>',10,...
    '   <visibility>',visibility,'</visibility>',10,...
    '   <Style>',10,...
    '       <LineStyle>',10,...
    '           <color>',lineColor,'</color>',10,...
    '           <width>',lineWidth,'</width>',10,...
    '       </LineStyle>',10,...
    '   </Style>',10,...
    '   <gx:Track>',10,...
    '       <altitudeMode>',altitudeMode,'</altitudeMode>',10,...
    whenStr...
    coordStr...
    '       <ExtendedData>',10,...
    '           <SchemaData schemaUrl="#schema">',10,...
    extDataStr,...
    '           </SchemaData>',10,...
    '       </ExtendedData>',10,...
    '   </gx:Track>',10,...
    '</Placemark>',10,...
    ];



end
