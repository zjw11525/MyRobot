clc;
clear all;
syms am;
syms t;
syms w;
syms a;
syms t1;

Am = 0.5;
Vm = 0.2;
Num = 100;
Step = 0.01;
te = Num*Step;%total time
t1 = Vm/(2*Am);%acceleration time
t2 = te-t1;%deceleration time

a1 = Am*t1*t1;
a2 = Vm*(t2-t1);
all = 2*a1+a2;
% a = am*sin(w*t);
% int(a,t)
% syms v;
% v = am*(1-cos(w*t))/w;
% int(v,t)
% syms v;
% v = am*(t-sin(w*t)/w)/w;
% int(v,t)

% syms v;
% syms vm;
% syms t1;
% 
% v = 1 + vm*(t-t1);
% int(v,t)

j=0;
for t = 0:Step:te
    if t <= t1
        s(j+1) = Am*(t^2 - 2*cos(t*pi/t1)/(pi/t1)^2)*t1/2;
        s1 = s(j+1);
    else
        if t >= t1 && t <= t2           
            s(j+1) = s1*(t+1-t1) + (Vm*(t - t1)^2)/2;
            s2 = s(j+1);
%         else
%             if t >= t2
%                 s(j+1) = s2 + Am*((t-t2)+sin((t-t2)/t1*pi)*t1/pi)*t1/all;
%             end
        end
    end
    j=j+1;
end
plot(s);