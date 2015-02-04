function q = euler2quat(euler)
% The "euler2quat" function converts Euler angles to quaterion components.
%
% SYNTAX:
%   q = euler2quat(euler)
%
% INPUTS:
%   euler - (3 x N number) 
%       Euler angles [phi;theta;psi].
%
% OUTPUTS:
%   q = (4 x N numbers)
%       Quaterion components: q(1) + q(2)*i + q(3)*j + q(4)*k.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
%
% NECESSARY FILES:
%
% SEE ALSO:
%    quat2rot | rot2quat | quat2euler | euler2rot | rot2euler
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

% Check arguments for errors
assert(isnumeric(euler) && isreal(euler) && size(euler,1) == 3,...
    'quaternion:rot2quat:euler',...
    'Input argument "euler" must be a 3 x N vector of real numbers.')

phi = euler(1,:); theta = euler(2,:); psi = euler(3,:);

r = cos(phi/2).*cos(theta/2).*cos(psi/2) + sin(phi/2).*sin(theta/2).*sin(psi/2);
i = sin(phi/2).*cos(theta/2).*cos(psi/2) - cos(phi/2).*sin(theta/2).*sin(psi/2);
j = cos(phi/2).*sin(theta/2).*cos(psi/2) + sin(phi/2).*cos(theta/2).*sin(psi/2);
k = cos(phi/2).*cos(theta/2).*sin(psi/2) - sin(phi/2).*sin(theta/2).*cos(psi/2);

q = [r;i;j;k];
end


