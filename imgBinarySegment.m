function [L,nLabels] = imgBinarySegment(img,varargin)
% The "imgBinarySegment" function segments a binary image into a labeled
% image.
%
% SYNTAX:
%   L = imgBinarySegment(img)
%   L = imgBinarySegment(img,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   img - (n x m {0,1}) 
%       Binary image.
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
%    imgBinaryDist2Edge | imgPeakSegment
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 20-FEB-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,3)

% Check input arguments for errors
assert((isnumeric(img) || islogical(img)) && isreal(img) && numel(size(img)) == 2 ,...
    'imgBinarySegment:img',...
    'Input argument "img" must be a n x m matrix of logicals.')
img = logical(img);
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
L = zeros(n,m);
l = 0; % label index

while any(img(:))
    % Iterate
    l = l + 1;
    
    % Find foreground pixel
    inds = find(img,1,'first');
    while ~isempty(inds)
        % Label
        L(inds) = l;
       
        % Set pixel to zero
        img(inds) = 0;
        
        % Find all connected neighbors
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
    end
end

nLabels = max(L(:));
end
