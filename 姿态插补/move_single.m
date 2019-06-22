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


Q_start = [0,0,0,0,0,0];

Q_zero = [0,0,0,0,90,0];%底座 -> 抓手
Angle_Last = Q_zero;
pose_start = Fkine_Step(Q_zero);%正解
pose_end = pose_start;
%位置
pose_end(1,4) = 0;
pose_end(2,4) = 0.5;
pose_end(3,4) = 0.3;
xtrans = pose_end(1,4) - pose_start(1,4);
ytrans = pose_end(2,4) - pose_start(2,4);
ztrans = pose_end(3,4) - pose_start(3,4);

Q_End = Ikine_Step(pose_end,Q_zero);


v = 0.2;%运动速度0.1m/s
t = 0.001;%插补周期1ms（plc周期）
L = sqrt(xtrans^2 + ytrans^2 + ztrans^2);%distance
N = ceil(L/(v*t));%插补数量
ta = 0.5;%加减速时间0.5s
s = trilinemove(v,ta,N,t);

for i = 1:N
qout(1,i) = Q_start(1) + (Q_End(1)-Q_start(1))*s(i);
qout(2,i) = Q_start(2) + (Q_End(2)-Q_start(2))*s(i);
qout(3,i) = Q_start(3) + (Q_End(3)-Q_start(3))*s(i);
qout(4,i) = Q_start(4) + (Q_End(4)-Q_start(4))*s(i);
qout(5,i) = Q_start(5) + (Q_End(5)-Q_start(5))*s(i);
qout(6,i) = Q_start(6) + (Q_End(6)-Q_start(6))*s(i);
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


