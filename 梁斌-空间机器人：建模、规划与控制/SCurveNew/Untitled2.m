%导入机器人
clear
clc
robot = importrobot('Test_Link6.urdf');%导入机器人描述格式
robot.DataFormat='column';%数据格式为列，row为行；为‘row'时q0要转置-->q0’
robot.Gravity = [0 0 -9.80];%重力方向设置
qzero = [0,0,0,0,pi/2,0,0,0];
show(robot,qzero','PreservePlot',false);

axes.CameraPositionMode = 'auto';

%定义轨迹为半径为0.15的圆
t = (0:0.1:10)'; 
count = length(t);
center = [0 0.5 0.3];
radius = 0.15;
theta = t*(2*pi/t(end));
points =(center + radius*[cos(theta) sin(theta) zeros(size(theta))])';

hold on
plot3(points(1,:),points(2,:),points(3,:),'r')%画出定义的轨迹


Q_zero = [90,0,0,0,90,0];%底座 -> 抓手

Angle_Last = Q_zero + [0,90,0,0,0,0];
pose_start = Fkine_Final(Q_zero)%正解
q1 = zeros(length(points),8);%位置-->各关节为弧度值,8个单独关节运动.
    
for i = 1:length(points)
    pose_start(1,4) = points(2,i);
    pose_start(2,4) = -points(1,i);
    pose_start(3,4) = points(3,i);
    q(i,:) = Ikine_Step(pose_start,Q_zero);%反解
    q(i,:) = q(i,:).*[-pi/180,-pi/180,-pi/180,pi/180,pi/180,pi/180];
    q1(i,1:6) = q(i,:);
end


title('robot move follow the trajectory')
hold on
axis([-0.6 0.6 -0.4 0.8 0 0.8]);
for i = 1:size(points,2)
    show(robot,q1(i,:)','PreservePlot',false);%false改为true时，留下重影。
    pause(0.01)
end
hold off

figure(2);
for i = 1:6
    v = diff(q(:,i));
    a = diff(v);
    aa = diff(a);
    subplot(2,2,1);
    plot(q(:,i));
    hold on;
    subplot(2,2,2);
    plot(v);
    hold on;
    subplot(2,2,3);
    plot(a);
    hold on;
    subplot(2,2,4);
    plot(aa);
    hold on;
end
