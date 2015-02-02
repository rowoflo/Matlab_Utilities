function rot = euler2rot(euler)
% The "euler2rot" function converts Euler angles to a rotation
% matrix.
%
% SYNTAX:
%   q = quaternion.euler2quat(euler)
%
% INPUTS:
%   euler - (1 x 3 number) 
%       Euler angles [phi theta psi].
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

rot = quat2rot(euler2quat(euler));

end
