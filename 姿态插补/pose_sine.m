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
%平移
trans = [1  0  0  0;
         0  1  0  0;
         0  0  1  -0.6;
         0  0  0  1;];
pose_end = trans*pose_start
% j=1;
% for i = -1623:8:2304 
%     a(j)=i;j=j+1; 
% end
% a = a';
% format short;
% %输出文件
% a = roundn(a,-4);
% T=table(a);
% fid = fopen('Pos.txt','wt+');
% fprintf(fid,'%f,\n',a);
% writetable(T,'Pos.csv');

v = 0.2;%运动速度0.1m/s
t = 0.001;%插补周期1ms（plc周期）
L = sqrt(trans(1,4)^2 + trans(2,4)^2 + trans(3,4)^2);%distance
N = ceil(L/(v*t));%插补数量

ta = 0.5;%加减速时间0.5s

s = trilinemove(v,ta,N,t);

for i = 1:N
x(i) = pose_start(1,4) + trans(1,4)*s(i);
y(i) = pose_start(2,4) + trans(2,4)*s(i);
z(i) = pose_start(3,4) + trans(3,4)*s(i);
end

stepNum = N;

%判断路径,取路径短的，不影响方向
%欧拉角转四元数
EulerAngleStart = [0,0,0];
EulerAngleEnd = [20/180*pi,20/180*pi,20/180*pi];
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

T = zeros(4,4,stepNum);
qout = zeros(1,6,stepNum);
for i = 1:stepNum
    q1 = [0,0,0,AngleOut(1,i),AngleOut(2,i),AngleOut(3,i)];
    T(:,:,i) = Fkine_Step(q1); 
    T(1,4,i) = x(i);
    T(2,4,i) = y(i);
    T(3,4,i) = z(i);
    qout(:,:,i) = Ikine_Step(T(:,:,i),Angle_Last);
end


figure(2);
qplot(:,:) = qout(1,:,:);
for i = 1:6 
    subplot(3,1,2);
    plot(diff(qplot(i,:)));
    hold on;
end

qplot(:,:) = qout(1,:,:);
for i = 1:6 
    subplot(3,1,3);
    plot(diff(diff(qplot(i,:))));
    hold on;
end
qplot(:,:) = qout(1,:,:);
for i = 1:6 
    subplot(3,1,1);
    plot(qplot(i,:));    
    hold on;
end

% 减速比
% Ratio1 = 121;
% Ratio2 = 160.68;
% Ratio3 = 101.81;
% Ratio4 = 99.69;
% Ratio5 = 64.56;
% Ratio6 = 49.99;
% 
% Ratio = [Ratio1,Ratio2,Ratio3,Ratio4,Ratio5,Ratio6];
% 
% for i = 1:length(qplot)
%     qout1(i,:) = qplot(:,i)'.*Ratio / 2; 
%     qout1(i,:) = qout1(i,:) .* [1 1 1 1 -1 -1];
% end
% 
% 
% format short;
% %输出文件
% Pos = roundn(qout1,-4);
% T=table(Pos);
% fid = fopen('Pos.txt','wt+');
% fprintf(fid,'%-8.4f,%-8.4f,%-8.4f,%-8.4f,%-8.4f,%-8.4f,\n',Pos.');
% writetable(T,'Pos.csv');

figure(3);

plot3(x,y,z,'g'),xlabel('x'),ylabel('y'),zlabel('z'),hold on;
axis([-1 1 -1 1 -1 1]);%坐标范围
hold on;
% plot3(x,y,z,'o','color','g'),grid on;
for i = 1:100:stepNum 
X=[x(i) x(i) x(i)]';
Y=[y(i) y(i) y(i)]';
Z=[z(i) z(i) z(i)]';

U=[T(1,1,i) T(1,2,i),T(1,3,i)]';
V=[T(2,1,i) T(2,2,i),T(2,3,i)]';
W=[T(3,1,i) T(3,2,i),T(3,3,i)]';

if i==1
quiver3(X,Y,Z,U,V,W,0.2,'r');
else
    if i==stepNum
    quiver3(X,Y,Z,U,V,W,0.2,'r');
    else
        quiver3(X,Y,Z,U,V,W,0.1,'b');
    end
end
end

for i = 1:100:stepNum 
    qout(:,:,i) = qout(:,:,i).*[pi/180,pi/180,pi/180,pi/180,pi/180,pi/180];
    robot.plot(qout(:,:,i));
end


