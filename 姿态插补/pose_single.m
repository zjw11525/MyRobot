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
Q_zero = [0,0,0,0,0,0];%底座 -> 抓手
Angle_Last = Q_zero;
pose_start = Fkine_Step(Q_zero)%正解

v = 0.2;%运动速度0.1m/s
t = 0.001;%插补周期1ms（plc周期）
N = 30;%插补数量
ta = 0.3;%加减速时间0.5s

s = trilinemove(v,ta,N,t);

stepNum = N;

%判断路径,取路径短的，不影响方向
%欧拉角转四元数
EulerAngleStart = [0/180*pi,0/180*pi,0/180*pi];
EulerAngleEnd = [0/180*pi,90/180*pi,0/180*pi];
p1_Q =  angle2quat(EulerAngleStart(1),EulerAngleStart(2),EulerAngleStart(3));
p3_Q =  angle2quat(EulerAngleEnd(1),EulerAngleEnd(2),EulerAngleEnd(3));

cosa = p1_Q(1)*p3_Q(1)+p1_Q(2)*p3_Q(2)+p1_Q(3)*p3_Q(3)+p1_Q(4)*p3_Q(4);
if cosa < 0
    p3_Q = -p3_Q;
end

pt_Q = zeros(4,stepNum);
AngleOut = zeros(3,stepNum);
sina = sqrt(1 - cosa*cosa);
angle = atan2( sina, cosa );

for step = 0:1: stepNum-1
%     k0 = sin((1-step/stepNum)*angle)/sina;
%     k1 = sin(step/stepNum*angle)/sina;
    k0 = sin((1-s(step+1))*angle)/sina;
    k1 = sin(s(step+1)*angle)/sina;
    pt_Q(:,step+1) = (p1_Q*k0 +p3_Q*k1)/norm(p1_Q*k0 + p3_Q*k1);
    q = pt_Q(:,step+1)';
    [AngleOut(1,step+1),AngleOut(2,step+1),AngleOut(3,step+1)] = quat2angle(q);
    AngleOut(:,step+1) = AngleOut(:,step+1)*180/pi;
end

for i = 1:stepNum
    qout(i,:) = [0,0,0,AngleOut(1,i),AngleOut(2,i),AngleOut(3,i)];
    T(:,:,i) = Fkine_Step(qout(i,:));
    T(1,4,i) = pose_start(1,4);
    T(2,4,i) = pose_start(2,4);
    T(3,4,i) = pose_start(3,4);
    qplot(i,:) = Ikine_Step(T(:,:,i),Angle_Last);
end

figure(2);
for i = 1:6 
    subplot(3,1,2);
    plot(diff(qplot(:,i)));
    hold on;
end
for i = 1:6 
    subplot(3,1,3);
    plot(diff(diff(qplot(:,i))));
    hold on;
end
for i = 1:6 
    subplot(3,1,1);
    plot(qplot(:,i));    
    hold on;
end

figure(3);
for i = 1:stepNum
    qplot(i,:) = qplot(i,:).*[pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
    robot.plot(qplot(i,:));
end

