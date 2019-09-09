%
%          Exercise of the ''Robot sensing'' lecture
%             Composition of poses and landmarks

close all
clear var
clc

% Sufix meaning:
% _w: world reference frame
% _r: robot reference frame
% Other codes:
% p: in polar coordinates
% c: in cartesian coordinates
% e.g. z1p_r represents an observation z1 in polar (robot frame)

%-------------------------------------------------------------------------%
%                               4.1.1                                     %
%-------------------------------------------------------------------------%

% Robot
p1_w = [1,2,0.5]'; % Robot R1 pose
Qp1_w = zeros(3,3); % Robot pose covariance matrix (uncertainty)
% Landmark
z1p_r = [4,0.7]'; % Measurement/observation (polar)
W1p_r = diag([0.25, 0.04]); % Sensor noise covariance

% 1. Convert polar coordinates to cartesian (in the robot frame)
z1xc_r = z1p_r(1) * cos(z1p_r(2)); % r * cos alfa   
z1yc_r = z1p_r(1) * sin(z1p_r(2)); % r * sen alfa
zc_r = [z1xc_r, z1yc_r]'; % landmark position in cartesian (robot frame)

% 2. Obtain the sensor/measurement covariance in cartesian coordinates in
% the frame of the robot (it is given in polar). For that you need the 
% Jacobian built from the expression that converts from polar to cartesian
% coordinates. 
r = z1p_r(1); % Useful variables
alpha = z1p_r(2);
c = cos(alpha);
s = sin(alpha);

J_pc = [c -r*s; s r*c]; % Build the Jacobian

Wzc_r = J_pc*W1p_r*J_pc'; % sensor covariance in cartesian

% 3. Ok, we are now ready for computing the sensor measurement in the 
% world's coordinate system (mean and covariance).

z1_w = tcomp(p1_w, [zc_r; 1]) % 'a'. Compute coordinates of the landmark in the world. The '1' has no meaning (diap. 34)

% Now build the Jacobians for obtain the covariance matrix
J_ap = J1(p1_w, zc_r);
J_aa = J2(p1_w, z1_w);

% Remove last row (it must have size 2x3)
J_ap(end,:) = [];

% Remove last row and column (it must be 2x2)
J_aa(end,:) = [];
J_aa(:,end) = [];

% diapo 36
Wzc_w = J_ap*Qp1_w*J_ap' + J_aa*Wzc_r*J_aa' % Finally, propagate the covariance!

% Draw results
plot(z1_w(1),z1_w(2),'x');
xlim([-1,10])
ylim([-1,10])
grid on;
hold on;
pbaspect([1 1 1])
text(z1_w(1)+1,z1_w(2),'Landmark','color','k');
PlotEllipse(z1_w(1:2),Wzc_w,1,'m');
DrawRobot(p1_w,'b');
text(p1_w(1)+1,p1_w(2),'R1','color','b');

%-------------------------------------------------------------------------%
%                               4.1.2                                     %
%-------------------------------------------------------------------------%

% Now, we have uncertainty in the robot pose!
Qp1_w = diag([0.08, 0.6, 0.02]); % New R1 covariance diag(x, y, theta)

% Propagate the covariances again, taken into account this new info.
Wzc_w = J_ap*Qp1_w*J_ap' + J_aa*Wzc_r*J_aa' 

% Draw result
PlotEllipse(p1_w(1:2),Qp1_w,1,'b');
PlotEllipse(z1_w(1:2),Wzc_w,1,'b');

% -------------------------------------------------------------------------%
%                               4.1.3                                      %
% -------------------------------------------------------------------------%
p2_w  = [6,4,2.1]'; % Pose of the second robot R2
Qp2_w = diag([0.20,0.09,0.03]); % Covariance matrix related to the pose

% Draw robot
PlotEllipse(p2_w(1:2),Qp2_w,1,'g');
DrawRobot(p2_w,'g');
text(p2_w(1)+1,p2_w(2),'R2','color','g');

% Compute the relative pose between p12 between R1 and R2
% First way: composition of poses with inverse pose
p1inv_w = tinv(p1_w); % Inverse pose
p12_w = tcomp(p1inv_w, p2_w) % Mean

