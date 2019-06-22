clear all;
clc;
% 建立机器人模型
%       theta    d           a              alpha     offset
SL1=Link([0       0.28        0             -pi/2        0     ],'standard');
SL2=Link([0       0           0.34966093     0           0     ],'standard');
SL3=Link([0       0           0             -pi/2        0     ],'standard');
SL4=Link([0       0.35014205  0              pi/2        0     ],'standard');
SL5=Link([0       0           0             -pi/2        0     ],'standard');
SL6=Link([0       0.0745      0              0           0     ],'standard');
SL2.offset = -pi/2;
robot=SerialLink([SL1 SL2 SL3 SL4 SL5 SL6],'name','standard');
% 计算插补点数
Q_zero = [0,0,0,0,90,0];%底座 -> 抓手
Angle_Last = Q_zero;
pose_start = Fkine_Step(Q_zero)%正解
%平移
trans = [1  0  0  -0.3501;
         0  1  0  0.5;
         0  0  1  -0.3552;
         0  0  0  1;];
pose_mid = trans*pose_start

trans1 = [1  0  0  0;
         0  1  0  0;
         0  0  1  -0.1;
         0  0  0  1;];
pose_end = trans1*pose_mid

v = 0.1;%运动速度0.1m/s
t = 0.001;%插补周期1ms（plc周期）
L = sqrt(trans1(1,4)^2 + trans1(2,4)^2 + trans1(3,4)^2);%distance
N = ceil(L/(v*t));%插补数量

ta = 0.5;%加减速时间0.5s

s = trilinemove(v,ta,N,t);

for i = 1:N
x(i) = pose_mid(1,4) + trans1(1,4)*s(i);
y(i) = pose_mid(2,4) + trans1(2,4)*s(i);
z(i) = pose_mid(3,4) + trans1(3,4)*s(i);
end

stepNum = N;

for i = 1:stepNum
    pose_mid(1,4) = x(i);
    pose_mid(2,4) = y(i);
    pose_mid(3,4) = z(i);
    qout(:,i) = Ikine_Step(pose_mid,Angle_Last);
end


figure(2);
for i = 1:6 
    subplot(3,1,2);
    plot(diff(qout(i,:)));
    hold on;
end
for i = 1:6 
    subplot(3,1,3);
    plot(diff(diff(qout(i,:))));
    hold on;
end
for i = 1:6 
    subplot(3,1,1);
    plot(qout(i,:));    
    hold on;
end

% 减速比
Ratio1 = 121;
Ratio2 = 160.68;
Ratio3 = 101.81;
Ratio4 = 99.69;
Ratio5 = 64.56;
Ratio6 = 49.99;

Ratio = [Ratio1,Ratio2,Ratio3,Ratio4,Ratio5,Ratio6];

for i = 1:length(qout)
    qout1(i,:) = qout(:,i)'.*Ratio / 2; 
    qout1(i,:) = qout1(i,:) .* [1 1 1 1 -1 -1];
end


format short;
%输出文件
Pos = roundn(qout1,-4);
T=table(Pos);
fid = fopen('Pos.txt','wt+');
fprintf(fid,'%-8.4f,%-8.4f,%-8.4f,%-8.4f,%-8.4f,%-8.4f,\n',Pos.');
writetable(T,'Pos.csv');


j=1;
for i = 1:100:N 
    qplot(:,j) = qout(:,i)'.*[pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
    j=j+1;
end

figure(3);
for i = 1:j-1
    robot.plot(qplot(:,i)')
end
