function [path,inds,dist] = shortestPath(points,startInd)
% The "shortestPath" function simple recursive algorithm to solve traveling
% salesman problem
%
% SYNTAX:
%   output = shortestPath(points)
%   output = shortestPath(points, startInd)
% 
% INPUTS:
%   points - (2 x n numbers) 
%       List of points. n <= 9
%
%   startInd - (1 x 1 integer) [1] 
%       Index of starting point.
% 
% OUTPUTS:
%   path - (2 x n number)
%       Shortest path.
%
%   inds - (1 x n integer)
%       Indice values into points vector of shortest path.
%
%   dist - (1 x 1 number)
%       Length of path.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 21-FEB-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,2)

% Apply default values
if nargin < 2, startInd = 1; end

% Check input arguments for errors
assert(isnumeric(points) && isreal(points) && size(points,1) == 2,...
    'shortestPath:points',...
    'Input argument "points" must be a 2 x n matrix of real numbers.')
n = size(points,2);

assert(n <= 9,...
    'shortestPath:points',...
    'Algorithm takes too long for large number of points. Reduce number of points.')

assert(isnumeric(startInd) && isreal(startInd) && numel(startInd) == 1 && ...
    mod(startInd,1) == 0 && startInd >= 1 && startInd <= n,...
    'shortestPath:startInd',...
    'Input argument "startInd" must be a positive integer between 1 and %d.',n)

%% Calculate
if n == 1
    path = points;
    inds = startInd;
    dist = 0;
elseif n == 2
    dist = norm(points(:,1) - points(:,2));
    if startInd == 1
        path = points;
        inds = 1:2;
    else
        path = [points(:,2) points(:,1)];
        inds = [2 1];
    end
else
    [path,inds,dist] = shortestPathDist(points,startInd);
end

end

function [path,inds,dist] = shortestPathDist(points,startInd)
n = size(points,2);
if n > 3
    % Remove start point
    inds = 1:n;
    startPoint = points(:,startInd);
    points = points(:,~(startInd == 1:n));
    inds = inds(:,~(startInd == inds));
    n = n-1;

    % Find dist to go from each other point
    pathList = cell(1,n);
    indsList = cell(1,n);
    distList = nan(1,n);
    for k = 1:n
        [p,i,d] = shortestPathDist(points,k);
        pathList{k} = p;
        indsList{k} = i;
        distList(k) = d + norm(startPoint - pathList{k}(:,1));
    end   
    [~,k] = min(distList);
    path = [startPoint pathList{k}];
    inds = [startInd inds(indsList{k})];
    dist = distList(k);
else
    inds = 1:3;
    startPoint = points(:,startInd);
    points = points(:,~(startInd == inds));
    inds = inds(:,~(startInd == inds));
    point1 = points(:,1);
    ind1 = inds(:,1);
    point2 = points(:,2);
    ind2 = inds(:,2);
    
    % Dist between non-start points
    d = norm(point1 - point2);
    
    % Route 1
    d1 = norm(startPoint - point1);
    
    % Route 2
    d2 = norm(startPoint - point2);
    
    if d1 <= d2
        dist = d + d1;
        inds = [startInd ind1 ind2];
        path = [startPoint point1 point2];
    else
        dist = d + d2;
        inds = [startInd ind2 ind1];
        path = [startPoint point2 point1];
    end
end
end