function Jinv=Jinv(tab)
% Jacobian of the inverse of a pose

if size(tab,1) ~= 3,
   error('J tab is not a transformation!!!');
end;

s = sin(tab(3));
c = cos(tab(3));

 %Monroy
 Jinv = [-c -s tab(1)*s-tab(2)*c
         s -c tab(1)*c+tab(2)*s
         0 0 -1];