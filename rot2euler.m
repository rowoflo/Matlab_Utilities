function euler = rot2euler(R)
% The "rot2euler" function converts a rotation matrix to a Euler angles.
%
% SYNTAX:
%   euler = rot2euler(R)
%
% INPUTS:
%   R - (3 x 3 x N number)
%       A standard rotation matrix that is in SO(3).
%
% OUTPUTS:
%   euler - (3 x N number) 
%       Euler angles [phi;theta;psi].
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

euler = quat2euler(rot2quat(R));

end