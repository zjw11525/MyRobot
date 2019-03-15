function [T06]=mystafkine(theta1,theta2,theta3,theta4,theta5,theta6)
SDH=[theta1   0.28    0         -pi/2;
     theta2-pi/2   0       0.34966093    0;
     theta3   0       0         -pi/2;
     theta4   0.35014205   0     pi/2;
     theta5   0       0         -pi/2;
     theta6   0.0745  0            0];

 T01=[cos(SDH(1,1))  -sin(SDH(1,1))*cos(SDH(1,4))   sin(SDH(1,1))*sin(SDH(1,4))    SDH(1,3)*cos(SDH(1,1));
      sin(SDH(1,1))   cos(SDH(1,1))*cos(SDH(1,4))  -cos(SDH(1,1))*sin(SDH(1,4))    SDH(1,3)*sin(SDH(1,1));
      0               sin(SDH(1,4))                 cos(SDH(1,4))                  SDH(1,2);
      0               0                             0                              1];
 T12=[cos(SDH(2,1))  -sin(SDH(2,1))*cos(SDH(2,4))   sin(SDH(2,1))*sin(SDH(2,4))    SDH(2,3)*cos(SDH(2,1));
      sin(SDH(2,1))   cos(SDH(2,1))*cos(SDH(2,4))  -cos(SDH(2,1))*sin(SDH(2,4))    SDH(2,3)*sin(SDH(2,1));
      0               sin(SDH(2,4))                 cos(SDH(2,4))                  SDH(2,2);
      0               0                             0                              1];
 T23=[cos(SDH(3,1))  -sin(SDH(3,1))*cos(SDH(3,4))   sin(SDH(3,1))*sin(SDH(3,4))    SDH(3,3)*cos(SDH(3,1));
      sin(SDH(3,1))   cos(SDH(3,1))*cos(SDH(3,4))  -cos(SDH(3,1))*sin(SDH(3,4))    SDH(3,3)*sin(SDH(3,1));
      0               sin(SDH(3,4))                 cos(SDH(3,4))                  SDH(3,2);
      0               0                             0                              1];
 T34=[cos(SDH(4,1))  -sin(SDH(4,1))*cos(SDH(4,4))   sin(SDH(4,1))*sin(SDH(4,4))    SDH(4,3)*cos(SDH(4,1));
      sin(SDH(4,1))   cos(SDH(4,1))*cos(SDH(4,4))  -cos(SDH(4,1))*sin(SDH(4,4))    SDH(4,3)*sin(SDH(4,1));
      0               sin(SDH(4,4))                 cos(SDH(4,4))                  SDH(4,2);
      0               0                             0                              1];
 T45=[cos(SDH(5,1))  -sin(SDH(5,1))*cos(SDH(5,4))   sin(SDH(5,1))*sin(SDH(5,4))    SDH(5,3)*cos(SDH(5,1));
      sin(SDH(5,1))   cos(SDH(5,1))*cos(SDH(5,4))  -cos(SDH(5,1))*sin(SDH(5,4))    SDH(5,3)*sin(SDH(5,1));
      0               sin(SDH(5,4))                 cos(SDH(5,4))                  SDH(5,2);
      0               0                             0                              1];
 T56=[cos(SDH(6,1))  -sin(SDH(6,1))*cos(SDH(6,4))   sin(SDH(6,1))*sin(SDH(6,4))    SDH(6,3)*cos(SDH(6,1));
      sin(SDH(6,1))   cos(SDH(6,1))*cos(SDH(6,4))  -cos(SDH(6,1))*sin(SDH(6,4))    SDH(6,3)*sin(SDH(6,1));
      0               sin(SDH(6,4))                 cos(SDH(6,4))                  SDH(6,2);
      0               0                             0                              1];

 T06=T01*T12*T23*T34*T45*T56;
