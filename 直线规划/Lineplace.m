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

Q_zero = [0,0,0,0,-90,0];%底座- > 抓手
Q_last = [0,0,0,0,0,0];
%正解出原始位姿
RobotPose = Fkine_Step(Q_zero);

%原始位姿作为起点
T1 = RobotPose;
Q_Start = Ikine_Step(T1,Q_last);%反解
%平移
trans = [
    1  0  0   0.1;
    0  1  0  -0.3;
    0  0  1  -0.4;
    0  0  0     1 ];
%终点
T2 = trans*RobotPose;
Q_Mid = Ikine_Step(T2,Q_last);%反解
%平移
trans = [
    1  0  0   -0.1;
    0  1  0   0.3;
    0  0  1   0.4;
    0  0  0     1 ];
%终点
T3 = trans*T2;

%%五次多项式规划
%曲线段
for i = 1:6
    q(:,i) = moveL5(Q_Start(i),Q_Mid(i));
end
%直线段
for i = 1:3
    Tj2(:,i) = moveL5(T2(i,4),T3(i,4));
end

%反解直线段关节量
for i = 1:length(Tj2)
    T3(1,4) = Tj2(i,1);
    T3(2,4) = Tj2(i,2);
    T3(3,4) = Tj2(i,3);
    q1(i,:) = Ikine_Step(T3,Q_last);
end

%拼接两段轨迹
qmove = [q;q1];
%显示插补路径
figure(2);
qplot = qmove;

% for i = 1:length(qplot)
%     qplot(i,5) = qplot(i,5) + 90;
% end 

for i = 1:6     
    plot(qplot(:,i));
    hold on;
end

%正解出位姿变化，用于绘图
for i = 1:length(q)
    T(:,:,i) = Fkine_Step(q(i,:));
    Tj(i,1) = T(1,4,i);
    Tj(i,2) = T(2,4,i);
    Tj(i,3) = T(3,4,i);
end

figure(3);
plot3(Tj(:,1),Tj(:,2),Tj(:,3),'color',[1,0,0],'LineWidth',2);%输出末端轨迹
hold on;
plot3(Tj2(:,1),Tj2(:,2),Tj2(:,3),'color',[0,1,0],'LineWidth',2);%输出末端轨迹


for i = 1:length(qmove)
    Q_plot = qmove(i,:) .* [pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];%转弧度
    starobot.plot(Q_plot);%动画演示
end

