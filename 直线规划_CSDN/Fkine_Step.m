function T = Fkine_Step (Theta)
T = zeros(4);

%µ¹Ðò
% Theta = Theta(end:-1:1);

%¾ÀÕý½Ç¶È
Q_bias = [1,-1,-1,1,1,-1];
Theta = Theta .* Q_bias;
Q_bias = [1,1,1,1,-1,-1];
Theta = Theta .* Q_bias;

d1 = 0.28;
d4 = 0.35014205;
d6 = 0.0745;
a2 = 0.34966093;

s1 = sind(Theta(1));
c1 = cosd(Theta(1));

s2 = sind(Theta(2));
c2 = cosd(Theta(2));

s23 = sind(Theta(2)+Theta(3));
c23 = cosd(Theta(2)+Theta(3));

s4 = sind(Theta(4));
c4 = cosd(Theta(4));

s5 = sind(Theta(5));
c5 = cosd(Theta(5));

s6 = sind(Theta(6));
c6 = cosd(Theta(6));

a = s1*c4 + c1*s4*s23;
b = s1*s4 - c1*c4*s23;
d = c1*c4 - s1*s4*s23;
c = c1*s4 + s1*c4*s23;
e = c5*s23 + c4*s5*c23;
f = s5*s23 - c4*c5*c23;

T(1,1) = s6*a + c6*(c5*b - s5*c1*c23);
T(1,2) = c6*a - s6*(c5*b - s5*c1*c23);
T(1,3) = s5*b + c5*c1*c23;
T(1,4) = d6*(s5*b + c5*c1*c23) + d4*c1*c23 - a2*c1*s2;

T(2,1) = -s6*d - c6*(c5*c + s5*s1*c23);
T(2,2) = s6*(c5*c + s5*s1*c23) - c6*d;
T(2,3) = -s5*c + c5*s1*c23;
T(2,4) = d4*s1*c23 - d6*(s5*c - c5*s1*c23) - a2*s1*s2;

T(3,1) = -c6*f - s4*s6*c23;
T(3,2) = s6*f - c6*s4*c23;
T(3,3) = e;
T(3,4) = d1 + d4*s23 + a2*c2 + d6*e;

T(4,4) = 1;

% 
% T(1,1) = s6*(c4*s1 + s4*c1*s23) + c6*(c5*(s1*s4 - c4*c1*s23) - s5*c1*c23);
% T(1,2) = c6*(c4*s1 + s4*c1*s23) - s6*(c5*(s1*s4 - c4*c1*s23) - s5*c1*c23);
% T(1,3) = s5*(s1*s4 - c4*c1*s23) + c5*c1*c23;
% T(1,4) = d6*(s5*(s1*s4 - c4*c1*s23) + c5*c1*c23) + d4*c1*c23 - a2*c1*s2;
% 
% T(2,1) = -s6*(c1*c4 - s4*s1*s23) - c6*(c5*(c1*s4 + c4*s1*s23) + s5*s1*c23);
% T(2,2) = s6*(c5*(c1*s4 + c4*s1*s23) + s5*s1*c23) - c6*(c1*c4 - s4*s1*s23);
% T(2,3) = -s5*(c1*s4 + c4*s1*s23) + c5*s1*c23;
% T(2,4) = d4*s1*c23 - d6*(s5*(c1*s4 + c4*s1*s23) - c5*s1*c23) - a2*s1*s2;
% 
% T(3,1) = -c6*(s5*s23 - c4*c5*c23) - s4*s6*c23;
% T(3,2) = s6*(s5*s23 - c4*c5*c23) - c6*s4*c23;
% T(3,3) = c5*s23 + c4*s5*c23;
% T(3,4) = d1 + d4*s23 + a2*c2 + d6*(c5*s23 + c4*s5*c23);
% 
% T(4,4) = 1;









