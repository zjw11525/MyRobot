function Angle_Best = Ikine_Step_V2(T, Angle_Last) 

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
Angle = zeros(1,6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     if (angle1 < -170 || angle1 > 170) 
%         continue; 
%     end    
    S1 = sind(angle1);
    C1 = cosd(angle1);

    px1 = px*C1 + py*S1;
    px2 = px*S1 - py*C1;
    ax1 = ax*C1 + ay*S1;
    ax2 = ax*S1 - ay*C1; 
    ox1 = ox*C1 + oy*S1;
    ox2 = ox*S1 - oy*C1;
    nx1 = nx*C1 + ny*S1;
    nx2 = nx*S1 - ny*C1;
    
    
    py1 = pz - d1;
    ak2 = 2*a2*d4;
    K1 = - d6*ax1 + px1;
    K2 = - py1 + d6*az;
    ck2 = (K1*K1 + K2*K2 - a2*a2 - d4*d4);
    S3 = ck2 / ak2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

    for r2 = 1:2
  
         %修改1
         if( abs(abs(S3) - 1) < 1e-14 ) 
             C3 = 0; 
         else
             C3 = sqrt(1-S3*S3);
         end
         
         if r2 == 1
            angle3 = atan2d(S3, C3);
         else   
            angle3 = atan2d(S3, -C3);
         end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
         %修改1
         if( angle3 > 40 )
              angle3 = angle3 - 360;
         end
         if( angle3 < -220 )
              angle3 = 360 + angle3;
         end
%         if (angle3 < -220 || angle3 > 40) 
%            continue; 
%         end  
        S3 = sind(angle3);
        C3 = cosd(angle3);
            %修改2


        if( K1 == 0) 
            C23 = -a2*C3 / K2; 
            S23 = - (a2*S3 + d4) / K2; 
        else
            C23 = (-K2*a2*C3 + a2*S3*K1 + d4*K1)/(K1*K1 + K2*K2); 
            S23 = (- K2*C23 - a2*C3) / K1;
        end
        %修改2
        angle23 = atan2d(S23, C23);
        angle2 = angle23 - angle3;
        if( angle2 > 110 )
            angle2 = angle2 - 360;
        end
        if( angle2 < -110)
            angle2 = angle2 + 360;
        end
%         if (angle2 < -110 || angle2 > 110) 
%             continue; 
%         end  
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
        for r3 = 1:2
            if r3 == 1
%                    angle4 = atan2d(ax2,(-ax1*S23+az*C23));
                 %修改3
                angle4 = atan2d(-px2, (px1*S23+a2*C3-py1*C23));
                 %修改3
            else
               if(angle4 > 0)
                   angle4 =  angle4 - 180;
               else
                   angle4 =  angle4 + 180;
                end 
            end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             if (angle4 < -180 || angle4 > 180) 
%                 continue; 
%             end

             %修改4
            S4 = sind(angle4);
            C4 = cosd(angle4);
            S5 = ax2*S4 - ax1*C4*S23 + az*C23*C4;
            C5 = C23*ax1 + az*S23;
            angle5 = atan2d(S5, C5);
%             if (angle5 < -125 || angle5 > 125) 
%                 continue; 
%             end

                S6 = nx2*C4 + nx1*S23*S4 - nz*C23*S4;
                C6 = ox2*C4 + ox1*S23*S4 - oz*C23*S4;
                angle6 = atan2d(S6, C6);

                if( abs(angle5) < 1e-10 )
            angle4 = angle4 + angle6;
            angle6 = 0;
        end
         %修改4
        Angle(n,:) = [angle1, angle2, angle3, angle4, angle5, angle6];
        n = n + 1 ;
        end
      end
end
    if n == 1 
    Angle_Best = [0 0 0 0 0 0];    
    else
        for i = 1 : n - 1

           error = abs(Angle(i,1) - Angle_Last(1))/340 + abs(Angle(i,2) - Angle_Last(2))/220 + abs(Angle(i,3) -  Angle_Last(3))/260 + abs(Angle(i,4) - Angle_Last(4))/360 + abs(Angle(i,5) - Angle_Last(5))/250 + abs(Angle(i,6) - Angle_Last(6))/360;
           if(i==1)
              error_min = error;
              j = i ;
              elseif(error < error_min)
                 error_min = error;
                 j = i ;
           end
        end
     Angle_Best = Angle(j,:);
    end
end
