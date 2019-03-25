function T = MoveL(Cv, Ca, Cj, PoseStart, PT1, Vs, Ve, Vset)%PoseStart为起始点，PT1为终点

StepT = 0.001;%步长
%% 位置平移参数
 P0 = [PoseStart(1,4); PoseStart(2,4); PoseStart(3,4)] ;  %取起始点px,py,pz
 P1 = [PT1(1,4); PT1(2,4); PT1(3,4)] ; %取终点px,py,pz
 P01 = P1 - P0; %空间两点做差
 L1 = sqrt(P01(1)^2 + P01(2)^2 + P01(3)^2);    %求起始和终点两点之间距离
 P01 = P1 - P0;
 n01 = P01 / L1;%归一化处理
 
% [Tm1, T_CA1, T_CV, Tm2, T_CA2, Am1, Am2, Vite] = Adaptive(Cv, Ca, Cj, L1, Vs, Ve, Vset);%速度，加速度，加加速度，距离，起始速度，结束速度

 Tm1 = 0.4217;
 T_CA1 = 0;
 T_CV = 0;
 T_CA2 = 0;
 Tm2 = 0.4217;
 Am1 = 0.5623;
 Am2 = 0.5623;
 Vite = 0.2371;
 
 Tm1_2 = Tm1 * Tm1;%
 Tm2_2 = Tm2 * Tm2;%
 
 Am1_T_CA1 = Am1 * T_CA1;%
 Am2_T_CA2 = Am2 * T_CA2;%
 Am1_05 = 0.5 * Am1;%
 Am2_05 = 0.5 * Am2;%
 Vs_Tm1 = Vs * Tm1;%
 Vite_T_CV = Vite * T_CV;%
 Cj_div_Tm1 = Cj / Tm1;%
 Cj_div_Tm2 = Cj / Tm2;%
 Tm1_3 = Tm1_2 * Tm1;%
 Tm2_3 = Tm2_2 * Tm2;%
 Cj_Tm1_2 = Cj * Tm1_2;%
 Cj_Tm1_3 = Cj * Tm1_3;%
 Cj_Tm2_2 = Cj * Tm2_2;%
 Cj_Tm2_3 = Cj * Tm2_3;%
 Am1_Tm1_2 = Am1 * Tm1_2;%
 
 Cj_div_Tm1_2 = Cj / Tm1_2;%
 Cj_div_Tm2_2 = Cj / Tm2_2;%
 Am1_T_CA1_T_CA1 = Am1_T_CA1 * T_CA1;%
 Am2_T_CA2_T_CA2 = Am2_T_CA2 * T_CA2;%
 
 


 
 Cj_div_Tm1_div_6 = Cj_div_Tm1 / 6;%
 Cj_div_Tm2_div_6 = Cj_div_Tm2 / 6;%
 Cj_Tm1_2_div_3 =  Cj_Tm1_2 / 3;%
 Cj_Tm2_2_div_3 = Cj_Tm2_2 / 3;%
 Cj_Tm1_3_01 = 0.1 * Cj_Tm1_3;%
 Cj_Tm2_3_01 = 0.1 * Cj_Tm2_3;%
 Am1_Tm1_2_05 = 0.5 * Am1_Tm1_2;%
 Am1_T_CA1_T_CA1_05 = 0.5 * Am1_T_CA1_T_CA1;%
 Am2_T_CA2_T_CA2_05 = 0.5 * Am2_T_CA2_T_CA2;%
 Cj_div_Tm1_2_div_15 = Cj_div_Tm1_2 / 15;%
 Cj_div_Tm2_2_div_15 = Cj_div_Tm2_2 / 15;%
 


 Tm1_add_T_CA1 = Tm1 + T_CA1;
 Tm1_add_T_CA1_add_Tm1 = Tm1_add_T_CA1 + Tm1;%
 Tm1_add_T_CA1_add_Tm1_add_T_CV = Tm1_add_T_CA1_add_Tm1 + T_CV;%
 Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2 = Tm1_add_T_CA1_add_Tm1_add_T_CV + Tm2;%
 Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2 = Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2 + T_CA2;%
 Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2_add_Tm2= Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2 + Tm2;
 


Vend_1 = Cj_Tm1_2_div_3 +Vs;%
Dend_1 = Cj_Tm1_3_01 + Vs_Tm1 ; %

Dend_2 = Dend_1 + Vend_1*T_CA1 + Am1_T_CA1_T_CA1_05; %
Vend_2 = Vend_1 + Am1_T_CA1;  %

Dend_3 = Dend_2 - Cj_Tm1_3_01 + Vend_2*Tm1 + Am1_Tm1_2_05;%
Vend_3 = Vend_2 + Cj_Tm1_2_div_3; %

Vend_4 = Vite;  %
Dend_4 = Dend_3 + Vite_T_CV; %

Dend_5 = Dend_4 + Vend_4*Tm2 - Cj_Tm2_3_01; %
Vend_5 = Vend_4 - Cj_Tm2_2_div_3; %

