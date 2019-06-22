function s = trilinemove(Vm,Ta,Num,Step)

if Ta/Step*2 > Num
    Ta=Num/2*Step;%约束
end

Am = Vm/(2*Ta/Step);

t1 = ceil(Ta/Step);%acceleration MATLAB在if判断中7000.00！=7000
t2 = ceil(Num-t1);%deceleration

a1 = Am * t1 * t1;%加减速位移
a2 = Vm *(t2-t1);%匀速端位移
all = 2 * a1 + a2;%总位移

for t = 1:1:Num
    if t <= t1
        s(t) = Am*(t-sin(t/t1*pi)*t1/pi)*t1/all;%w=1/t1
        s1 = s(t);
        s2 = s1;
    end
    
    if (t > t1) && (t <= t2)
        s(t) = s1 + Vm*(t-t1)/all;
        s2 = s(t);
    end
    
    if t > t2
        s(t) = s2 + Am*((t-t2)+sin((t-t2)/t1*pi)*t1/pi)*t1/all;
    end
end
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