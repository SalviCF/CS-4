function tac=tcomp(tab,tbc)
%Composition of transformations given by poses
if size(tab,1) ~= 3,
   error('TCOMP: tab is not a valid transformation!');
end;

if size(tbc,1) ~= 3,
   error('TCOMP: tbc is not a  valid transformation!');
end;

ang = tab(3)+tbc(3);

if ang > pi | ang <= -pi
   ang = AngleWrap(ang);
end

s = sin(tab(3));
c = cos(tab(3));
tac = [tab(1:2)+ [c -s; s c]*tbc(1:2);
       ang];