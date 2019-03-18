function Q = moveL3(PT1,PT2)
% clear;
% clc;
q0=PT1;
q1=PT2; %指定起止位置
t0=0;
t1=0.5;%指定起止时间
v0=0;
v1=0;%指定起止速度
a0=q0;
a1=v0;
a2=(3/(t1)^2)*(q1-q0)-(1/t1)*(2*v0+v1);
a3=(2/(t1)^3)*(q0-q1)+(1/t1^2)*(v0+v1);%计算三次多项式系数
t=t0:0.01:t1;
q=a0+a1*t+a2*t.^2+a3*t.^3;%三次多项式插值的位置
v=a1+2*a2*t+3*a3*t.^2;%三次多项式插值的速度
a=2*a2+6*a3*t;%三次多项式插值的加速度

% subplot(3,1,1),plot(t,q),xlabel('t'),ylabel('position');grid on;
% subplot(3,1,2),plot(t,v),xlabel('t'),ylabel('velocity');grid on;
% subplot(3,1,3),plot(t,a),xlabel('t'),ylabel('accelerate');grid on;

Q = q;