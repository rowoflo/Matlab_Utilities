function euler = quat2euler(q)
% The "quat2euler" fuction converts a converts a quaterion to a
% Euler angles.
%
% SYNTAX:
%   euler = quat2euler(q)
%
% INPUTS:
%   q - (4 x N numbers)
%       Quaterion components: r + i*1i + j*1j + k*1k.
%
% OUTPUTS:
%   euler - (3 x N number)
%       Euler angles [phi; theta; psi] for the given quaterion.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
%
% NECESSARY FILES:
%
% SEE ALSO:
%    quat2rot | rot2quat | euler2quat | euler2rot | rot2euler
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
assert(isnumeric(q) && isreal(q) && size(q,1) == 4,...
    'quaternion:quat2euler:q',...
    'Input argument "q" must be a 4 x N real number.')
N = size(q,2);

r = q(1,:);
i = q(2,:);
j = q(3,:);
k = q(4,:);

phi = atan2(2*(r.*i+j.*k),ones(1,N)-2*(i.^2+j.^2));
theta = asin(2*(r.*j-k.*i));
psi = atan2(2*(r.*k+i.*j),ones(1,N)-2*(j.^2+k.^2));

euler = [phi;theta;psi];
end