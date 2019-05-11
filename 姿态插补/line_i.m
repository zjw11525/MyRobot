clc;
clear;
p1 = [0,0,0];
p2 = [1,1,1];
p3 = [2,2,2];
step = 0.01;
% ¼ÆËã²å²¹µãÊý
stepNum = round(sqrt((p3(1)-p1(1))^2+(p3(2)-p1(2))^2+(p3(3)-p1(3))^2)/step);
p_i = zeros(4,stepNum+1);
    
fprintf("line\n");
dx=(p3(1)-p1(1))/stepNum;
dy=(p3(2)-p1(2))/stepNum;
dz=(p3(3)-p1(3))/stepNum;

for t=0:1:stepNum
	p_i(1,t+1)=p1(1)+dx*t;
	p_i(2,t+1)=p1(2)+dy*t;
	p_i(3,t+1)=p1(3)+dz*t;
end

plot3(p_i(1,:),p_i(2,:),p_i(3,:));