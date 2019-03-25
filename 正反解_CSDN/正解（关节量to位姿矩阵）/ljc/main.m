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
starobot=SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','standard');
% Q_zero = [0,-pi/2,0,0,0,0];
% starobot.plot(Q_zero);%zero
% stat06=starobot.fkine(Q_zero)%工具箱正解函数
Q_zero = [0,0,0,0,0,0];
stamyt06=Fkine_Step(Q_zero)%手写正解函数
%teach(starobot);
% PS:这个手写的函数仅适用于DH模型。
% alpha:连杆扭角； 
% a:连杆长度； 
% theta:关节转角； 
% d:关节偏移； 
% offset:偏移