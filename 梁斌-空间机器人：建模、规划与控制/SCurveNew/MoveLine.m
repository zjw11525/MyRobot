function [T, Td, TotalTime] = MoveLine(Cv, Ca, Cj, PoseStart, PT1, Vs, Ve, Vset, StepT)

%% 位置平移参数
 P0 = [PoseStart(1,4); PoseStart(2,4); PoseStart(3,4)] ;  
 P1 = [PT1(1,4); PT1(2,4); PT1(3,4)] ; 
 P01 = P1 - P0; 
 L1 = sqrt(P01(1)^2 + P01(2)^2 + P01(3)^2);     %输入真实距离
 P01 = P1 - P0;
 n01 = P01 / L1;
 
[Tm1, T_CA1, T_CV, Tm2, T_CA2, Am1, Am2, Vite] = Adaptive(Cv, Ca, Cj, L1, Vs, Ve, Vset);

i = 1;
TotalTime = 2*Tm1 + 2*Tm2 + T_CA1 + T_CA2 + T_CV;
TotalNum = floor(TotalTime / StepT);
if TotalTime - TotalNum*StepT > 0.5*StepT
    TotalNum = TotalNum + 1;
end

    Td = TotalTime - TotalNum * StepT;

Jerk = zeros(1,TotalNum + 1);
Acceleration = zeros(1,TotalNum + 1);
Velocity = zeros(1,TotalNum + 1);
Position = zeros(1,TotalNum + 1);
T = zeros(4,4,TotalNum + 1);
Vend = max(Vs, Ve);
Dend = 0;

