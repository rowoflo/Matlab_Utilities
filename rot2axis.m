function [e,theta] = rot2axis(R)
% The "rot2euler" function converts a rotation matrix to a axis/angle
% representation.
%
% SYNTAX:
%   [e,theta] = rot2axis(R)
%
% INPUTS:
%   R - (3 x 3 x N number)
%       A standard rotation matrix that is in SO(3).
%
% OUTPUTS:
%   e - (3 x 1 number)
%       Axis of rotation. Magnitude equals angle of rotation.
%
%   theta - (1 x 1 number)
%       Angle of rotation.
%
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
%
% NECESSARY FILES:
%
% SEE ALSO:
%    quat2rot | rot2quat | euler2quat | quat2euler | euler2rot
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 02-FEB-2015
%
%--------------------------------------------------------------------------

% Check number of arguments
narginchk(1,1)

theta = acos((R(1,1)+R(2,2)+R(3,3)-1)/2);
if (theta == 0)
    e = zeros(3,1);
else
    e = theta/(2*sin(theta))*[R(3,2)-R(2,3);R(1,3)-R(3,1);R(2,1)-R(1,2)];
end

end