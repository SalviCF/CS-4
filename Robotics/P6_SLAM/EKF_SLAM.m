function EKF_SLAM
 
    clear all;
    close all; 
    
    % Map configuration
    nFeatures = 15;
    MapSize = 200;
    [Map,colors] = CreateMap(MapSize,nFeatures); 
 
    %how often shall we draw?
    DrawEveryNFrames = 5;
    mode = 'one_landmark_in_fov';
    %mode = 'landmarks_in_fov'; 
 
    % Robot base characterization
    SigmaX = 0.01; % Standard deviation in the x axis
    SigmaY = 0.01; % Standard deviation in the y axis
    SigmaTheta = 1.5*pi/180; % Bearing standar deviation
    R = diag([SigmaX^2 SigmaY^2 SigmaTheta^2]); % Cov matrix
 
    % Covariances for our very bad&expensive sensor (in the system <d,theta>)
    Sigma_r = 1.1;
    Sigma_theta = 5*pi/180;
    Q = diag([Sigma_r,Sigma_theta]).^2;
    fov = pi*2/3;
    max_range = 100;
 
    xRobot = [-MapSize/3 -MapSize/3 0]';
    xRobotTrue = xRobot;
 
    %initial conditions - no map:
    xEst = xRobot;
    PEst = zeros(3,3);
    MappedFeatures = NaN*zeros(nFeatures,2);
 
    % Drawings
    figure(1); hold on; grid off; axis equal;
    axis([-MapSize/2-40 MapSize/2+40 -MapSize/2-40 MapSize/2+40]);
    for i_feat=1:nFeatures
        plot(Map(1,i_feat),Map(2,i_feat),'s','Color',colors(i_feat,:), ...
            'MarkerFaceColor',colors(i_feat,:),'MarkerSize',10)       ;        
    end
    set(gcf,'doublebuffer','on');
    hObsLine = line([0,0],[0,0]);
    set(hObsLine,'linestyle',':');
    DrawRobot(xEst(1:3),'g');
    DrawRobot(xRobotTrue,'b');
    DrawRobot(xRobot,'r');
    hFOV = drawFOV(xRobotTrue,fov,max_range,'b');
    PlotEllipse(xEst(1:3),PEst(1:3,1:3),5,'g');
    
    pause;
    
    delete(hFOV);
            
    u = [3;0;0];
 
    % Number of steps
    nSteps = 195;
    turning = 50;
    
    % Storage:
    PFeatDetStore = NaN*zeros(nFeatures,nSteps);
    FeatErrStore = NaN*zeros(nFeatures,nSteps);
    PXErrStore = NaN*zeros(1,nSteps);
    XErrStore = NaN*zeros(2,nSteps);% error in position and angle   
    
    for k = 2:nSteps
 
        %
        % Move the robot with a control action u
        %
 
        u(3) = 0;
        if (mod(k,turning)==0) u(3)=pi/2;end
 
        xRobot = tcomp(xRobot,u); % New pose without noise    
        noise = sqrt(R)*randn(3,1); % Generate noise
        noisy_u = tcomp(u,noise); % Apply noise to the control action        
        xRobotTrue = tcomp(xRobotTrue,noisy_u);
 
        % Useful vbles
        xVehicle = xEst(1:3);
        xMap = xEst(4:end);
 
        %
        % Prediction step
        %
        
        xVehiclePred = tcomp(xVehicle,u);
 
        PPredvv = J1(xVehicle,u)* PEst(1:3,1:3) *J1(xVehicle,u)' + J2(xVehicle,u)* R * J2(xVehicle,u)';
        PPredvm = J1(xVehicle,u)*PEst(1:3,4:end);
        PPredmm = PEst(4:end,4:end);
 
        xPred = [xVehiclePred;xMap];
        PPred = [PPredvv PPredvm;
                 PPredvm' PPredmm];
 
        % Get new observation/s
 
        if strcmp(mode,'one_landmark_in_fov')
            % Get a random observations within the fov of the sensor
            [MapInFov,iFeatures] = getObservationsInsideFOV(xRobotTrue,Map,fov,max_range);
            if ~isempty(MapInFov)             
                [z,iFeature] = getRandomObservationFromPose(xRobotTrue,MapInFov,Q,iFeatures);
            else
                z = [];
            end
        elseif strcmp(mode,'landmarks_in_fov')
            %
            % Point 4
            %
000000000;
        end
 
        %
        % Update step
        %
        
        if(~isempty(z))
            %have we seen this feature before?
            if( ~isnan(MappedFeatures(iFeature,1)))
 
                %predict observation: find out where it is in state vector
                FeatureIndex = MappedFeatures(iFeature,1);
                xFeature = xPred(FeatureIndex:FeatureIndex+1);
 
                zPred = getRangeAndBearing(xVehiclePred,xFeature);
 
                % get observation Jacobians
                [jHxv,jHxf] = GetObsJacs(xVehicle,xFeature);
 
                % Fill in state jacobian

                %
                % Point 2, Build jH from JHxv and jHxf
                %
                jH = zeros(2,length(xEst));
                jH(:,FeatureIndex:FeatureIndex+1) = jHxf;
                jH(:,1:3) = jHxv;
                 
                % Do Kalman update:
                Innov = z-zPred;
                Innov(2) = AngleWrap(Innov(2));
 
                S = jH*PPred*jH'+Q;
                W = PPred*jH'*inv(S);
                xEst = xPred+ W*Innov;
 
                PEst = PPred-W*S*W';
 
                %ensure P remains symmetric
                PEst = 0.5*(PEst+PEst');
            else
                % this is a new feature add it to the map....            
                nStates = length(xEst); 
 
                xFeature = xVehiclePred(1:2) + [z(1)*cos(z(2)+xVehiclePred(3));z(1)*sin(z(2)+xVehiclePred(3))];
                xEst = [xPred;xFeature]; %augmenting state vector
                [jGxv, jGz] = GetNewFeatureJacs(xVehicle,z);
 
                M = [eye(nStates), zeros(nStates,2);% note we don't use jacobian w.r.t vehicle
                    jGxv zeros(2,nStates-3)  , jGz]; 

                PEst = M*blkdiag(PEst,Q)*M';
 
                %remember this feature as being mapped we store its ID and position in the state vector
                MappedFeatures(iFeature,:) = [length(xEst)-1, length(xEst)];
 
            end;
        else
            xEst = xPred;
            PEst = PPred;
        end;

%
	% Point 3, Robot pose and features localization errors and determinants
       %
           %Storage:    
        for l = 1:nFeatures
            if (~isnan(MappedFeatures(l,1)))
                index = MappedFeatures(l,1);
                PFeatDetStore(l, k) = det(PEst(index:index+1, index:index+1));
                FeatErrStore(l, k) = norm(Map(1:2, l) - xEst(index:index+1));
            end
        end

        PXErrStore(:, k) = det(PEst(1:3, 1:3));
        XErrStore(:, k) = [norm(xRobot(1:2) - xRobotTrue(1:2));
            norm(xRobot(3) - xRobotTrue(3))];
 
        % Drawings
        if(mod(k-2,DrawEveryNFrames)==0)
            % Robot estimated, real, and ideal poses, fov and uncertainty
            DrawRobot(xEst(1:3),'g');
            DrawRobot(xRobotTrue,'b');
            DrawRobot(xRobot,'r');
            hFOV = drawFOV(xRobotTrue,fov,max_range,'b');
            PlotEllipse(xEst(1:3),PEst(1:3,1:3),5,'g');
 
            % A line to the observed feature
            if(~isnan(z))
                hLine = line([xRobotTrue(1),Map(1,iFeature)],[xRobotTrue(2),Map(2,iFeature)]);
                set(hLine,'linestyle',':');
            end;
            
            % The uncertainty of each perceived landmark
            n  = length(xEst);
            nF = (n-3)/2;            
            hEllipses = [];
            for i = 1:nF
                iF = 3+2*i-1;
                plot(xEst(iF),xEst(iF+1),'b*');
                hEllipse = PlotEllipse(xEst(iF:iF+1),PEst(iF:iF+1,iF:iF+1),3);
                hEllipses = [hEllipses hEllipse];
            end                  
            
            drawnow; % flush pending drawings events                 
            pause;
            
            % Clean a bit
            delete(hFOV);
            for i=1:size(hEllipses,2)
                delete(hEllipses(i));
            end
        end  
    end
 
    % Draw the final estimated positions and uncertainties of the features
    n  = length(xEst);
    nF = (n-3)/2;
    
    for i = 1:nF
        iF = 3+2*i-1;
        plot(xEst(iF),xEst(iF+1),'cs');
        PlotEllipse(xEst(iF:iF+1),PEst(iF:iF+1,iF:iF+1),3);
    end;  

    %
    % Draw erros and determinants of the location of the robot and the
    % featuers
    %
    
    figure(2); hold on;
    title('Errors in robot localization');
    plot(XErrStore(1,:),'b');    
    plot(XErrStore(2,:),'r');    
    legend('Error in position','Error in orientation')
    
    figure(3); hold on;
    title('Determinant of the cov. matrix associated to the robot localization');
    xs = 1:nSteps;
    plot(PXErrStore(:),'b');

    figure(4); hold on;
    title('Errors in features localization');
    figure(5); hold on;
    title('Log of the determinant of the cov. matrix associated to each feature');
    
    for i=1:nFeatures
        figure(5)        
        h = plot(log(PFeatDetStore(i,:)));    
        set(h,'Color',colors(i,:));
        
        figure(4)
        h = plot(FeatErrStore(i,:));
        set(h,'Color',colors(i,:));        
    end


%-------------------------------------------------------------------------%

function [Map,colors] = CreateMap(MapSize,nFeatures)
    Map = zeros(2,nFeatures);
    colors = zeros(nFeatures,3);
    
    for i_feat = 1:nFeatures
        Map(:,i_feat) = MapSize*rand(2,1)-MapSize/2;
        colors(i_feat,:) = [rand rand rand];
    end
 
%-------------------------------------------------------------------------%
 
function [jHxv,jHxf] = GetObsJacs(xPred, xFeature)
 
    jHxv = zeros(2,3);jHxf = zeros(2,2);
    Delta = (xFeature-xPred(1:2));
    r = norm(Delta);
    jHxv(1,1) = -Delta(1) / r;
    jHxv(1,2) = -Delta(2) / r;
    jHxv(2,1) = Delta(2) / (r^2);
    jHxv(2,2) = -Delta(1) / (r^2);
    jHxv(2,3) = -1;
    jHxf(1:2,1:2) = -jHxv(1:2,1:2);
 
%-------------------------------------------------------------------------%
 
function [jGx,jGz] = GetNewFeatureJacs(Xv, z)
 
    theta = Xv(3,1);
    r = z(1);
    bearing = z(2);
    jGx = [ 1   0   -r*sin(theta + bearing);
        0   1   r*cos(theta + bearing)];
    jGz = [ cos(theta + bearing) -r*sin(theta + bearing);
        sin(theta + bearing) r*cos(theta + bearing)];
 
%-------------------------------------------------------------------------%
 
function h = drawFOV(x,fov,max_range,c)
 
    if nargin < 4; c = 'b'; end
    
    alpha = fov/2;
    angles = -alpha:0.01:alpha;
    nAngles = size(angles,2);
    arc_points = zeros(2,nAngles);
    
    for i=1:nAngles
       arc_points(1,i) =  max_range*cos(angles(i));
       arc_points(2,i) =  max_range*sin(angles(i));
 
       aux_point = tcomp(x,[arc_points(1,i);arc_points(2,i);1]);
       arc_points(:,i) = aux_point(1:2);
    end
 
    h = plot([x(1) arc_points(1,:) x(1)],[x(2) arc_points(2,:) x(2)],c);
 
 
%-------------------------------------------------------------------------%
 
 
function [MapInFov,iFeatures] = getObservationsInsideFOV(x,Map,fov,max_range)
   
    nLandmarks = size(Map,2);    
    MapInFov = [];
    iFeatures = [];
    z = zeros(2,1);
    
    for i_landmark = 1:nLandmarks
        Delta_x = Map(1,i_landmark) - x(1);
        Delta_y = Map(2,i_landmark) - x(2);
 
        z(1) = norm([Delta_x Delta_y]);        % Range
        z(2) = atan2(Delta_y,Delta_x) - x(3);  % Bearing
       z(2) = AngleWrap(z(2));
 
        if (z(2) < fov/2) && (z(2) > -fov/2) && (z(1) < max_range)
            MapInFov = [MapInFov Map(:,i_landmark)];
            iFeatures = [iFeatures i_landmark];
        end
    end
    
%-------------------------------------------------------------------------%
 
function [z,iFeature] = getRandomObservationFromPose(x,Map,Q,iFeatures)
 
    nLandmarks = size(Map,2);
    iFeature = randi(nLandmarks);
    landmark = Map(:,iFeature);
 
    z = getRangeAndBearing(x,landmark,Q);
    
    if nargin == 4
        iFeature = iFeatures(iFeature);
    end
    
%-------------------------------------------------------------------------%
    
function z = getRangeAndBearing(x,landmark,Q)
 
    Delta_x = landmark(1,:) - x(1);
    Delta_y = landmark(2,:) - x(2);
 
    z(1,:) = sqrt(Delta_x.^2 + Delta_y.^2);  % Range
    z(2,:) = atan2(Delta_y,Delta_x) - x(3);  % Bearing
    
    if nargin == 3
        z = z + sqrt(Q)*rand(2,1); % Adding noise
    end
    
    z(2,:) = AngleWrap(z(2,:));
