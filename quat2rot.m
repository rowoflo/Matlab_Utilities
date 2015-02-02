function R = quat2rot(a,b,c,d)
% The "quat2rot" fuction converts a converts a quaterion to a rotation
% matrix.
%
% SYNTAX:
%   R = quaternion.quat2rot(q)
%   R = quaternion.quat2rot(a,b,c,d)
%
% INPUTS:
%   q - (1 x 4 number)
%       Quaterion components in vector form.
%
%   [a,b,c,d] - (1 x 1 numbers)
%       Quaterion components: a + b*i + c*j + d*k.
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
narginchk(1,4)

% Check arguments for errors
if nargin == 1
    q = a;
    assert(isnumeric(q) && isreal(q) && numel(q) == 4,...
        'quaternion:quat2rot:q',...
        'Input argument "q" must be a 1 x 1 real number.')
    a = q(1); b = q(2); c = q(3); d = q(4);
    
elseif nargin == 4
    assert(isnumeric(a) && isreal(a) && numel(a) == 1,...
        'quaternion:quat2rot:a',...
        'Input argument "a" must be a 1 x 1 real number.')
    
    assert(isnumeric(b) && isreal(b) && numel(b) == 1,...
        'quaternion:quat2rot:b',...
        'Input argument "b" must be a 1 x 1 real number.')
    
    assert(isnumeric(c) && isreal(c) && numel(c) == 1,...
        'quaternion:quat2rot:c',...
        'Input argument "c" must be a 1 x 1 real number.')
    
    assert(isnumeric(d) && isreal(d) && numel(d) == 1,...
        'quaternion:quat2rot:d',...
        'Input argument "d" must be a 1 x 1 real number.')
else
    error('quaternion:quat2rot:nargin',...
        'Incorrect number of input arugments.')
end

R = [a^2+b^2-c^2-d^2    2*b*c-2*a*d     2*b*d+2*a*c;...
    2*b*c+2*a*d        a^2-b^2+c^2-d^2 2*c*d-2*a*b;...
    2*b*d-2*a*c        2*c*d+2*a*b     a^2-b^2-c^2+d^2];
end
