function T = Fkine_Final(Theta)

%D-H 参数
d1 = 0.28;
d4 = 0.35014205;
d6 = 0.0745;
a2 = 0.34966093;
Theta(2) = Theta(2) - 90;%offset

%计算三角函数
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

a = c23*(c4*c5*c6 - s4*s6) - s23*s5*c6;
b = c23*(-c4*c5*s6 - s4*c6) + s23*s5*s6;
c = -c23*c4*s5 - s23*c5;
d = -c23*c4*s5*d6 - s23*(c5*d6 + d4) + a2*c2;
e = s23*(c4*c5*c6 - s4*s6) + c23*s5*c6;
f = s23*(-c4*c5*s6 - s4*c6) - c23*s5*s6;
g = -s23*c4*s5 + c23*c5;
h = -s23*c4*s5*d6+c23*(c5*d6 + d4) + a2*s2;
i = -s4*c5*c6 - c4*s6;
j = s4*c5*s6 - c4*c6;
k = s4*s5;
l = s4*s5*d6;


T(1,1) = c1*a - s1*i;
T(1,2) = c1*b - s1*j;
T(1,3) = c1*c - s1*k;
T(1,4) = c1*d - s1*l;
T(2,1) = s1*a + c1*i;
T(2,2) = s1*b + c1*j;
T(2,3) = s1*c + c1*k;
T(2,4) = s1*d + c1*l;
T(3,1) = -e;
T(3,2) = -f;
T(3,3) = -g;
T(3,4) = -h+d1;
T(4,4) = 1;

