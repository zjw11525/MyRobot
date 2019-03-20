clear;
clc;
%建立机器人模型
%       theta    d           a              alpha     offset
SL1=Link([0       0.28        0             -pi/2        0     ],'standard');
SL2=Link([0       0           0.34966093     0           0     ],'standard');
SL3=Link([0       0           0             -pi/2        0     ],'standard');
SL4=Link([0       0.35014205  0              pi/2        0     ],'standard');
SL5=Link([0       0           0             -pi/2        0     ],'standard');
SL6=Link([0       0.0745      0              0           0     ],'standard');
SL2.offset = -pi/2;
robot=SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','standard');

Q_zero1 = [10,20,20,10,0,0];%底座 -> 抓手
p1 = Fkine_Final(Q_zero1)%手写正解

q1 = Ikine_Step(p1,Q_zero1)
% q1 = robot.ikine(p1)
% robot.plot(q1);




%转弧度
% Q_zero = Q_zero1.* [pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
% p = robot.fkine(Q_zero);
% q = robot.ikine(p)
% robot.plot(q);
