function D = imgBinaryDist2Edge(img,varargin)
% The "imgBinaryDist2Edge" function returns a matrix of the distances to
% the edges of the binary input image.
%
% SYNTAX: TODO: Add syntax
%   D = imgBinaryDist2Edge(img)
%   D = imgBinaryDist2Edge(img,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   img - (n x m {0,1}) 
%       Binary image
%
% PROPERTIES:
%   'connection' - (string) ['4-way']
%       Type of connection. '4-way' or '8-way'
%
%   'imgEdge' - (string) [false]
%       If the edge image should be included as an edge.
% 
% OUTPUTS:
%   D - (n x m integer) 
%       Distance matrix.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    imgBinarySegment | imgPeakSegment
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 20-FEB-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,5)

% Check input arguments for errors
assert((isnumeric(img) || islogical(img)) && isreal(img) && numel(size(img)) == 2 ,...
    'imgBinaryDist2Edge:img',...
    'Input argument "img" must be a n x m matrix of logicals.')
img = logical(img);
[n,m] = size(img);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,...
    'imgBinaryDist2Edge:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('connection')
            connection = lower(propValues{iParam});
        case lower('imgEdge')
            imgEdge = propValues{iParam};
        otherwise
            error('imgBinaryDist2Edge:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('connection','var'), connection = '4-way'; end
if ~exist('imgEdge','var'), imgEdge = false; end

% Check property values for errors
assert(ischar(connection) && ismember(connection,{'4-way','8-way'}),...
    'imgBinaryDist2Edge:connection',...
    'Property "connection" must be a either ''4-way'' or ''8-way''.');

assert(islogical(imgEdge) && numel(imgEdge) == 1,...
    'imgBinaryDist2Edge:imgEdge',...
    'Property "imgEdge" must be a 1 x 1 logical.');

% 4 way connect offset
if strcmp(connection,'4-way')
    ox = [-1  1  0  0];
    oy = [ 0  0 -1  1];
else
    ox = [-1 -1 -1  1  1  1  0  0];
    oy = [-1  0  1 -1  0  1 -1  1];
end

% Border image if imgEdge is true
if imgEdge
    img = [false(n+2,1) [false(1,m); img; false(1,m)] false(n+2,1)];
    [n,m] = size(img);
end

%% Run
D = zeros(n,m);
d = 0;

% Find edge pixels
imgD1 = diff(img,1,1);
imgD2 = diff(img,1,2);
imgE1 = [zeros(1,m); imgD1 == -1] | [imgD1 == 1; zeros(1,m)];
imgE2 = [zeros(n,1) imgD2 == -1] | [imgD2 == 1 zeros(n,1)];
inds = find(imgE1 | imgE2);

while ~isempty(inds)
    % Set distance
    D(inds) = d;
    
    % Set pixel to zero
    img(inds) = 0;
    
    % Find all non-zero connected neighbors
    [ix,iy] = ind2sub([n,m],inds);
    ix = bsxfun(@plus,ix,ox);
    ix = ix(:);
    iy = bsxfun(@plus,iy,oy);
    iy = iy(:);
    
    % Remove inds that are out of bounds
    ix1 = ix(ix >= 1 & ix <= n & iy >= 1 & iy <= m);
    iy1 = iy(ix >= 1 & ix <= n & iy >= 1 & iy <= m);
    inds = sub2ind([n,m],ix1,iy1);
    
    % Remove dublicates
    inds = unique(inds);
    
    % Keep non-zero inds
    inds = inds(img(inds));
    
    % Increment distance
    d = d + 1;
end

% Remove border if imgEdge is true
if imgEdge
    D = D(2:end-1,2:end-1);
end

end
