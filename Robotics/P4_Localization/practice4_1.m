clear variables; close all; clc
 
% Initialization
%--------------------------------------------------------------------------
 
% Map/landmarks related
nLandmarks = 7; % Number of landmarks
mapSize = 140;  %Size of them environment in (m)
Map = mapSize*rand(2,nLandmarks)-mapSize/2; % Landmarks uniformly distributed in the Map
 
% Sensor/odometry related  
var_d = 0.5^2;      % variance (noise) of the range measurement 
R = zeros(nLandmarks);  % Covariance of the observation of the landmarks
z = zeros(nLandmarks,1); % Initially. all the observations equals to zero
U = diag([9,20,1*pi/180]).^2; % Covariance of the odometry noise
 
% Robot pose related
xTrue = zeros(3,1); % True position, to be selected by the mouse
xEst = zeros(3,1);  % Position estimated by the LSE method
xOdom = zeros(3,1); % Position given by odometry (in this case xTrue affected by noise)
 
% Initial graphics
figure(1); hold on; grid off; axis equal; grid on;
plot(Map(1,:),Map(2,:),'sm','LineWidth',2);hold on;
xlabel('x (m)');
ylabel('y(m)');
legend('LandMarks');
 
% Get the true position of the robot (ask the user)
fprintf('Please, click on the Figure where the robot is located: \n');
xTrue (1:2) = ginput(1)'; %
plot(xTrue(1),xTrue(2),'ob','MarkerSize',12);
 
% Set an initial guess: Where the robot believes it is (from odometry)
xOdom = xTrue + sqrtm(U)*randn(3,1);
plot(xOdom(1),xOdom(2),'+r','MarkerSize',12);
legend('LandMarks','True Position','Odo Estimation (initial guess)');
sqrt((xOdom(1)-xTrue(1))^2+(xOdom(2)-xTrue(2))^2)
 
% Take measurements
%--------------------------------------------------------------------------
 
% Get the observations to all the landmarks (data given by our sensor)
z_ideal = zeros(nLandmarks,1); % measurements unaffected by gaussian error. Initially zeros

for kk = 1 : nLandmarks
   % Take an observation to each landmark, i.e. compute distance to each 
   % one (RANGE sensor) affected by gaussian noise
   
   x_lm = Map(1,kk); % kk-th landmark's x-axis coordinate
   y_lm = Map(2,kk); % kk-th landmark's y-axis coordinate
   
   % xTrue(1) = robot's x-axis position 
   % xTrue(2) = robot's y-axis position
   
   z_ideal(kk) = sqrt((x_lm - xTrue(1))^2 + (y_lm - xTrue(2))^2); % Euclidean distance to the kk-th landmark
   
   % At this point, the measurement has no error associated
   % We need to add gaussian noise to simulate sensor imprecision 
   % Because it is an error, mu = 0 in our call to 'normrnd'
   
   z(kk) = z_ideal(kk) + normrnd(0,var_d); % Adding gaussian error to the measurement
%    rng('default');
%    r = randn();
%    z(kk) = z_ideal(kk) + r * var_d; %-> gives us the same result
end
 
% Pose estimation using Gauss-Newton for least squares optimization
%--------------------------------------------------------------------------
 
% Some parameters for the Gauss-Newton optimization loop
nIterations = 10; % sets the maximum number of iterations
tolerance = 0.001;% Minimum error needed for stopping the loop (convergence)
iteration = 0;
 
% Initialization of useful vbles
incr = ones(1,2); % Delta
jH = zeros(nLandmarks,2); % Jacobian of the observation function of all the landmarks
xEst = xOdom;     %Initial estimation is the odometry position (usually noisy)
 
% Let's go!
while (norm(incr) > tolerance && iteration < nIterations) % norm = vector's magnitude
    plot(xEst(1),xEst(2),'+r','MarkerSize',1 + floor((iteration*15)/nIterations));
    
    % Compute the predicted observation (from xEst) and their respective
    % Jacobians
    
    % 1) Compute distance to each landmark from xEst 
    % (estimated observations)
    
    z_p = zeros(nLandmarks,1); % predicted observations. Initially zeros
    
    for kk = 1 : nLandmarks
        
       x_lm = Map(1,kk); % kk-th landmark's x-axis coordinate
       y_lm = Map(2,kk); % kk-th landmark's y-axis coordinate

       % xTrue(1) = robot's x-axis position 
       % xTrue(2) = robot's y-axis position

       z_p(kk) = sqrt((x_lm - xEst(1))^2 + (y_lm - xEst(2))^2); % Euclidean distance to the kk-th landmark

    end
    
    % error = difference between real observations and prediced ones.
    e = z - z_p;
    residual = sqrt(e'*e);  %residual error = srqt(x²+y²)
    
    % 2) Compute Jacobians with respect (x,y) (slide 13)
    % The jH is evaluated at our current guest (xEst) -> z_p
    for kk = 1 : nLandmarks
        x_lm = Map(1,kk); % kk-th landmark's x-axis coordinate
        y_lm = Map(2,kk); % kk-th landmark's y-axis coordinate
        
        jH(kk,1) = -(x_lm - xEst(1)) / z_p(kk);
        jH(kk,2) = -(y_lm - xEst(2)) / z_p(kk);
    end 
       
    % The observation variances R grow with the root of the distance
    R = diag(var_d*sqrt(z));
        
    % 3) Solve the equation --> compute incr
    incr = inv(jH'*inv(R)*jH) * jH'*inv(R)*e;
    
    % update position estimation
    plot([xEst(1), xEst(1)+incr(1)],[xEst(2) xEst(2)+incr(2)],'r');
    xEst(1:2) = xEst(1:2) + incr;
    fprintf('Iteration number %u residual: %1.4f [m] increment: %1.5f [m]\n',iteration+1,residual,norm(incr));
    iteration = iteration + 1;
    
    pause(1);
    
end
 
plot(xEst(1),xEst(2),'*g') %The last estimation is plot in green
