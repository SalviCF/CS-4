function Potential_Fields

    clear all;
    close all;

    % Visualization modes
    %mode = 'step_by_step';
    mode = 'non_stop';

    % Configuration of the map
    nObstacles = 75;
    MapSize = 100;
    Map = MapSize*rand(2,nObstacles);

    % Drawings
    figure(1); hold on; set(gcf,'doublebuffer','on');
    plot(Map(1,:),Map(2,:),'ro');
    disp('Mark the starting point')
    xStart = ginput(1)'
    disp('Mark the destination point')
    xGoal = ginput(1)'
    plot(xGoal(1),xGoal(2),'gp','MarkerSize',10);

    % Initialization of useful vbles
    xRobot = xStart;
    GoalError =  xGoal - xRobot;
    Hr = DrawRobot([xRobot;0],'b',[]);

    % Algorithm configuration
    RadiusOfInfluence = 10; % Objects far away of this radius does not influence
    KGoal= 1;   % Gain for the goal (attractive) field
    KObstacles = 250; % Gain for the obstacles (repulsive) field

    % Simulation configuration
    k = 0;
    nMaxSteps = 300;

    while(norm(GoalError)>1 && k<nMaxSteps)

        %find distance to all entities
        Dp = Map-repmat(xRobot,1,nObstacles);
        Distance = sqrt(sum(Dp.^2));
        iInfluencial = find(Distance<RadiusOfInfluence);

        %
        % Compute repulsive (obstacles) potential field
        %

        if(~isempty(iInfluencial))
	  %
            % Point 1.1
            hInfluentialObstacles = plot(Map(1, iInfluencial), Map(2, iInfluencial), '*');
            distance = Distance(iInfluencial);
            difference = -Dp(:, iInfluencial);
            f_i = (1 ./ distance - 1/RadiusOfInfluence) .* 1/RadiusOfInfluence^2 .* difference ./ distance;
            
            FRep = KObstacles * sum(f_i,2);
      %
        else %nothing close
	 %
           % Point 1.1
           FRep = [0 ; 0];
	 %
        end

        %
        % Compute attractive (goal) potential field
        %
	 
	%
          % Point 1.2
          FAtt = ( -KGoal * (xRobot - xGoal) ) / norm(xRobot - xGoal);
	%

        %
        % Compute total (attractive+repulsive) potential field
        %

	%
          % Point 1.3
          FTotal = FAtt + FRep;
          
	%

        % New vehicle pose
        xRobot = xRobot + FTotal;
        Theta = atan2(FTotal(2),FTotal(1));

        % Drawings
        DrawRobot([xRobot;Theta],'k',Hr);
        drawnow;

        if strcmp(mode,'non_stop')
            pause(0.1); % for visibility purposes
        else
            pause;
        end

        if (~isempty(iInfluencial))
            set(hInfluentialObstacles,'Visible','off'); % handler of a plot showing a mark over the obstacles that are within the radius of influence of the robot. Do this plot at Point 1.1
        end

        % Update termination conditions
        GoalError =  xGoal - xRobot;
        k = k+1;

    end

%-------------------------------------------------------------------------%

function H = DrawRobot(Xr,col,H)

    p=0.005; % percentage of axes size    
    a=axis;
    l1=(a(2)-a(1))*p;
    l2=(a(4)-a(3))*p;
    P=[-1 1 0 -1; -1 -1 3 -1];%basic triangle
    theta = Xr(3)-pi/2;%rotate to point along x axis (theta = 0)
    c=cos(theta);
    s=sin(theta);
    P=[c -s; s c]*P; %rotate by theta
    P(1,:)=P(1,:)*l1+Xr(1); %scale and shift to x
    P(2,:)=P(2,:)*l2+Xr(2);
    if(isempty(H))
        H = plot(P(1,:),P(2,:),col,'LineWidth',0.1);% draw
    else
        set(H,'XData',P(1,:));
        set(H,'YData',P(2,:));
        plot(Xr(1),Xr(2),'b.','MarkerSize',10);
    end


