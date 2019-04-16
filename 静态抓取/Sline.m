function line = Sline(v,a,t,trans,pose_start)
% v = 0.1;%运动速度0.1m/s
% a = 0.03;%加速度 0.01接近三角函数
% t = 0.1;%插补周期10ms（plc周期）
L = sqrt(trans(1,4)^2 + trans(2,4)^2 + trans(3,4)^2);%distance
N = ceil(L/(v*t)) + 1;%插补数量
s = linemove(0,1,v,a,N);
for i = 1:N
x(i) = pose_start(1,4) + trans(1,4)*s(i);
y(i) = pose_start(2,4) + trans(2,4)*s(i);
z(i) = pose_start(3,4) + trans(3,4)*s(i);
end
line = [x;y;z];