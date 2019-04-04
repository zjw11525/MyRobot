clc;
clear;
p1 = [0,0,0];
p2 = [1,0.7,0];
p3 = [2,0,0];
[pc,r] = CircleCenter(p1,p2,p3);
sumStep = 100;%插补数量

v = 0.1;%运动速度0.1m/s
a = 0.03;%加速度 0.01接近三角函数
s = linemove(0,1,v,a,sumStep);

% 建立圆弧坐标系
% 计算转换矩阵
A = (p2(2)-p1(2))*(p3(3)-p2(3))-(p2(3)-p1(3))*(p3(2)-p2(2));
B = (p2(3)-p1(3))*(p3(1)-p2(1))-(p2(1)-p1(1))*(p3(3)-p2(3));
C = (p2(1)-p1(1))*(p3(2)-p2(2))-(p2(2)-p1(2))*(p3(1)-p2(1));
K = sqrt(A^2+B^2+C^2);
a = [A B C]/K;
n = (p1 -pc)/r;
o = cross(a,n);
T = [n' o' a' pc'; 0 0 0 1];

% 求转换后的点
q1 = inv(T)*[p1 1]';
q2 = inv(T)*[p2 1]';
q3 = inv(T)*[p3 1]';

% 计算角度
if q3(2)<0
    theta13 = atan2(q3(2),q3(1)) + 2*pi;
else
    theta13 = atan2(q3(2),q3(1));
end

if q2(2)<0
    theta12 = atan2(q2(2),q2(1)) + 2*pi;
else
    theta12 = atan2(q2(2),q2(1));
end

% 轨迹插补
for count = 1:sumStep
    p_i(:,count) = T*[r*cos(s(count)*theta13) r*sin(s(count)*theta13) 0 1]';
end
count =1;
%线性
% for step = 0:theta13/sumStep: theta13
%     p_i1(:,count) = T*[r*cos(step) r*sin(step) 0 1]';
%     count = count+1;
% end
figure(2);
plot3(p_i(1,:),p_i(2,:),p_i(3,:),'r'),xlabel('x'),ylabel('y'),zlabel('z'),hold on,plot3(p_i(1,:),p_i(2,:),p_i(3,:),'o','color','g'),grid on;
% hold on;
% plot3(p_i1(1,:),p_i1(2,:),p_i1(3,:),'r'),xlabel('x'),ylabel('y'),zlabel('z'),hold on,plot3(p_i1(1,:),p_i1(2,:),p_i1(3,:),'o','color','r'),grid on;
axis([0 2 0 2]);
