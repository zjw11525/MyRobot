clear all;
clc;
j=0;
for i=1:10
    index(i)=j;
    j=j+10;
end
for i=1:90
    squence(i)=i;
end

j=1;
for i=0:2/9*pi:2*pi
    Y(j)=sin(i);
    j=j+1;
end

bs = uniformbspline(index,Y,squence)
plot(bs,'.');
hold on;
plot(index,Y,'*');

% 三次均匀B样条插值计算(CBI Cubic B-spline Interpolation)
% bs = uniformbspline(index,x,sequence)
% 输入参数:  index     为代求点的横坐标向量(Y的坐标)
%               x     已知的点的坐标值
%        sequence     所有点的横坐标向量 sequence=1:n;
% 输出参数:
%              bs    三次均匀B样条插值结果