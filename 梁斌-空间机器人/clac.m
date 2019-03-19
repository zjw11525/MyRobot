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
      0  0  0  1;]
  
A4 = [c4 0  s4 0;
      s4 0 -c4 0;
      0  1  0  d4;
      0  0  0  1;]
  
A2A3 = [c23 0 -s23 a2*c2;
        s23 0  c23 a2*s2;
        0  -1  0   0;
        0   0  0   1;]


A5A6 = [c5*c6 -c5*s6  s5  d6*s5;
        s5*c6 -s5*s6 -c5 -d6*c5;
        s6     c6     0   0;
        0      0      0   1;]
  
  inv(A5A6)