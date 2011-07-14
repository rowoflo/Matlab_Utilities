function [k,theta] = axisAngRep(R)
% The "axisAngRep" function outputs the axis angle representation of the
% rotation matrix "R".
%
% USAGE:
%   [k,theta] = axisAngRep(R)
% 
% INPUTS:
%   input1 - (3 x 3 number (rotation matrix, SO(3))) 
%       Description.
% 
% OUTPUTS:
%   k - (3 x 1 number) 
%       Axis of rotation
%
%   theta - (1 x 1 number)
%       Angle of rotation in radians.
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%   Several axis angle representations can be done at once by packaging the
%   rotation matrices up into cells.
%
%   Numbers in "R" that are smaller or equal to 100*eps are rounded to zero.
%
% NECESSARY FILES:
%   isrealnumber.m, smallToZero.m
%
% SEE ALSO:
%    rotRep, HGRep, HGRepI, skewSym
%
% REVISION:
%   1.0 03-DEC-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(1,1,nargin))

if iscell(R)
    cellFlag = true;
else
    cellFlag = false;
    R = {R};
end

% Loop through each cell
[k,theta] = cellfun(@cellLoop,R,'UniformOutput',false);

    function [thisK,thisTheta] = cellLoop(thisR)
        % Check R input for errors
        assert(issize(thisR,3,3) && isrot(thisR),...
            'model:axisAngRep:RChk1',...
            '"R" must be a 3 x 3 rotational matrix') 
        
        r11 = thisR(1,1);
        r12 = thisR(1,2);
        r13 = thisR(1,3);
        r21 = thisR(2,1);
        r22 = thisR(2,2);
        r23 = thisR(2,3);
        r31 = thisR(3,1);
        r32 = thisR(3,2);
        r33 = thisR(3,3);
        
        thisTheta = acos((r11+r22+r33-1)/2);
        thisK = 1/(2*sin(thisTheta))*[r32-r23;r13-r31;r21-r12];
        
    end

if ~cellFlag
    theta = theta{:};
    k = k{:};
end

end
