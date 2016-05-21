function rot = euler2rot(euler)
% The "euler2rot" function converts Euler angles to a rotation
% matrix.
%
% SYNTAX:
%   q = euler2quat(euler)
%
% INPUTS:
%   euler - (3 x 1 number) 
%       Euler angles [phi;theta;psi].
%
% OUTPUTS:
%   rot - (3 x 3 number)
%       A standard rotation matrix that is in SO(3).
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
%
% NECESSARY FILES:
%
% SEE ALSO:
%    quat2rot | rot2quat | euler2quat | quat2euler | rot2euler
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

rot = quat2rot(euler2quat(euler));

end
