function HG = HGRep(point,rot)
% The "HGRep" function outputs the homogeneous representation of a point or
% of a coordinate system.
%
% USAGE:
%   HG = HGRep(point,[rot])
%
% INPUTS:
%   point - (3 x 1 number)
%       Either a point or the orgin of the coordinate system in 3D space.
%
%   [rot] - (3 x 3 number)
%       Rotation of the coordinate system in 3D space. Also known as the
%       direction cosine matrix (DCM).
%
% OUTPUTS:
%   HG - (4 x 1 or 4 x 4 number)
%       The homogeneous representation of the either a point or
%       a coordinate system.
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%   Several homogeneous representations can be done at once by packaging
%   the points and/or coordinate systems up into cells.
%
% NECESSARY FILES:
%   isrealnumber.m
%
% SEE ALSO:
%    HGRepI, skewSym, axisAngRep, rotRep,
%
% REVISION:
%   1.0 29-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,2,nargin))

if iscell(point)
    cellFlag = true;
else
    cellFlag = false;
    point = {point};
end

if nargin == 1 % Homogeneous representation of a point
    
    % Check point input for errors
    assert(all(cell2mat(isrealnumber(point,3))),'model:HGRep:pointChk','"point" must be a 3 x 1 real number')
    
    HG = cellfun(@(p) [p;1],point,'UniformOutput',false);
    
elseif nargin == 2 % Homogeneous representation of a coordinate system
    if ~cellFlag
        rot = {rot};
    end
    
    % Check rot input for errors
    assert(all(cell2mat(isrealnumber(rot,3,3))),'model:HGRep:rotChk','"rot" must be a 3 x 3 real number')
    
    % Check that the cell sizes match
    assert(isequal(size(point),size(rot)),'model:HGRep:cellSizeChk','"point" and "rot" cells must be of the same size')
    
    HG = cellfun(@cellLoop,point,rot,'UniformOutput',false);
end

if ~cellFlag
    HG = HG{:};
end

end

function thisHG = cellLoop(thisPoint,thisRot)
thisHG = [[thisRot;zeros(1,3)] [thisPoint;1]];
end
