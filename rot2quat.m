function q = rot2quat(R)
% The "rot2quat" function converts a rotation matrix to a quaterion.
%
% SYNTAX:
%   q = rot2quat(R)
%
% INPUTS:
%   R - (3 x 3 x N number)
%       A standard rotation matrix that is in SO(3).
%
% OUTPUTS:
%   q - (4 x N numbers)
%       Quaterion components: r + i*1i + j*1j + k*1k.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   See http://www.cg.info.hiroshima-cu.ac.jp/~miyazaki/knowledge/teche52.html
%
% NECESSARY FILES:
%
% SEE ALSO:
%    quat2rot | euler2quat | quat2euler | euler2rot | rot2euler
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
assert(isnumeric(R) && isreal(R) && size(R,1) == 3 && size(R,2) == 3,...
    'quaternion:quat2euler:R',...
    'Input argument "R" must be a 3 x 3 x N real number.')
N = size(R,3);

R11 = squeeze(R(1,1,:))';
R12 = squeeze(R(1,2,:))';
R13 = squeeze(R(1,3,:))';

R21 = squeeze(R(2,1,:))';
R22 = squeeze(R(2,2,:))';
R23 = squeeze(R(2,3,:))';

R31 = squeeze(R(3,1,:))';
R32 = squeeze(R(3,2,:))';
R33 = squeeze(R(3,3,:))';

r = 1/4*( R11 + R22 + R33 + ones(1,N));
i = 1/4*( R11 - R22 - R33 + ones(1,N));
j = 1/4*(-R11 + R22 - R33 + ones(1,N));
k = 1/4*(-R11 - R22 + R33 + ones(1,N));

r(r<0) = 0;
i(i<0) = 0;
j(j<0) = 0;
k(k<0) = 0;

r = r.^(1/2);
i = i.^(1/2);
j = j.^(1/2);
k = k.^(1/2);

q = nan(4,N);

ind1 = (r >= i & r >= j & r >= k);
q(1,ind1) = r(ind1);
q(2,ind1) = sign(R32(ind1) - R23(ind1)).*i(ind1);
q(3,ind1) = sign(R13(ind1) - R31(ind1)).*j(ind1);
q(4,ind1) = sign(R21(ind1) - R12(ind1)).*k(ind1);

ind2 = (i >= r & i >= j & r >= k);
q(1,ind2) = sign(R32(ind2) - R23(ind2)).*r(ind2);
q(2,ind2) = i(ind2);
q(3,ind2) = sign(R21(ind2) + R12(ind2)).*j(ind2);
q(4,ind2) = sign(R13(ind2) + R31(ind2)).*k(ind2);

ind3 = (j >= r & j >= i & j >= k);
q(1,ind3) = sign(R13(ind3) - R31(ind3)).*r(ind3);
q(2,ind3) = sign(R21(ind3) + R12(ind3)).*i(ind3);
q(3,ind3) = j(ind3);
q(4,ind3) = sign(R32(ind3) + R23(ind3)).*k(ind3);

ind4 = (k >= r & k >= i & k >= j);
q(1,ind4) = sign(R21(ind4) - R12(ind4)).*r(ind4);
q(2,ind4) = sign(R31(ind4) + R13(ind4)).*i(ind4);
q(3,ind4) = sign(R32(ind4) + R23(ind4)).*j(ind4);
q(4,ind4) = k(ind4);

q_norm = sqrt(sum(q.^2,1));

q = q ./ repmat(q_norm,4,1);
