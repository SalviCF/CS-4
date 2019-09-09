
% This function draws a ellipse representing a Gaussian centered at x (mean) and with covariance P 
% This code has been taken from the file DoVehicleGraphics.m by P.% Newman http://www.robots.ox.ac.uk/~pnewman

function eH = PlotEllipse(x,P,nSigma, color)
% P is the covariance matrix, of any dimension, but only the upper 2-by-2
% submatrix is considered
% nSigma: number of sigma we want to plot (scale factor)
% x: the center of the ellipse (i.e. the mean of the distribution) 
eH = [];
P = P(1:2,1:2); % only plot x-y part
x = x(1:2);
if(~any(diag(P)==0))
    [V,D] = eig(P); %V: eigenvectors, D: eigenvalues
    y = nSigma*[cos(0:0.1:2*pi);sin(0:0.1:2*pi)]; %Points of a circunference o radius nSigma
    axes = V*sqrtm(D); % Axes of the ellipse, 2-by-2 matriz
    el = axes*y; % Points of the ellipse
    el = [el el(:,1)];% To close the ellipse
    el =  el+repmat(x,1,size(el,2)); % To translate it according to the robot pose
    if nargin==4
        eH = line(el(1,:),el(2,:),'color',color); %creates a line object and plot the ellipse
    else
        eH = line(el(1,:),el(2,:)); %creates a line object and plot the ellipse
    end
end;

