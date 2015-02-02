function q = euler2quat(euler)
% The "euler2quat" function converts Euler angles to quaterion components.
%
% SYNTAX:
%   q = quaternion.euler2quat(euler)
%
% INPUTS:
%   euler - (1 x 3 number) 
%       Euler angles [phi theta psi].
%
% OUTPUTS:
%   q = (1 x 4 numbers)
%       Quaterion components: q(1) + q(2)*i + q(3)*j + q(4)*k.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
%
% NECESSARY FILES: TODO: Add necessary files
%   +somePackage, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (www.rowlandoflaherty.com)
%
% VERSION: 
%   Created 02-FEB-2015
%
%-----------------------------------------------------------------------

% Check number of arguments
narginchk(1,1)

% Check arguments for errors
assert(isnumeric(euler) && isreal(euler) && size(euler,2) == 3,...
    'quaternion:rot2quat:euler',...
    'Input argument "euler" must be a 3 x 1 vector of real numbers.')
euler = euler(:)';

phi = euler(1); theta = euler(2); psi = euler(3);

a = cos(phi/2)*cos(theta/2)*cos(psi/2) + sin(phi/2)*sin(theta/2)*sin(psi/2);
b = sin(phi/2)*cos(theta/2)*cos(psi/2) - cos(phi/2)*sin(theta/2)*sin(psi/2);
c = cos(phi/2)*sin(theta/2)*cos(psi/2) + sin(phi/2)*cos(theta/2)*sin(psi/2);
d = cos(phi/2)*cos(theta/2)*sin(psi/2) - sin(phi/2)*sin(theta/2)*cos(psi/2);

q = [a b c d];
end


