function [xh,xh_p,P,P_p,K,w,v,chi2] = kalmanEstimate(xh_,P_,Phi,G,H,Q,R,z)
% This is an implementation of a Kalman filter.
%
% USAGE:
%   [xh,xh_p,P,P_p,K,w,v,chi2] = kalmanEstimate(xh_,P_,Phi,G,H,Q,R,[z])
% 
% INPUTS:
%   xh_ - (N x 1 number)
%       Estimate of states priori.
%
%   P_ - (N x N number)
%       Error covariance matrix priori.
%
%   Phi - (N x N number)
%       Discrete time state transition matrix.
%
%   G - (N x 1 number)
%       Predication control vector.
%
%   H - (M x N number)
%       Observation modal matrix.
%
%   Q - (N x 1 or N x N number)
%       Process noise covariance. If vector, diagonals of covariance. 
%
%   R - (M x 1 or M x M number)
%       Measurement noise covariance. If vector, diagonals of covariance.
%
%   [z] - (M x 1 number)
%       Observation vector.
% 
% OUTPUTS:
%   xh - (N x 1 number)
%       Updated estimate of the states.
%
%   xh_p - (N x 1 number)
%       Updated projection of next states.
%
%   P - (N x N number)
%       Updated error covariance matrix.
%
%   P_p - (N x N number)
%       Updated projection of next error covariance matrix.
%
%   K - (N x M number)
%       Kalman gain matrix.
%
%   w - (N x 1 number)
%       Process noise variance.
%
%   v - (M x 1 number)
%       Measurement noise variance.
%
%   chi2 - (1 x 1 number)
%       Chi-squared value. This is set to NaN if "z" is not an input.
%
% DESCRIPTION:
%   This function calculates an estimate of the current state, next state,
%   current and next error covariance matrices, the Kalman gain, and estimate
%   of the current process noise and measurement noise. If measurement
%   information is not provided a predication forward is calculated.
%
% EXAMPLES:
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%
% REVISION:
%   01-APR-2009 by Rowland O'Flaherty
%       Initial Revision
%
%   05-JAN-2010 by Rowland O'Flaherty
%       Added prediction control vector as an input argument.
%
%   21-MAY-2010 by Rowland O'Flaherty
%       Allowed Q and R inputs to be matrices. Added chi2 as output.
%
%--------------------------------------------------------------------------

% Check input arguments
error(nargchk(7,8,nargin))

assert(isnumeric(xh_) && isequal(size(xh_,2),1),...
    'trackerPkg:kalmanEstimate:xh_Chk','State priori ''xH_'' must be a column vector of real numbers.')
N = length(xh_);

assert(isnumeric(P_) && isequal(size(P_),[N N]),...
    'trackerPkg:kalmanEstimate:P_Chk','Error covariance matrix priori ''P_'' must be a %d x %d matrix of numbers.',N,N)

assert(isnumeric(Phi) && isequal(size(Phi),[N N]),...
    'trackerPkg:kalmanEstimate:PhiChk','State transition matrix ''Phi'' must be a %d x %d matrix of numbers.',N,N)

assert(isnumeric(G) && isequal(size(G),[N 1]),...
    'trackerPkg:kalmanEstimate:GChk','Predication control vector ''G'' must be a %d x 1 vector of numbers.',N)

assert(isnumeric(H) && isequal(size(H,2),N),...
    'trackerPkg:kalmanEstimate:HChk','Observation modal matrix ''H'' must be a ? x %d matrix of numbers.',N)
M = size(H,1);

assert(isnumeric(Q) && (isequal(size(Q),[N 1]) || isequal(size(Q),[N N])),...
    'trackerPkg:kalmanEstimate:QChk','Process noise covariance matrix ''Q'' must be a %d x %d matrix or %d x 1 vector of numbers.',N,N,N)
if isvector(Q)
    Q = diag(Q);
end

assert(isnumeric(R) && (isequal(size(R),[M 1]) || isequal(size(R),[M M])),...
    'trackerPkg:kalmanEstimate:RChk','Measurement noise covariance matrix ''R'' must be a %d x %d matrix or %d x 1 vector of numbers.',M,M,M)
if isvector(R)
    R = diag(R);
end

%%

if nargin == 7 % Do a prediction for the track when z is not present

    % Kalman prediction
    xh = xh_;                   % Updated estimate of states using states priori
    xh_p = Phi*xh_ + G;         % Updated estimate of next states
    P = P_;                     % Updated error covariance matrix using error covariance matrix priori
    P_p = Phi*P_*Phi'+Q;        % Updated projection of error covariance matrix
    S = H*P_*H'+R;              % Sum of error variances
    iM = (S == inf);            % Infinite mask
    S_inv = zeros(size(S));     % Inverse of sum of error variances
    S_inv(~any(iM,2),~any(iM,1)) = (S(~any(iM,2),~any(iM,1)))^-1;
    K = P_*H'*S_inv;            % Kalman gain
    w = NaN;                    % Unknown process error
    v = NaN;                    % Unknown measurement error
    
    chi2 = nan;
    
else % Update track when z is present
    assert(isnumeric(z) && isequal(size(z),[M,1]),...
        'trackerPkg:kalmanEstimate:zChk','Observation vector ''z'' must be a %d x 1 of numbers.',M)
    
    % Kalman update
    I = eye(size(Q));           % N x N identity matrix
    r = z-H*xh_;                % Residual
    S = H*P_*H'+R;              % Sum of error variances
    iM = (S == inf);            % Infinite mask
    S_inv = zeros(size(S));     % Inverse of sum of error variances
    S_inv(~any(iM,2),~any(iM,1)) = (S(~any(iM,2),~any(iM,1)))^-1;
    K = P_*H'*S_inv;            % Kalman gain
    w = K*r;                    % Process error
    xh = xh_+w;                 % Updated estimate of states using measurements
    v = z-H*xh;                 % Measurement error
    xh_p = Phi*xh + G;          % Updated projection estimate for next states
    P = (I-K*H)*P_;             % Updated error covariance matrix
    P_p = Phi*P*Phi'+Q;         % Updated projection for next error covariance matrix
    
    chi2 = r'*S_inv*r;          % Chi-squared value
    
end

end