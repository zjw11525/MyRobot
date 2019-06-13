function s = trilinemove(Vm,Ta,Num,Step)
% clc;
% clear all;

% Num = 1000;
% Vm = 0.2;
% Am = 0.5;
% Step = 0.001;

Am = Vm/(2*Ta);

te = Num*Step;%total time
t1 = Vm/(2*Am);%acceleration time
t2 = te-t1;%deceleration time

a1 = Am*t1*t1;
a2 = Vm*(t2-t1);
all = 2*a1+a2;

% j=0;
% for t = 0:Step:te
%     if t <= t1
%         a(j+1) = Am*sin(t/t1*pi);
%     else
%         if t >= t1 && t <= t2
%             a(j+1) = 0;
%         else
%             if t >= t2
%                 a(j+1) = -Am*sin((t-t2)/t1*pi);
%             end
%         end
%     end
%     j=j+1;
% end
% figure(1);
% plot(a);
% hold on;
% j=0;
% for t = 0:Step:te
%     if t <= t1
%         v(j+1) = Am*(1-cos(t/t1*pi))*t1;
%     else
%         if t >= t1 && t <= t2
%             v(j+1) = Vm;
%         else
%             if t >= t2
%                 v(j+1) = Am*(1+cos((t-t2)/t1*pi))*t1;
%             end
%         end
%     end
%     j=j+1;
% end
% plot(v);hold on;

j=0;
for t = 0:Step:te
    if t <= t1
        s(j+1) = Am*(t-sin(t/t1*pi)*t1/pi)*t1/all;
        s1 = s(j+1);
    else
        if t >= t1 && t <= t2           
            s(j+1) = s1 + Vm*(t-t1)/all;
            s2 = s(j+1);
        else
            if t >= t2
                s(j+1) = s2 + Am*((t-t2)+sin((t-t2)/t1*pi)*t1/pi)*t1/all;
            end
        end
    end
    j=j+1;
end
figure(1);
subplot(3,1,1);
plot(s);
hold on;
subplot(3,1,2);
plot(diff(s));
hold on;
subplot(3,1,3);
plot(diff(diff(s)));
hold on;
% subplot(2,2,4);
end

