function result = issize(input,varargin)
% The "issize" function checks the size of "input".
%
% USAGE:
%   result = issize(input,[sizeOfDim1],[sizeOfDim2],...)
% 
% INPUTS:
%   input - (any) 
%       The argument that is being checked.
%
%   [sizeOfDim?] - (1 x 1 semi-positive integer or empty) [Default 1]
%       Checks that the size of dimision ? of the input. If empty
%       nothing is for that dimision is checked.
% 
% OUTPUTS:
%   result - (1 x 1 logical) 
%       True if the dimsions of "input" match the give size arguments.
%
% DESCRIPTION:
%
% EXAMPLES:
%   issize([1 2; 3 4],2,1)
%   ans = 
%        0
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%   isrealnumber, isrealinteger
%
% REVISION:
%   1.0 28-NOV-2009 by Rowland O'Flaherty
%       Initial Revision.
%
%--------------------------------------------------------------------------

% Check number of arguments
error(nargchk(1,inf,nargin))

% Get number of optional arguments
noptargin = size(varargin,2);

% Get size of each dimension of the input
sizeOfInput = size(input);
ndimOfInput = length(sizeOfInput);
if ndimOfInput < noptargin
    sizeOfInput = [sizeOfInput ones(1,noptargin-ndimOfInput)];
elseif ndimOfInput > noptargin
    varargin = [varargin(:) num2cell(ones(1,ndimOfInput-noptargin))];
    noptargin = size(varargin,2);
end

desiredSize = sizeOfInput;

% Check optional arguments for errors
for iOptarg = 1:noptargin
    optarg = varargin{iOptarg};
    
    assert((isnumeric(optarg) && isreal(optarg) && isequal(size(optarg),[1,1]) && mod(optarg,1)==0 && optarg>=0) || isempty(optarg),...
        'issize:optarginChk','Invalid input argument')    
    
    if ~isempty(optarg)
        desiredSize(iOptarg) = optarg;
    end 
end

% Check the size of the input
result = isequal(sizeOfInput,desiredSize);

end
