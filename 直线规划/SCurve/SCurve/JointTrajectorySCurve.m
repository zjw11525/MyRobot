%% 自适应S曲线
clc;
clear;
close all;
%%
N = 500;
%% 1
ThetaStart = 0;
ThetaEnd = 90;
VTheta = 90;    %1
ATheta = 135;   %1.5
Tf = 1.8;
%% 2
% ThetaStart = 90;
% ThetaEnd = 00;
% VTheta = 99;    %1.1
% ATheta = 180;   %2
% Tf = 1.8;
%% J<0
% ThetaStart = 90;
% ThetaEnd = 00;
% VTheta = 1.8 * (ThetaEnd - ThetaStart);
% ATheta = 3 * (ThetaEnd - ThetaStart);
% Tf = 0.1;
%% t4<0
% ThetaStart = 90;
% ThetaEnd = 00;
% VTheta = 5 * (ThetaEnd - ThetaStart);
% ATheta = 2 * (ThetaEnd - ThetaStart);
% Tf = 3;
%% t2<0
% ThetaStart = 90;
% ThetaEnd = 00;
% VTheta = 5 * (ThetaEnd - ThetaStart);
% ATheta = 40 * (ThetaEnd - ThetaStart);
% Tf = 3;
%%
v = VTheta/(ThetaEnd - ThetaStart);
a = ATheta/(ThetaEnd - ThetaStart);
v = abs(v);
a = abs(a);
% %J<0
% Tf = 0.1;
% v = 1.8;
% a = 3;
% Tf = 1.2556;
% v = 1.5831;
% a = 3;
%t4<0
% Tf = 3;
% v = 1.8;
% a = 2;
% %t2<0
% Tf = 3;
% v = 5;
% a = 40;
display(Tf,'原始Tf:');
display(v,'原始v:');
display(a,'原始a:');

Theta = zeros(1,N);
s = zeros(1,N);
sd = zeros(1,N);
sdd = zeros(1,N);

[TF,V,A,J,T] = SCurvePara(Tf, v, a);
display(J, '新J:');
display(TF,'新Tf:');
display(V,'新v:');
display(A, '新da:');

display(TF-Tf,'新dTf:');
display(V-v,'新dv:');
display(A-a, '新da:');

t=linspace(0,TF,N);
dt = t(2) - t(1);
for i = 1:N
    if i == N
        a = a;
    end
    s(i) = SCurveScaling(t(i),V,A,J,T,TF);
    Theta(i) = ThetaStart + s(i) * (ThetaEnd - ThetaStart);
    if i>1
        sd(i-1) = (s(i) - s(i-1)) / dt;
    end
    if i>2
        sdd(i-2) = (sd(i-1) - sd(i-2)) / dt;
    end
end

figure;
plot(t,Theta)
legend('Theta');
xlabel('t');
ylabel('theta');
figure;
plot(t,s)
legend('s');
xlabel('t');
ylabel('s');
figure;
plot(t,sd);
legend('s的一阶导数');
xlabel('t');
ylabel('s的一阶导数');
figure
plot(t,sdd);
legend('s的二阶导数');
xlabel('t');
ylabel('s的二阶导数')
