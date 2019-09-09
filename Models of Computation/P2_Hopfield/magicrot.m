function R = magicrot(pat)
% R = magicrot(pat)
%
% MAGICROT
%
% This function finds a decorrelating rotation for a small number
% of patterns.
%
%   pat is a d x N matrix (where N < d) whose columns are +/- 1 vectors
%   R is a "rotation" matrix which maps the column vectors of pat
%     into almost uncorrelated vectors in upat = R * pat.

[d,N] = size(pat);
X = [ pat 2*(rand(d,d-N)>.5)-1];
Z = 2*(rand(d,d)>.5) - 1; 
R = Z / X; 


