clear
close all
clc

global cubic
TrajTime = 0.1;%规划关节运动的周期100ms
ServoTime = 0.01;%伺服时间，，每隔10ms给机器人发送一个控制指令
deltaT = 0.01;%任务配置PLC10ms(周期)

for i = 1:6
    % 初始状态规划器数据不满，因此为0
	cubic(i).filled = 0;
    % 表示需要新的规划点
    cubic(i).needNextPoint = 1;
    % 任务规划周期
    cubic(i).sTime = TrajTime;
    % 计算每次规划点数
    cubic(i).Rate = TrajTime/ServoTime + 1;
    % 当前规划器时间设为0
    cubic(i).interpolationTime = 0;
    % 计算规划器时间增量
    cubic(i).Inc = cubic(i).sTime/(cubic(i).Rate-1);
    % 清空规划器所有点
    cubic(i).x0 = 0;
    cubic(i).x1 = 0;
    cubic(i).x2 = 0;
    cubic(i).x3 = 0;
    % 清空规划器系数
    cubic(i).a = 0;
    cubic(i).b = 0;
    cubic(i).c = 0;
    cubic(i).d = 0;
end
index = 1;%输出关节角度个数计数
sinT = 0;%正弦规划时间
AngleInit = [0 0 0 0 0 0];%初始关节角

%压入初始角度进入规划器
for i = 1:6
    cubicAddPoint(i,AngleInit(i));
    cubic(i).needNextPoint = 1;
end
%初始时开启插值
on = 1;
num = 1;
%总规划时间
for t = 0:deltaT:1
	% 如果需要则往规划器添加期望点
    while cubic(1).needNextPoint
		% 开启控制时添加正弦运动曲线点
        if on 
            for i = 1:6
%                 point(i,num) = 1*sin(2*pi*sinT) + AngleInit(i);                
                point(i,num) = exp(num) + AngleInit(i);
                cubicAddPoint(i,point(i,num));
            end
		% 关闭控制时添加上次期望点
        else
            for i = 1:6
                cubicAddPoint(i,cubic(i).x3);
                point(i,num) = point(i,num-1);
            end
        end
        sinT = sinT + TrajTime;
        num = num + 1;
    end
	% 各关节角度规划
    for i = 1:6
        Joint(i,index) = cubicInterpolate(i);
    end
    index = index + 1;
	% 如果时间大于15s则停止运动控制
    if t>1
        on = 0;
    end
end
% 绘制1关节的规划与期望轨迹
time = 0:(index-2);
time= time*deltaT;
plot(time,Joint(1,:),'b-')
grid on 
hold on
time = 0:(num-2);
time= time*TrajTime;
plot(time,point(1,:),'r*')
ylim([-1.5 1.5])
xlabel('time(s)')
ylabel('angle(rad)')
title('关节1期望轨迹与实际规划轨迹曲线')
legend('规划轨迹','期望轨迹')

figure;
v = diff(Joint(1,:));
a = diff(v);
aa = diff(a);
subplot(2,2,1);
plot(Joint(1,:));
subplot(2,2,2);
plot(v);
subplot(2,2,3);
plot(a);
subplot(2,2,4);
plot(aa);
