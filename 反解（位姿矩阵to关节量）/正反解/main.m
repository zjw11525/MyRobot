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

%zero
Q_zero = [0,-90,0,0,0,0];%抓手- > 底座

Q_zero = Q_zero(end:-1:1);
%纠正角度
Q_bias = [1,-1,-1,1,1,-1];
Q_zero = Q_zero .* Q_bias;
%正解
RobotPose=Fkine_Step(Q_zero);%手写正解函数

% RobotPose(3,4) = 0.4297;%z
% %设定点
%RobotPose(1,4) = 0.5246;%z
%设定点
% RobotPose(2,4) = 0.2;%z
%设定点

Q_last = [0,0,0,0,0,0];
%反解
Q_Ikine = Ikine_Step(RobotPose,Q_last);
RobotPose = Fkine_Step(Q_Ikine)%手写正解函数

%纠正角度
Q_bias = [1,-1,-1,1,1,-1];
Q_Ikine = Q_Ikine .* Q_bias
% 
% %显示
Q_plot= Q_Ikine .* [pi/180,pi/180,pi/180,pi/180,-pi/180,pi/180] + [0,-pi/2,0,0,0,0];
starobot.plot(Q_plot);


%teach(starobot);
% PS:这个手写的函数仅适用于DH模型。
% alpha:连杆扭角； 
% a:连杆长度； 
% theta:关节转角； 
% d:关节偏移； 
% offset:偏移