function disppat(thepat)
% disppat(thepat)
%
% Displays a binary (-1/+1) vector 100 elements long as a 10x10 matrix.

colormap('gray');
imagesc(reshape(thepat(:),10,10),[-1 1]);
axis('square');

