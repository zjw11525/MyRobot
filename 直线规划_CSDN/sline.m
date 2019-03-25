clc;
clear;
%初始条件
x_arry=[0,0.1,0.2];
v_arry=[0.05,0.05];
A_arry=[0.1,0.1];
weiyi=[x_arry(1)];sudu=[0];shijian=[0];timeall=0;jiasudu=[0]
for i=1:1:length(x_arry)-1;
%清空
    a=[];v=[];s=[];
%计算加减速段的时间和位移
    L=x_arry(i+1)-x_arry(i);
    A=A_arry(i);
    vs=v_arry(i);
    Ta=sqrt(vs/A);
    L1=A*(Ta^3)/6;
    L2=A*(Ta^3)*(5/6); 
%计算整段轨迹的总位移
    T=4*Ta+(L-2*L1-2*L2)/vs;
    for t=0:0.001:T
        if t<=Ta;%加加速度阶段
            ad=A*t;
            vd=0.5*A*t^2;
            sd=(1/6)*A*t^3;
            a=[a,ad];v=[v,vd];s=[s,sd];
        elseif t>Ta && t<=2*Ta;%加减速阶段
            ad=-A*(t-2*Ta);
            vd=-0.5*A*(t-2*Ta)^2+A*Ta^2;
            sd=-(1/6)*A*(t-2*Ta)^3+A*Ta^2*t-A*Ta^3;
            a=[a,ad];v=[v,vd];s=[s,sd];
         elseif t>2*Ta && t<=T-2*Ta;%匀速阶段
            ad=0;
            vd=vs;
            sd=A*Ta^2*t-A*Ta^3;  
            a=[a,ad];v=[v,vd];s=[s,sd];
        elseif t>T-2*Ta && t<=T-Ta;%减加度阶段
            ad=-A*(t-(T-2*Ta));
            vd=-0.5*A*(t-T+2*Ta)^2+A*Ta^2;
            sd=-(1/6)*A*(t-T+2*Ta)^3+A*Ta^2*t-A*Ta^3;
            a=[a,ad];v=[v,vd];s=[s,sd];
         elseif t>T-Ta && t<=T;%减减阶段
            ad=A*(t-T);
            vd=0.5*A*(t-T)^2;
            sd=(1/6)*A*(t-T)^3-2*A*Ta^3+A*Ta^2*T;
            a=[a,ad];v=[v,vd];s=[s,sd];
        end
    end
%时间
    time=[timeall:0.001:timeall+T];
    timeall=timeall+T;
%连接每一段轨迹
    weiyi=[weiyi,s(2:end)+x_arry(i)];
    sudu=[sudu,v(2:end)];
    jiasudu=[jiasudu,a(2:end)];
    shijian=[shijian,time(2:end)];
end
subplot(3,1,1),plot(shijian,weiyi,'r');xlabel('t'),ylabel('position');grid on;
subplot(3,1,2),plot(shijian,sudu,'b');xlabel('t'),ylabel('velocity');grid on;
subplot(3,1,3),plot(shijian,jiasudu,'g');xlabel('t'),ylabel('accelerate');grid on;