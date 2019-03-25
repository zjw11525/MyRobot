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
SL2.offset = -pi/2;%与实际机器人原始位置保持一致
starobot=SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','standard');

Q_zero = [0,0,0,0,-90,0];%底座 -> 抓手
%正解出原始位姿
RobotPose = Fkine_Step(Q_zero);

%原始位姿作为起点
T1 = RobotPose;

%平移
trans = [
    1  0  0  0.1;
    0  1  0  -0.2;
    0  0  1  -0.2;
    0  0  0  1 ];

%终点
T2 = trans*RobotPose;

% T=ctraj(T1,T2,50);%规划
% Tj=transl(T);
%三次多项式
% x = moveL1(T1(1,4),T2(1,4));
% y = moveL1(T1(2,4),T2(2,4));
% z = moveL1(T1(3,4),T2(3,4));
%五次多项式
x = moveL5(T1(1,4),T2(1,4));
y = moveL5(T1(2,4),T2(2,4));
z = moveL5(T1(3,4),T2(3,4));

for i = 1:51
    T1(1,4) = x(i);
    T1(2,4) = y(i);
    T1(3,4) = z(i);
    T(:,:,i) = T1;
end

for i = 1:51
  Tj(i,:,:,:) = [x(i),y(i),z(i)];
end
figure(2);
plot3(Tj(:,1),Tj(:,2),Tj(:,3),'color',[1,0,0],'LineWidth',2);%输出末端轨迹

Q_last = [0,0,0,0,0,0];

for i = 1: 51 
Q_Ikine = Ikine_Step(T(:,:,i),Q_last)%反解
Q_plot = Q_Ikine .* [pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];%转弧度
Q(i,:) = Q_plot;
starobot.plot(Q_plot);%动画演示
end
% 
% figure(2);
% for i = 1:6
% plot(Q(:,i));
% hold on;
% end
