function R = rotRep(axis,angle)
% The "rotRep" function function outputs the rotation matrix associated
% with the rotation of about a given axis "axis" by an angle of "angle".
%
% USAGE:
%   R = rotRep(axis,angle)
% 
% INPUTS:
%   axis - (3 x 1 number or 'x','y','z') 
%       Axis of rotation. Axis names can also be used.
%
%   angle - (1 x 1 number)
%       Angle of rotation in radians.
% 
% OUTPUTS:
%   R - (3 x 3 number (rotation matrix)) 
%       Rotation matrix.
%
% DESCRIPTION:
%
% EXAMPLES:
%
% NOTES:
%   Several rotation representations can be done at once by packaging the
%   inputs up into cells.
%
%   Numbers smaller or equal to 100*eps are rounded to zero.
%
% NECESSARY FILES:
%   isrealnumber.m, smallToZero.m
%
% SEE ALSO:
%    axisAngRep, HGRep, HGRepI, skewSym
%
% REVISION:
%   1.0 03-DEC-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of inputs
error(nargchk(2,2,nargin))

% Check inputs for errors
if iscell(axis) ~= iscell(angle)
    error('model:rotRep:cellSizeChk','"axis" and "angle" cells must be of the same size')
elseif iscell(axis) && iscell(angle)
    assert(isequal(size(axis),size(angle)),'model:rotRep:cellSizeChk','"axis" and "angle" cells must be of the same size')
end

if iscell(axis)
    cellFlag = true;
else
    cellFlag = false;
    axis = {axis};
    angle = {angle};
end

% Loop through each cell to convert named axis to 3 x 1 vectors
axis = cellfun(@cellLoop1,axis,'UniformOutput',false);

    function thisAxis = cellLoop1(thisAxis)
        if ischar(thisAxis)
            switch thisAxis
                case 'x'
                    thisAxis = [1;0;0];
                case 'y'
                    thisAxis = [0;1;0];
                case 'z'
                    thisAxis = [0;0;1];
                otherwise
                    error('model:rotRep:axisChk1','Invalid axis name %s (valid axis names are: ''x'',''y'',''z'')',axis{iCell})
            end
        end
    end


% Loop through each cell to perform calculation
R = cellfun(@cellLoop2,axis,angle,'UniformOutput',false);

    function thisR = cellLoop2(thisAxis,thisAngle)
        assert(isrealnumber(thisAxis,3),...
            'model:rotRep:axisChk2',...
            '"axis" must be a 3 x 1 real number')
        
        assert(isrealnumber(thisAngle,1),...
            'model:rotRep:angleChk',...
            '"angle" must be a 1 x 1 real number')
        
        kx = thisAxis(1);
        ky = thisAxis(2);
        kz = thisAxis(3);
        s = sin(thisAngle);
        c = cos(thisAngle);
        v = 1 - c;
        
        thisR = ...
            [kx^2*v + c         kx*ky*v - kz*s      kx*kz*v + ky*s; ...
            kx*ky*v + kz*s     ky^2*v + c          ky*kz*v - kx*s; ...
            kx*kz*v - ky*s     ky*kz*v + kx*s      kz^2*v + c    ];
        
        % Set really small numbers to 0
        thisR = smallToZero(thisR);
    end


if ~cellFlag
    R = R{:};
end

end
