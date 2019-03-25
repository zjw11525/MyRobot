clear;
clc;
%建立机器人模型
%       theta    d           a        alpha     offset
ML1=Link([0       0.28        0           0          0     ],'modified'); 
ML2=Link([0       0           0.34966093 -pi/2       0     ],'modified');
ML3=Link([0       0           0           0          0     ],'modified');
ML4=Link([0       0.35014205  0          -pi/2       0     ],'modified');
ML5=Link([0       0           0           pi/2       0     ],'modified');
ML6=Link([0       0.0745      0          -pi/2       0     ],'modified');
modrobot=SerialLink([ML1 ML2 ML3 ML4 ML5 ML6],'name','PUMA 560');
modt06=modrobot.fkine([0,0,0,0,pi/2,0]) %工具箱正解函数
modmyt06=myfkine(0,0,0,0,pi/2,0)        %手写的正解函数
modrobot.plot([0,0,0,0,pi/2,0]);
%PS:这个手写的函数仅适用于改进DH模型。
% alpha:连杆扭角； 
% a:连杆长度； 
% theta:关节转角； 
% d:关节偏移； 
% offset:偏移