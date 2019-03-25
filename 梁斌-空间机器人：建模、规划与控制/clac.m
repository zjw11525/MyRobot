clc
clear

syms c1
syms c2
syms c3
syms c4
syms c5
syms c6
syms s1
syms s2
syms s3
syms s4
syms s5
syms s6
syms a2
syms d1
syms d4
syms d6
syms c23
syms s23

A1 = [c1 0 -s1 0;
      s1 0  c1 0;
      0 -1  0  d1;
      0  0  0  1;];
  
A4 = [c4 0  s4 0;
      s4 0 -c4 0;
      0  1  0  d4;
      0  0  0  1;];
A5 = [
    c5	0	-s5	0;
    s5	0	c5	0;
    0	-1	0	0;
    0	0	0	1;];
A6 = [
    c6	-s6	0	0;
    s6	c6	0	0;
    0	0	1	d6;
    0	0	0	1;];

A2A3 = [c23 0 -s23 a2*c2;
        s23 0  c23 a2*s2;
        0  -1  0   0;
        0   0  0   1;];

%求解theta5
syms nx;
syms ny;
syms nz;
syms ox;
syms oy;
syms oz;
syms ax;
syms ay;
syms az;
T03 = A1*A2A3
R03 = T03(1:3,1:3)
R06 = [nx ox ax;
       ny oy ay;
       nz oz az;]

aa = R03.'*R06

% A5A6 = [c5*c6 -c5*s6  s5  d6*s5;
%         s5*c6 -s5*s6 -c5 -d6*c5;
%         s6     c6     0   0;
%         0      0      0   1;]
  
%   inv(A5A6)
%   A1*A2A3*A4

%推导theta3 
% a1 = c1*(a2*c2 - d4*s23);
% a2 = s1*(a2*c2 - d4*s23);
% a3 =  - a2*s2 - d4*c23;

% syms a2c2
% syms a2s2
% syms d4s23
% syms d4c23

% a4 = (a2c2 - d4s23)*(a2c2 - d4s23)
% a4 = (a2*c2)^2 - 2*(a2*c2*d4*s23) + (d4*s23)^2
% % a5 = (a2s2 + d4c23)*(a2s2 + d4c23)
% a5 = (a2*s2)^2 + 2*(a2*s2*d4*c23) + (d4*c23)^2
% 
% a6 = a2^2 + d4^2 + 2*a2*d4(s2*c23 - c2*s23)


%%推导theta2
% d1 - pz + d6az = a2s2 + d4c23  %  c23 = c2c3 – s2s3
% d1 - pz + d6az = a2s2 + d4c2c3 - d4s2s3 = (a2-d4s3)s2 + d4c2c3

  