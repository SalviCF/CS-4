function [utrace,vtrace] = simhopdiscrete(T,beta,uinit,eta,iters)
%[utrace,vtrace] = simhop(T,beta,uinit,eta,iters)
%
%SIMHOPDISCRETE 
%
%This function simulates a Hopfield network using simple discrete hiperbolic tangent function.
%
% T     is the connection matrix (should be symmetric)
% beta  is the gain of the activation function (tanh by befault)
% uinit is the initial condition vector for the u's
% eta   is the timestep for the Euler integration (Not used bt left for compatibility)
% iters is the number of iterations to simulate
%
% utrace   is the u vector state of the network over time, 
%          one column per timestep in the simulation
% vtrace   is the V vector state of the network over time, 
%          one column per timestep in the simulation

N = size(T,1);
utrace = zeros(N,iters);
vtrace = zeros(N,iters);

% put the initial conditions in the first column of the trace

utrace(:,1) = uinit(:);  %initial state */
vtrace(:,1) = tanh(beta*utrace(:,1));

for i=2:iters
%%  /* du=( utrace(:,i-1)+T*vtrace(:,i-1) ) * eta ; */
  utrace(:,i) = T*vtrace(:,i-1);
  vtrace(:,i) = signhop(utrace(:,i),utrace(:,i-1));
end

