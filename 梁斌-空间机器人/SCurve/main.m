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

Q_zero = [0,0,0,0,90,0];%底座 -> 抓手
Angle_Last = Q_zero + [0,90,0,0,0,0];
pose_start = Fkine_Final(Q_zero)%正解

%平移
trans = [1  0  0  0.1;
         0  1  0  0.2;
         0  0  1  -0.4;
         0  0  0  1;];
pose_end = trans*pose_start;

x = linemove(pose_start(1,4),pose_end(1,4),0.2,0.1);
y = linemove(pose_start(2,4),pose_end(2,4),0.2,0.1);
z = linemove(pose_start(3,4),pose_end(3,4),0.2,0.1);

for i = 1:50
    pose_end(1,4) = x(i);
    pose_end(2,4) = y(i);
    pose_end(3,4) = z(i);
    q(i,:) = Ikine_Step(pose_end,Q_zero);%反解
end

figure(2);
for i = 1:6
plot(q(:,i));
hold on;
end

figure(3);
plot3(x(1,:),y(1,:),z(1,:),'color',[1,0,0],'LineWidth',2);



for i = 1:50
    q(i,:) = q(i,:).*[pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
    robot.plot(q(i,:));
end


