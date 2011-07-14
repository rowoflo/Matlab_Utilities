function [point,rot] = HGRepI(HG)
% The "HGRepI" function returns the inverse of the HGRep function.
%
% USAGE:
%   [point,rot] = HGRepI(HG)
% 
% INPUTS:
%   HG - (4 x 1 or 4 x 4 number)
%       The homogeneous representation of the either the point or
%       a coordinate system.
% 
% OUTPUTS:
%   point - (3 x 1 number)
%       Either a point or the orgin of the coordinate system in 3D space.
%
%   [rot] - (3 x 3 number)
%       Rotation of the coordinate system in 3D space. Also known as the
%       direction cosine matrix (DCM).
%
% DESCRIPTION:
%   Homogeneous representations are 4 x 4 matrices where the upper left
%   corner is a rotation matrix and the lower row is [0 0 0 1]. A
%   homogeneous point is 4 x 1 vector that where the last element is equal
%   to one.
%
% EXAMPLES:
%
% NOTES:
%   Several homogeneous representations inverses can be done at once by
%   packaging homogeneous representations up into cells.
%
% NECESSARY FILES:
%   isrealnumber.m
%
% SEE ALSO:
%    HGRep, skewSym, axisAngRep, rotRep
%
% REVISION:
%   1.0 01-DEC-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,1,nargin))

if iscell(HG)
    cellFlag = true;
else
    cellFlag = false;
    HG = {HG};
end

% Loop through each cell
[point,rot] = cellfun(@cellLoop,HG,'UniformOutput',false);

    function [thisPoint,thisRot] = cellLoop(thisHG)
        % Check HG input for errors
        assert(isrealnumber(thisHG,4,1) || isrealnumber(thisHG,4,4),...
            'model:HGRepI:HGChk1','"HG" must be a 4 x 1 or 4 x 4 real number (if cell all must cell must be the same type)')
        
        if isvector(thisHG) % Convert vector
            % Check vector
            assert(thisHG(4,1) == 1,...
                'model:HGRepI:HGChk2','Invalid homogeneous point representation')

            thisPoint = thisHG(1:3,1);
            thisRot = [];
        
        else % Convert matrix
            % Check matrix
            assert(isrot(thisHG(1:3,1:3)) && isequal(thisHG(4,1:4),[0 0 0 1]) ,...
                'model:HGRepI:HGChk3','Invalid homogeneous matrix representation')
            
            thisPoint = thisHG(1:3,4);
            thisRot = thisHG(1:3,1:3);

        end

    end

if ~cellFlag
    point = point{:};
    rot = rot{:};
end

end
