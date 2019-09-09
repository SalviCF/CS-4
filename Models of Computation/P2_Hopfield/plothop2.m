function plothop2(T,beta,uinit,eta,iters)
%plothop2(T,beta,uinit,eta,iters)
%
%PLOTHOP2
%
% This function simulates a two neuron Hopfield net by calling
% simhop and then plots the resulting traces in the u and V phase planes.
%
% T     is the connection matrix (should be symmetric)
% beta  is the gain of the activation function (tanh by befault)
% uinit is the initial condition vector for the u's
% eta   is the timestep for the Euler integration
% iters is the number of iterations to simulate
%

[utrace,vtrace] = simhop(T,beta,uinit,eta,iters);

figure(1)
plot(utrace(1,:),utrace(2,:),'o',utrace(1,:),utrace(2,:));
axis([-1.5 1.5 -1.5 1.5]); grid; 
title('u Phase Plane'); xlabel('u1'); ylabel('u2');

figure(2)
plot(vtrace(1,:),vtrace(2,:),'o',vtrace(1,:),vtrace(2,:));
axis([-1 1 -1 1]); grid;
title('V Phase Plane'); xlabel('V1'); ylabel('V2');

