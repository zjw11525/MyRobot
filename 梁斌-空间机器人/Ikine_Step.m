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
Angle = Angle_Last

a1 = ((px - d6*ax)^2 + (py - d6*ay)^2 + (pz - d6*az - d1)^2 - a2^2 - d4^2) / 2*a2*d4  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for r1 = 1:2
    
    if(r1 == 1)
    theta3 = asind(a1); 
    else
    theta3 = 180 - theta3;%arcsin( ((px - d6*ax)^2 + (py - d6*ay)^2 + (pz - d6*az - d1)^2 - a2^2 - d4^2) / 2*a2*d4  );    
    end

    for r2 = 1:2

        for r3 = 1:2

%         Angle(n,:) = [angle1,angle2,angle3,angle4,angle5,angle6];
        n = n + 1 ;
        end
    end
end

Angle_Best = Angle;
