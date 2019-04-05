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
robot = SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','SD700');
robot1 = SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','standard');
% robot = importrobot('Test_Link6.urdf');%导入机器人描述格式
% robot.DataFormat='column';%数据格式为列，row为行；为‘row'时q0要转置-->q0’
% robot.Gravity = [0 0 -9.80];%重力方向设置
% 
% q1 = [0; 0; 0; 0; 0; 0; 0; 0];%位置-->各关节为弧度值,8个单独关节运动.
% show(robot,q1,'PreservePlot',false);

% view([150 6]);%figure大小设置
% axis([-0.6 0.6 -0.6 0.6 0 1.35]);%坐标范围
% camva('auto');%设置相机视角
% daspect([1 1 1]);%控制沿每个轴的数据单位长度,要在所有方向上采用相同的数据单位长度，使用 [1 1 1] 


Q_zero1 = [0,0,0,0,90,0];%底座 -> 抓手
Angle_Last = Q_zero1 + [0,90,0,0,0,0];
p1 = Fkine_Final(Q_zero1)%正解
%平移
trans = [1  0  0  0.1;
         0  1  0 -0.2;
         0  0  1 -0.3;
         0  0  0  1;];
pose_end = trans*p1;
% pose_end = p1;

q1 = Ikine_Step(pose_end,Q_zero1)%反解
q2 = q1.*[pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
figure(1),robot.plot(q2);


% 转弧度
Q_zero = Q_zero1.* [pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
p = robot1.fkine(Q_zero);
%平移
p.t = [0.45014205;-0.2;0.25516093];

q = robot1.ikine(pose_end);
figure(2),robot1.plot(q);
q3 = q.*[180/pi,180/pi,180/pi,180/pi,180/pi,180/pi]