for  t = 0 : StepT : StepT*TotalNum
    if(t == StepT*TotalNum)
        t = TotalTime;
    end;
      if(t <= Tm1) %1
         Jerk(i) = -4*Cj*(t*t)/(Tm1*Tm1) + 4*Cj*t/Tm1;
         Acceleration(i) = -4*Cj*(t*t*t)/(3*Tm1*Tm1) + 2*Cj*(t*t)/Tm1;
         Velocity(i) = -Cj*(t*t*t*t)/(3*Tm1*Tm1) + 2*Cj*(t*t*t)/(3*Tm1)+Vs;
         Position(i) = -Cj*(t*t*t*t*t)/(15*Tm1*Tm1) + Cj*(t*t*t*t)/(6*Tm1)+Vs*t;     
         if(t + StepT > Tm1)Vend = Cj*Tm1*Tm1/3 +Vs;Dend = 0.1*Cj*Tm1*Tm1*Tm1 + Vs*Tm1 ; end
         
            elseif(t <= Tm1 + T_CA1) %2
              t = t - Tm1;
              Jerk(i) = 0;
              Acceleration(i) = Am1;
              Velocity(i) = Vend + Am1*t;
              Position(i) = Dend + Vend*t + 0.5*Am1*t*t;
              if(t + Tm1  + StepT > Tm1 + T_CA1) Dend = Dend + Vend*T_CA1 + 0.5*Am1*T_CA1*T_CA1; Vend = Vend + Am1*T_CA1;  end
              
                 elseif(t <= 2*Tm1 + T_CA1) %3
                  t = t - Tm1 - T_CA1;
                  Jerk(i) =  4*Cj*(t*t)/(Tm1*Tm1) - 4*Cj*t/Tm1;
                  Acceleration(i) =Am1 + 4*Cj*(t*t*t)/(3*Tm1*Tm1) - 2*Cj*(t*t)/Tm1;
                  Velocity(i) = Vend + Am1*t + Cj*(t*t*t*t)/(3*Tm1*Tm1) - 2*Cj*(t*t*t)/(3*Tm1);
                  Position(i) = Dend + Vend*t + 0.5*Am1*t*t + Cj*(t*t*t*t*t)/(15*Tm1*Tm1) - Cj*(t*t*t*t)/(6*Tm1);
                  if(t + Tm1 + T_CA1 + StepT > 2*Tm1 + T_CA1 ) Dend = Dend + Vend*Tm1 - 0.1*Cj*Tm1*Tm1*Tm1 + 0.5*Am1*Tm1*Tm1;Vend = Vend + Cj*Tm1*Tm1/3;  end   %%%%%%%%%%   ??????????
                       
                     elseif(t <= 2*Tm1 + T_CA1 + T_CV) %4
                       t = t - 2*Tm1 - T_CA1;
                       Jerk(i) = 0;
                       Acceleration(i) = 0; 
                       Velocity(i) = Vite; 
                       Position(i) = Dend + Vite*t;
                       if(t + 2*Tm1 + T_CA1 + StepT > 2*Tm1 + T_CA1 + T_CV) Vend = Vite;  Dend = Dend + Vite*T_CV; end
                               
                           elseif(t <= 2*Tm1 + Tm2 + T_CA1 + T_CV) %5
                            t = t - 2*Tm1 - T_CA1 - T_CV;
                            Jerk(i) =  4*Cj*(t*t)/(Tm2*Tm2) - 4*Cj*t/Tm2;
                            Acceleration(i) = 4*Cj*(t*t*t)/(3*Tm2*Tm2) - 2*Cj*(t*t)/Tm2;
                            Velocity(i) = Vend + (Cj*(t*t*t*t)/(3*Tm2*Tm2) - 2*Cj*(t*t*t)/(3*Tm2));
                            Position(i) = Dend + Vend*t + Cj*(t*t*t*t*t)/(15*Tm2*Tm2) - Cj*(t*t*t*t)/(6*Tm2);
                            if(t + 2*Tm1 + T_CA1 + T_CV + StepT > 2*Tm1 + Tm2 + T_CA1 + T_CV) Dend = Dend + Vend*Tm2 - 0.1*Cj*Tm2*Tm2*Tm2; Vend = Vend - Cj*Tm2*Tm2/3; end
                            
                                elseif(t <= 2*Tm1 + Tm2 + T_CA1 + T_CA2 + T_CV) %6
                                 t = t - 2*Tm1 - Tm2 - T_CA1 - T_CV;
                                 Jerk(i) = 0;
                                 Acceleration(i) = -Am2;
                                 Velocity(i) = Vend - Am2*t;
                                 Position(i) = Dend + Vend*t - 0.5*Am2*t*t;
                                 if(t +  2*Tm1 + Tm2 + T_CA1 + T_CV + StepT >  2*Tm1 + Tm2 + T_CA1 + T_CA2 + T_CV) Dend = Dend + Vend*T_CA2 - 0.5*Am2*T_CA2*T_CA2; Vend = Vend - Am2*T_CA2; end
                                    
                                    elseif(t <= 2*Tm1 + 2*Tm2 + T_CA1 + T_CA2 + T_CV) %7
                                      t = t -2*Tm1 - Tm2 - T_CA1 - T_CA2 - T_CV;
                                      Jerk(i) =  -4*Cj*(t*t)/(Tm2*Tm2) + 4*Cj*t/Tm2;
                                      Acceleration(i) = - Am2 - 4*Cj*(t*t*t)/(3*Tm2*Tm2) + 2*Cj*(t*t)/Tm2;
                                      Velocity(i) = Vend - Am2*t - Cj*(t*t*t*t)/(3*Tm2*Tm2) + 2*Cj*(t*t*t)/(3*Tm2);
                                      Position(i) = Dend + Vend*t - 0.5*Am2*t*t - Cj*(t*t*t*t*t)/(15*Tm2*Tm2) + Cj*(t*t*t*t)/(6*Tm2);
%                                       if(t + 2*Tm1 + Tm2 + T_CA1 + T_CA2 + T_CV + StepT > 2*Tm1 + 2*Tm2 + T_CA1 + T_CA2 + T_CV ) Dend = Dend + Vend*Tm2 + 0.1*Cj*Tm2*Tm2*Tm2; Vend = Vend - Cj*Tm2*Tm2/3; end
      end
         T(1:3,1:3,i) = PT1(1:3,1:3);
         T(1:3,4,i) =  P0 + n01*Position(i) ; %获得位置 
         i = i + 1;
end

