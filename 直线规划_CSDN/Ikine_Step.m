function Angle_Best = Ikine_Step(T, Angle_Last) 


d1 = 0.28;
d4 = 0.35014205;
d6 = 0.0745;
a2 = 0.34966093;

nx = T(1,1);
ny = T(2,1);
nz = T(3,1);
ox = T(1,2);
oy = T(2,2);
oz = T(3,2);
ax = T(1,3);
ay = T(2,3);
az = T(3,3);
px = T(1,4);
py = T(2,4);
pz = T(3,4);

n = 1;
Angle = [0 0 0 0 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for r1 = 1:2
    if r1 == 1
         angle1 = atan2d((-py+d6*ay),(ax*d6-px));
    else
        if(angle1 > 0)
             angle1 = angle1 - 180;
        else
             angle1 = angle1 + 180;
        end
    end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if (angle1 < -170 || angle1 > 170) 
%         continue; 
%     end    
    S1 = sind(angle1);
    C1 = cosd(angle1);

    px1 = px*C1 + py*S1;
    ax1 = ax*C1 + ay*S1;
    ox1 = ox*C1 + oy*S1;
    nx1 = nx*C1 + ny*S1;
    
    py1 = pz - d1;
    az1 = ax*S1 - ay*C1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    for r2 = 1:2
         ak2 = 2*a2*d4;
         ck2 = ((px1- d6*ax1)*(px1- d6*ax1) + (py1-d6*az)*(py1-d6*az) - a2*a2 - d4*d4);
         S3 = ck2 / ak2;%S3第一次计算结果
         C3 = sqrt(1-S3*S3);%C3第一次计算结果
         if r2 == 1
            if( abs(abs(ak2) - abs(ck2)) < 1e-13) 
                if ak2 * ck2 < 0
                    angle3 = -90;
                else
                    angle3 = 90;
                end
            else
                angle3 = atan2d( S3,C3);  
            end
         else
            if angle3 > 0
               angle3 =  -angle3 - 180;
            else
               angle3 =  -angle3 + 180;
            end 
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if angle3 >= 40
                angle3 = angle3 - 360;
        end
        if angle3 <= -220
                angle3 = angle3 + 360;
        end  
%         if (angle3 < -220 || angle3 > 40) 
%            continue; 
%         end  
        S3 = sind(angle3);
        C3 = cosd(angle3);

        K1 = d6*ax1 - px1;
        K2 = py1 - d6*az;
        C23 = (K2*a2*C3/K1-a2*S3 - d4)*K1/(K1*K1+K2*K2);
        S23 = (-K2*C23 + a2*C3) / K1;
        angle23 = atan2d(S23,C23);
        angle2 = angle23 - angle3;
        if angle2 > 110
                angle2 = angle2 - 360;
        end
        if angle2 < -110
                angle2 = angle2 + 360;
        end 
%             if (angle2 < -110 || angle2 > 110) 
%                 continue; 
%             end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        for r3 = 1:2
            if r3 == 1
               angle4 = atan2d(az1,(-ax1*S23+az*C23));
            else
               if(angle4 > 0)
                   angle4 =  angle4 - 180;
               else
                   angle4 =  angle4 + 180;
                end 
            end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
        S4 = sind(angle4);
        if S4 == 0
            S5 = -ax1*S23 + az*C23;
        else
            S5 = az1 / S4;
        end
        C5 = C23*ax1 + az*S23;
        angle5 = atan2d(S5,C5);
        S5 = sind(angle5);

        if S5 == 0
            S6 = -oz;
            C6 = nz;
        else 
            S6 = (C23*ox1 + oz*S23) / S5;
            C6 = -(C23*nx1 + nz*S23) / S5;
        end
        angle6 = atan2d(S6,C6);

        Angle(n,:) = [angle1,angle2,angle3,angle4,angle5,angle6];
        n = n + 1 ;
        end
    end
end




    if n == 1 
        Angle_Best = [0 0 0 0 0 0];    
    else
        for i = 1 : n - 1

           error = abs(Angle(i,1) - Angle_Last(1))/340 + abs(Angle(i,2) - Angle_Last(2))/220 +  ...
                    abs(Angle(i,3) -  Angle_Last(3))/260 + abs(Angle(i,4) - Angle_Last(4))/360 + ...
                      abs(Angle(i,5) - Angle_Last(5))/250 + abs(Angle(i,6) - Angle_Last(6))/360;

           if(i==1)
              error_min = error;
              j = i ;
              elseif(error < error_min)
                 error_min = error;
                 j = i ;
           end

        end

    Angle_Best = Angle(j,:);
    %纠正角度
    Q_bias = [1,-1,-1,1,1,-1];
    Angle_Best = Angle_Best .* Q_bias;
    Q_bias = [1,1,1,1,-1,-1];
    Angle_Best = Angle_Best .* Q_bias;
    end