Dend_6 = Dend_5 + Vend_5*T_CA2 - Am2_T_CA2_T_CA2_05; %
Vend_6 = Vend_5 - Am2_T_CA2;%

% Dend_7 = Dend_6 + Vend_6*Tm2 + Cj_Tm2_3_01; 
% Vend_7 = Vend_6 -Cj_Tm2_2_div_3; 

i = 1;
TotalTime = 2*Tm1 + 2*Tm2 + T_CA1 + T_CA2 + T_CV;%总运动时间
TotalNum=floor(TotalTime / StepT);%总插补点个数，floor为取整函数
Position=zeros(1,TotalNum+1);%初始化插补点位置
T = zeros(4,4,TotalNum+1);%初始化每个插补点一个位姿矩阵

%  |Tm1|T_CA1|Tm1|T_CV|Tm2|T_CA2|Tm2|一共七个阶段

for  t = 0 : StepT : StepT*TotalNum%每次步进一个点
%     if(t == StepT*TotalNum)
%         t = TotalTime;
%     end
temp = 0;
%判断t在七段中的哪个段
    if(t <= Tm1) %1 
        temp = 1;
    elseif(t <= Tm1_add_T_CA1) %2
        temp = 2;
        t = t - Tm1;
    elseif(t <= Tm1_add_T_CA1_add_Tm1) %3
        temp = 3;
        t = t - Tm1_add_T_CA1;
    elseif(t <= Tm1_add_T_CA1_add_Tm1_add_T_CV) %4
        temp = 4;
        t = t - Tm1_add_T_CA1_add_Tm1;      
    elseif(t <= Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2) %5
        temp = 5;
        t = t - Tm1_add_T_CA1_add_Tm1_add_T_CV;      
    elseif(t <= Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2) %6
        temp = 6;
        t = t - Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2;     
    elseif(t <= Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2_add_Tm2) %7
        temp = 7;
        t = t -Tm1_add_T_CA1_add_Tm1_add_T_CV_add_Tm2_add_T_CA2;       
    end
%中间公式运算        
    t_t = t * t;
    t_t_t_t = t_t * t_t;
    t_t_t_t_t = t_t_t_t * t; 
    
    Vs_t = Vs*t;%01//
    Vend_1_t = Vend_1*t;%02//  
    Vend_2_t = Vend_2*t;%03//
    Vite_t = Vite*t;%04//
    Vend_4_t = Vend_4*t;%05 //     
    Vend_5_t = Vend_5*t;%06//   
    Vend_6_t = Vend_6*t;%07//
    Am2_05_t_t = Am2_05*t_t;%08//
    Am1_05_t_t = Am1_05*t_t;%09//
    Cj_div_Tm2_div_6_t_t_t_t = Cj_div_Tm2_div_6*t_t_t_t;%10//
    Cj_div_Tm1_div_6_t_t_t_t = Cj_div_Tm1_div_6*t_t_t_t;%11//
    Cj_div_Tm2_2_div_15_t_t_t_t_t = Cj_div_Tm2_2_div_15*t_t_t_t_t;%12//
    Cj_div_Tm1_2_div_15_t_t_t_t_t = Cj_div_Tm1_2_div_15*t_t_t_t_t;%13//
    
    a = -Cj_div_Tm1_2_div_15_t_t_t_t_t + Cj_div_Tm1_div_6_t_t_t_t;%//
    b = a + Vs_t;%
    c = Dend_1 + Vend_1_t;%//
    d = c +Am1_05_t_t;%
    e =  Dend_2 + Vend_2_t;%//
    f = Am1_05_t_t + Cj_div_Tm1_2_div_15_t_t_t_t_t;%//
    g = f - Cj_div_Tm1_div_6_t_t_t_t;%
    h = e + g; %
    I = Dend_3 + Vite_t;%
    j = Dend_4 + Vend_4_t;%
    k = Cj_div_Tm2_2_div_15_t_t_t_t_t - Cj_div_Tm2_div_6_t_t_t_t;%
    l = j + k;%
    m = Dend_5 + Vend_5_t;%
    n = m - Am2_05_t_t;%
    o = Dend_6 + Vend_6_t;%
    p = Am2_05_t_t + Cj_div_Tm2_2_div_15_t_t_t_t_t;%
    q = o - p;%
    r = q + Cj_div_Tm2_div_6_t_t_t_t;
 %再次判断t在哪个阶段然后运算结果     
    if(temp == 1)       
        Position(i) = b; end%1 
    if(temp == 2)       
        Position(i) = d; end%2//////////////
    if(temp == 3)       
        Position(i) = h; end%3  t = 44
    if(temp == 4)       
        Position(i) = I; end%4//////////
    if(temp == 5)       
        Position(i) = l; end%5  t = 86
    if(temp == 6)       
        Position(i) = n; end%6/////////
    if(temp == 7)       
        Position(i) = r; end%7

         T(1:3,1:3,i) = PT1(1:3,1:3);
         T(1:3,4,i) =  P0 + n01*Position(i) ; %获得位置 
         i = i + 1;
end

a = 1;
