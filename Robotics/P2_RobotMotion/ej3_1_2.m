% Testing the composition of robot poses
close all;
clear

nSteps = 15; %Number of motions

t = [2;0]; %translation,[x;y]
ang = -pi/2; %orientation angle

sigma = [0 0 0; 0 0 0; 0 0 0.05 ]; %covariance matrix

pose_inc_straight_line = [t;0]; %pose increment
pose_inc_straight_line_and_rotation = [t;ang]; %pose increment

pose = [0;0;pi/2]; %initial pose of the robot (at k = 0)
poserr = [0;0;pi/2];

figure(1);hold on;axis equal;grid on;axis([-2 10 -2 10])
xlabel('x');ylabel('y'); title('3.1.2 Pose compositions');
DrawRobot(pose,'r'); % Draw initial pose
DrawRobot(poserr, 'b');

pause

for k = 1:nSteps %Main loop
    if mod(k,4) == 0
        pose = tcomp(pose, pose_inc_straight_line_and_rotation);
        % Adding Gaussian noise
        poserr = tcomp(poserr, transpose(mvnrnd(pose_inc_straight_line_and_rotation,sigma)));
        %poserr = tcomp(poserr, (normrnd(diag([2 0 ang]), sigma))*[1;1;1]);
    else
        pose = tcomp(pose, pose_inc_straight_line);
        % Adding Gaussian noise
        poserr = tcomp(poserr, transpose(mvnrnd(pose_inc_straight_line,sigma)));
        %poserr = tcomp(poserr, (normrnd(diag([2 0 0]), sigma))*[1;1;1]);
    end
    DrawRobot(pose,'r');
    DrawRobot(poserr, 'b');
    pause
end;
