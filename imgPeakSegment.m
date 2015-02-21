function [L,nLabels] = imgPeakSegment(img,varargin)
% The "imgPeakSegment" function segments an image into a labeled
% image based on peaks in the image intensity.
%
% SYNTAX:
%   L = imgPeakSegment(img)
%   L = imgPeakSegment(img,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   img - (n x m) 
%       Intensity image.
%
% PROPERTIES:
%   'connection' - (string) ['4-way']
%       Type of connection. '4-way' or '8-way'
% 
% OUTPUTS:
%   L - (n x m integer) 
%       Labeled image.
%
%   nLabels - (1 x 1 integer)
%       Number of labeled segements in the image.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    imgBinarySegment | imgBinaryDist2Edge
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 21-FEB-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,3)

% Check input arguments for errors
assert(isnumeric(img) && isreal(img) && numel(size(img)) == 2 ,...
    'imgBinarySegment:img',...
    'Input argument "img" must be a n x m matrix of numbers.')
[n,m] = size(img);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,...
    'imgBinarySegment:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('connection')
            connection = propValues{iParam};
        otherwise
            error('imgBinarySegment:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('connection','var'), connection = '4-way'; end

% Check property values for errors
assert(ischar(connection) && ismember(connection,{'4-way','8-way'}),...
    'imgBinarySegment:connection',...
    'Property "connection" must be a either ''4-way'' or ''8-way''.');

% 4 way connect offset
if strcmp(connection,'4-way')
    ox = [-1  1  0  0];
    oy = [ 0  0 -1  1];
else
    ox = [-1 -1 -1  1  1  1  0  0];
    oy = [-1  0  1 -1  0  1 -1  1];
end

%% Run
L = nan(n,m);
l = 0;

imgPeak = img;

while any(isnan(L(:)));
    % Find next highest peak
    [~,inds] = max(imgPeak(:));
    
    % Label
    l = l + 1;
    L(inds) = l;

    while ~isempty(inds)
        % Set pixel to -inf
        imgPeak(inds) = -inf;
        
        % Get all connected neighbors
        indsTemp = inds;
        binaryImg = false(n,m);
        for ind = indsTemp'
            [ix,iy] = ind2sub([n,m],ind);
            ix = bsxfun(@plus,ix,ox);
            ix = ix(:);
            iy = bsxfun(@plus,iy,oy);
            iy = iy(:);
            
            % Remove inds that are out of bounds
            ix1 = ix(ix >= 1 & ix <= n & iy >= 1 & iy <= m);
            iy1 = iy(ix >= 1 & ix <= n & iy >= 1 & iy <= m);
            indsSubset = sub2ind([n,m],ix1,iy1);
            
            % Keep only pixels that equal or lower
            binaryImg(indsSubset(img(indsSubset) <= img(ind))) = true;
        end
        % Convert bineary to indices
        inds = find(binaryImg);
        
        % Keep only inds that have not been labeled
        indsKeep  = inds(isnan(L(inds)));
        
        % Label pixel that have been labeled something different before as 0
        L(inds(~isnan(L(inds)) & L(inds) ~= l)) = 0;
        
        % Label other pixels with label
        L(inds(isnan(L(inds)))) = l;
        
        % Set new inds
        inds = indsKeep;
    end
end

nLabels = max(L(:));

end
