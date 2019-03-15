%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         直角空间直线自适应运动规划
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc 
clear all
close all

% 运动学约束
Cv = 0.5;
Ca = 1;
Cj = 2;

% 减速比
Ratio1 = 121;
Ratio2 = 160.68;
Ratio3 = 101.81;
Ratio4 = 99.69;
Ratio5 = 64.56;
Ratio6 = 49.99;

Ratio = [Ratio1, Ratio2, Ratio3, Ratio4, Ratio5, Ratio6];


%% 初始条件
Step = 0.01;

Q_zero = [0 0 0 0 0 0];
Pose_Start = Fkine_Step(Q_zero);

Pose_End = Pose_Start;

Pose_End(3,4) = 0.5297;%z 下

%Pose_End(1,4) = 0.5;%x
%Pose_End(1,4) = 0.5246;%x 前
%Pose_End(2,4) = 0.2;%y 右





% Pose_End(3,4) = 0.4297;%z%% 自适应规划
Vs = 0;
Ve = 0;
Vset = Cv;
T1 = MoveL(Cv, Ca, Cj, Pose_Start, Pose_End, Vs, Ve, Vset);

Num = length(T1);

Distance = zeros(6, Num);
PulseNum = zeros(6, Num);

P = zeros(4, 4, Num);
for i = 1 : Num
    if i == 1
        Distance(:,i) = Ikine_Step(T1(:,:,i), Q_zero);
        P(:, :, i) = Fkine_Step(Distance(:,i));
    else
        Distance(:,i) = Ikine_Step(T1(:,:,i), Distance(:,i-1));
        P(:, :, i) = Fkine_Step(Distance(:,i));
    end
end

N = 6;
for i = 1 : Num
    for j = 1 : N
    PulseNum(j,i) =  (Distance(j,i) * Ratio(j) / 2.0);
    end
end
figure;
Sizefont = 30;
plot3(squeeze(T1(1,4,1)),squeeze(T1(2,4,1)),squeeze(T1(3,4,1)),'ok');
hold on 
plot3(squeeze(T1(1,4,end)),squeeze(T1(2,4,end)),squeeze(T1(3,4,end)),'ok');
hold on 
plot3(squeeze(T1(1,4,:)),squeeze(T1(2,4,:)),squeeze(T1(3,4,:)),'-r','LineWidth',4);
hold on

% K = 0.1;
% for i = 1 : 10 : Num
%     quiver3((P(1,4,i)),(P(2,4,i)),(P(3,4,i)),K*(P(1,1,i)),K*(P(2,1,i)),K*(P(3,1,i)),'r','LineWidth',2); % n轴方向的坐标轴在基座标系中的表示
%     hold on;
%     quiver3((P(1,4,i)),(P(2,4,i)),(P(3,4,i)),K*(P(1,2,i)),K*(P(2,2,i)),K*(P(3,2,i)),'g','LineWidth',2); % o轴方向的坐标轴在基座标系中的表示
%     hold on;
%     %quiver3((P(1,4,i)),(P(2,4,i)),(P(3,4,i)),K*(P(1,3,i)),K*(P(2,3,i)),K*(P(3,3,:)),'c','LineWidth',2); % a轴方向的坐标轴在基座标系中的表示
%     hold on;
% end


xlabel('X (m)','FontSize',Sizefont,'FontName','Times New Roman');
ylabel('Y (m)','FontSize',Sizefont,'FontName','Times New Roman');
zlabel('Z (m)','FontSize',Sizefont,'FontName','Times New Roman');
grid on 
format short;
Pos = roundn(PulseNum.',-4);
%% 输出文件
T=table(Pos);
writetable(T,'Pos.csv');
% B=A.' 是转置
% B=A'  是共轭转置