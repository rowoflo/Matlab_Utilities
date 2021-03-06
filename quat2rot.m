function R = quat2rot(q)
% The "quat2rot" fuction converts a quaterion to a rotation
% matrix.
%
% SYNTAX:
%   R = quat2rot(q)
%
% INPUTS:
%   q - (4 x N numbers)
%       Quaterion components: r + i*1i + j*1j + k*1k.
%
% OUTPUTS:
%   R - (3 x 3 x N number)
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
%    rot2quat | euler2quat | quat2euler | euler2rot | rot2euler
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

R = nan(3,3,N);

R(1,1,:) = r.^2+i.^2-j.^2-k.^2;
R(2,1,:) = 2*i.*j+2*r.*k;
R(3,1,:) = 2*i.*k-2*r.*j;

R(1,2,:) = 2*i.*j-2*r.*k;
R(2,2,:) = r.^2-i.^2+j.^2-k.^2;
R(3,2,:) = 2*j.*k+2*r.*i;

R(1,3,:) = 2*i.*k+2*r.*j;
R(2,3,:) = 2*j.*k-2*r.*i;
R(3,3,:) = r.^2-i.^2-j.^2+k.^2;

end