Qinvp1_w = Jinv(p1_w)*Qp1_w*Jinv(p1_w)';
Qp12_w = J1(p1inv_w, p2_w) * Qinvp1_w * J1(p1inv_w, p2_w)' + J2(p1inv_w, p2_w) * Qp2_w * J2(p1inv_w, p2_w)'

% Second way: Inverse Composition
c = cos(p1_w(3)); % Useful variables
s = sin(p1_w(3));
xp1 = p1_w(1); yp1 = p1_w(2);
xp2 = p2_w(1); yp2 = p2_w(2);

p12_w2 = [(xp2-xp1)*c+(yp2-yp1)*s;
          (yp2-yp1)*c-(xp2-xp1)*s; 
           p2_w(3)-p1_w(3)] 
       
J_p12p1 = [-c, -s, -(xp2-xp1)*s + (yp2 - yp1)*c; 
           s, -c, -(xp2-xp1)*c - (yp2 - yp1)*s;
           0, 0, -1];

Jp12p2 = J2(p1_w, p2_w)';
     
Qp12_w2 = J_p12p1*Qp1_w*J_p12p1' + Jp12p2*Qp2_w*Jp12p2'

%-------------------------------------------------------------------------%
%                               4.1.4                                     %
%-------------------------------------------------------------------------%

% 1. Take a measurement using the range-bearing observation model!
% diapo 33
r2 = sqrt( (z1_w(1)-xp2)^2 + (z1_w(2)-yp2)^2 );
alpha2 = atan2([z1_w(2), yp2], [z1_w(1), xp2]);

alpha2(:,1) = [];

z2p_r = [r2,alpha2]'

% 2. Jacobian from cartesian to polar at z2p_r when the covariance is in 
% global coordianes
alpha = alpha2 + p2_w(3);
Jcp_p2 = [cos(alpha) sin(alpha);
          -sin(alpha)/r2 cos(alpha)/r2];
% 
% 3. Finally, propagate the uncertainty to polar coordinates in the 
% robot frame    
W2_p = Jcp_p2 * Wzc_w * Jcp_p2'  %dim: 2x2

%-------------------------------------------------------------------------%
%                               4.1.5                                     %
%-------------------------------------------------------------------------%
z2p_r = [4,0.3]';
W2p_r = diag([0.25, 0.04]); % Sensor noise covariance

% 1. Convert polar coordinates to cartesian (in the robot frame)
x2 = z2p_r(1) * cos(z2p_r(2));
y2 = z2p_r(1) * sin(z2p_r(2));
z2c_r = [x2,y2]';

% 2. Obtain the sensor/measurement covariance in cartesian coordinates in
% the frame of the robot (it is given in polar). For that you need the 
% Jacobian built from the expression that converts from polar to cartesian
% coordinates. 
r = z2p_r(1);
alpha = z2p_r(2);
c = cos(alpha);
s = sin(alpha);

J_pc = [c -r*s; s r*c]; 

Wz2c_r = J_pc*W2p_r*J_pc';

% 3. Ok, we are now ready for computing the sensor measurement in the 
% world's coordinate system (mean and covariance).
z2_w = tcomp(p2_w, [z2c_r; 1]) % Compute coordinates of the landmark in the world

J_ap = J1(p2_w, z2c_r);
J_aa = J2(p2_w, z2_w);

% Elimino la última fila de J_ap (ya que debe ser 2x3)
J_ap(end,:) = [];

% También elimino la última fila y columna de J_aa (debe ser 2x2)
J_aa(end,:) = [];
J_aa(:,end) = [];

% diapo 36
Wz2c_w = J_ap*Qp2_w*J_ap' + J_aa*Wz2c_r*J_aa'

% Draw result
plot(z2_w(1),z2_w(2),'xg');
PlotEllipse(z2_w(1:2),Wz2c_w,1,'g');

% 4. Combine the measurements from both sensors!
Wz_w = inv(inv(Wzc_w) + inv(Wz2c_w)) % sigma
z_w = Wz_w*inv(Wzc_w)*z1_w([1,2]) + Wz_w*inv(Wz2c_w)*z2_w([1,2]) % mu

% Draw result
plot(z_w(1),z_w(2),'xr');
PlotEllipse(z_w(1:2),Wz_w,1,'r');

%-------------------------------------------------------------------------%
