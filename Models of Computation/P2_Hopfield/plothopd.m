function plothopd(T,beta,uinit,eta,iters)
%plothopd(T,beta,uinit,eta,iters)
%
%PLOTHOPD
%
% This function simulates a 100 neuron Hopfield net by calling
% simhop and then shows a movie of the resulting V state vector trace
% arranged as a 10 by 10 picture.
%
% T     is the connection matrix (should be symmetric)
% beta  is the gain of the activation function (tanh by befault)
% uinit is the initial condition vector for the u's
% eta   is the timestep for the Euler integration
% iters is the number of iterations to simulate
%

%[utrace,vtrace] = simhopdiscrete(T,beta,uinit,eta,iters);
[utrace,vtrace] = simhopdiscrete(T,beta,uinit,eta,iters);

figure;
colormap('gray');

for i=1:iters
  imagesc(reshape(vtrace(:,i),10,10),[-1 1]);
  axis('square');
  drawnow;
end



