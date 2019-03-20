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

s3 = -((px - d6*ax)^2 + (py - d6*ay)^2 + (pz - d6*az - d1)^2 - a2^2 - d4^2) / (2*a2*d4);
c3 = sqrt(1- s3^2);
A = a2 - d4*s3;
B = d4*c3;
C = d1 - pz + d6*az;
D = atan2d(B,A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for r1 = 1:2%loop1
    if(r1 == 1)
    angle3 = asind(s3); 
    else
    angle3 = 180 - angle3; 
    end
    for r2 = 1:2%loop2
        if(r2 == 1)
        angle2 = (asind(C/(sqrt(A^2 + B^2))) - D);%+ 90;%theta2 offset = -90 
        else
        angle2 = 180 - angle2; 
        end
        %通过theta2,theta3得到theta1
        c2 = cosd(angle2);
        s23 = sind(angle2 + angle3);
        angle1 = atan2d( (py - d6*ay)*(a2*c2 - d4*s23) , (px - d6*ax)*(a2*c2 - d4*s23) );      
        for r3 = 1:2%loop3
            c1 = cosd(angle1);
            s1 = sqrt(1 - c1^2);
            c23 = sqrt(1 - s23^2);                       
            ax36 = ax*c1*c23 - az*s23 + ay*c23*s1;
            ay36 = ax*s1 - ay*c1;
            az36 = -az*c23 - ax*c1*s23 - ay*s1*s23;
            ox36 = c1*c23*ox - oz*s23 + c23*oy*s1;
            oy36 = ox*s1 - c1*oy;
            oz36 = - c23*oz - c1*ox*s23 - oy*s1*s23;
            nz36 = - c23*nz - c1*nx*s23 - ny*s1*s23;
            
            if(r3 == 1)
            angle5 = acosd(az36); 
            else
            angle5 = - angle5; 
            end
            
            s5 = sind(angle5);
            
            if (az36 == 1)
                angle5 = 0;
                angle4 = 0;
                angle6 =  atan2d(-ox36,oy36);
            else
                if(az36 == -1)
                angle5 = 180;
                angle4 = 0;
                angle6 =  -atan2d(-ox36,oy36);
                else
                    angle4 = atan2d(-ay36*s5,-ax36*s5);
                    angle6 = atan2d(-oz36*s5,nz36*s5);
                end
            end
            Angle(n,:) = [angle1,angle2,angle3,angle4,angle5,angle6];
            n = n + 1 ;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    Angle_Best(2) = Angle_Best(2) + 90;
 end
