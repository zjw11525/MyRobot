clear;
clc;
close all;
%初始化
A6D_K=[2.7, 0.5, 0.5, 1, 1, 1];      %(*刚度A6D_wn.^2.*A6D_m*)
A6D_m=[0.2 0.2, 0.2, 5, 5, 5];          %(*质量*)
A6D_ep=[1.1, 1.1, 1.1, 1.1, 1.1, 1.1];  %(*阻尼比*)
  ACC = [0,0,0,0,0,0];    %加速度
  A6D_V = [0,0,0,0,0,0];  %速度
  A6D_D = [0,0,0,0,0,0];  %位移
for AXIS=1:6
      A6D_b(AXIS) = 2*A6D_ep(AXIS)*sqrt(A6D_K(AXIS)*A6D_m(AXIS));  %阻尼
end
deltat = 0.1;
t_end = 20;
x_t = [];
y_f = [];
y_d = [];
y_v = [];

for t=0:deltat:t_end
    t
    if(t<4)
       F = [10,0,0,0,0,0];
    elseif t<8
      F = [-10,0,0,0,0,0];
    else
      F = [0,0,0,0,0,0];
    end    %力的作用方式
        
    for AXIS=1:6
          A6D_V(AXIS) = A6D_V(AXIS) + ACC(AXIS)*deltat;                           %deltat 为机器人运动周期，要与真实相同    
          A6D_D(AXIS)=A6D_D(AXIS) + ACC(AXIS)*deltat*deltat/2.0 + A6D_V(AXIS)*deltat ;
          ACC(AXIS) = (F(AXIS) - A6D_K(AXIS)*(A6D_D(AXIS))-A6D_b(AXIS)*A6D_V(AXIS))/A6D_m(AXIS); %计算加速度.其中 A6D_D是X - Xr 
    end
    %保存到矩阵
    x_t = [x_t;t];
    y_f = [y_f,F'];
    y_d = [y_d,A6D_D'];
    y_v = [y_v,A6D_V'];
    
squareMotion(A6D_D(1),A6D_D(2),A6D_D(3),A6D_D(4),A6D_D(5),A6D_D(6));
drawnow();%动画
    if t<t_end
        clf
    end
end

%绘图
figure();
for AXIS=1:6
    subplot(2,3,AXIS);
        [AX,H1,H2] = plotyy(x_t,y_f(AXIS,:),x_t,y_d(AXIS,:));
        axis([0 20 -12 12]);
        set(AX(1),'XColor','k','YColor','b');   %设置双y轴各自的颜色
        set(AX(2),'XColor','k','YColor','r');

        xlabel('时间(s)');    %x轴标签
        
        HH1=get(AX(1),'Ylabel');        %设置双y轴的标签
        set(HH1,'String','牵引力(N)');
        set(HH1,'color','b');
        HH2=get(AX(2),'Ylabel');
        set(HH2,'String','位移(m)');
        set(HH2,'color','r');

        set(H1,'LineStyle','-');                 %设置图线格式
        set(H1,'color','b');
        set(H2,'LineStyle','-.');
        set(H2,'color','r');

        legend([H1,H2],{'牵引力';'位移'});%图例
end