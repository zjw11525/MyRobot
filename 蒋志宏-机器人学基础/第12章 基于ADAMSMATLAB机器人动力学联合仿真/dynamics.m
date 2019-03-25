function Torque = dynamics(angle, angluar_v, angluar_a)
% 质量矩阵, unit: Kg
mass = [65.0, 50.0, 20.0, 10.5, 3.5, 1.0];    

% 杆件参数, unit: m
P1=0.43;
P2=0.09956;
P4=0.65074;
P5=0.00105;
P6=0.70023;
% P7=0.205;

% 质心在杆件坐标系下的表示, unit: m
PC = [ -0.027556004011,     -0.01390621464,		-0.0934367772;
		0.281018326, 		-0.02378727752,		 0.1205031204; 
	   -0.00026708720342,	-0.049327848994,	-0.013542622052;         
		0.0012883588476, 	 0.0061959395757,	-0.2532128043;
	   -0.0021609978802,	-0.047658510905,	 0.0051235574999; 
	   -0.0019006821653,	 0.0040220390279, 	 0.129974036 ];

% 下一个坐标系在上一个坐标系下的表示
P = [0.0, 0.0,  P1; 
	 -P2, 0.0, 0.0; 
      P4, 0.0, 0.0; 
	  P5, -P6, 0.0; 
	 0.0, 0.0, 0.0; 
	 0.0, 0.0, 0.0; ];	 

% 杆件在质心坐标系下的惯性张量 unit: kg*m^2
IC(:,:,1) = [1.3    0.0     0.0;  
			 0.0   	0.9		0.0;   
			 0.0 	0.0    	0.8]; 
IC(:,:,2) = [2.9   	0.0     0.0;  
			 0.0   	2.8		0.0;   
			 0.0 	0.0    	0.2]; 
IC(:,:,3) = [0.22	0.0     0.0;  
			 0.0   	0.22	0.0;   
			 0.0 	0.0    	0.17]; 
IC(:,:,4) = [0.32	0.0     0.0;  
			 0.0	0.32	0.0;   
			 0.0 	0.0    	0.03]; 
IC(:,:,5) = [0.002	0.0     0.0;  
			 0.0	0.002	0.0;   
			 0.0 	0.0		0.002]; 
IC(:,:,6) = [0.002	0.0     0.0;  
			 0.0	0.002	0.0;   
			 0.0 	0.0		0.0004]; 

% 获取杆件间的旋转矩阵(i+1在i下的表示) 
R(:,:,1) = [cos(angle(1)), 	-sin(angle(1)),	0.0; 
			sin(angle(1)), 	cos(angle(1)), 	0.0; 
			0.0,		   	0.0,			1.0];
        
R(:,:,2) = [sin(angle(2)),	cos(angle(2)),	0.0;  
			0.0,		   	0.0,			1.0;
			cos(angle(2)),	-sin(angle(2)), 0.0];
        
R(:,:,3) = [cos(angle(3)),	-sin(angle(3)),	0.0;  
			sin(angle(3)), 	cos(angle(3)),	0.0; 
			0.0,		   	0.0,			1.0];
        
R(:,:,4) = [cos(angle(4)),	-sin(angle(4)),	0.0; 
			0.0,		   	0.0,			-1.0; 
			sin(angle(4)), 	cos(angle(4)),	0.0];
        
R(:,:,5) = [cos(angle(5)),	-sin(angle(5)),	0.0; 
			0.0,		   	0.0,			1.0;
			-sin(angle(5)),	-cos(angle(5)),	0.0];
        
R(:,:,6) = [cos(angle(6)),	-sin(angle(6)),	0.0; 
			0.0,		   	0.0,			-1.0;
			sin(angle(6)), 	cos(angle(6)),	0.0];
			
% 获取杆件间的旋转逆矩阵(i在i+1下的表示) 
for i1 = 1:6
    inR(:,:,i1) = inv(R(:,:,i1));
end

% 迭代初始化
% 基座角速度为0
omiga_v0 = [0; 0; 0];
% 基座角加速度为0
omiga_a0 = [0; 0; 0];
% 基座线加速度为0
acc0 = [0; 0; 0];

% 外推，求杆件1-6的角速度，线加速度，角加速度
for i = 1:6
	if (i == 1)
		% 求杆件1角速度
		z = [0.0;0.0;angluar_v(i)];
		omiga_v(:,i) = ones(3,3)*omiga_v0 + z;
		% 求杆件1角加速度
		za = [0.0; 0.0; angluar_a(i)];
		omiga_a(:,i) = ones(3,3)*omiga_a0 + cross(ones(3,3)*omiga_v0, z) + za;
		% 求杆件1线加速度   
		acc(:,i) = ones(3,3)*(cross(omiga_a0, P(i,:)') + cross(omiga_v0, cross(omiga_v0, P(i,:)')) + acc0);
	else
		% 求杆件2-6角速度---ok
		z = [0.0;0.0;angluar_v(i)];
		omiga_v(:,i) = inR(:,:,i)*omiga_v(:,i-1) + z;
		% 求杆件2-6角加速度--ok
		za = [0.0; 0.0; angluar_a(i)];
		omiga_a(:,i) = inR(:,:,i)*omiga_a(:,i-1) + cross(inR(:,:,i)*omiga_v(:,i-1), z) + za;
		% 求杆件2-6线加速度--ok
		acc(:,i) = inR(:,:,i)*(cross(omiga_a(:,i-1), P(i,:)') + cross(omiga_v(:,i-1), cross(omiga_v(:,i-1), P(i,:)')) + acc(:,i-1));
    end

	% 求杆件1-6质心线加速度--ok
    accz(:,i) = cross(omiga_a(:,i), PC(i,:)') + cross(omiga_v(:,i), cross(omiga_v(:,i), PC(i,:)')) + acc(:,i);
	% 求杆件1-6惯性力
	force1(:,i) = mass(i)*accz(:,i);
	% 求杆件1-6惯性力矩
    torque1(:,i) = IC(:,:,i)*omiga_a(:,i) + cross(omiga_v(:,i), IC(:,:,i)*omiga_v(:,i));
end

% 末端关节受外力/力矩
force2out = [0; 0; 0];
torque2out = [0; 0; 0];

% 内推，求关节6-1的力和力矩	
for i=6:-1:1
	if (i==6)
		% 求杆件6受到的力--ok
		force2(:,i) = ones(3,3)*force2out + force1(:,i);
		% 求杆件6受到的力矩--ok
		torque2(:,i) = torque1(:,i) + ones(3,3)*torque2out + cross(PC(i,:)', force1(:,i)) + cross(zeros(3,1), ones(3,3)*force2out);
	else
		% 求杆件5-1受到的力
%         force1(:,i)
%         force2(:,i+1)
		force2(:,i) = R(:,:,i+1)*force2(:,i+1) + force1(:,i);
		% 求杆件5-1受到的力矩
		torque2(:,i) = torque1(:,i) + R(:,:,i+1)*torque2(:,i+1) + cross(PC(i,:)', force1(:,i)) + cross(P(i+1,:)', R(:,:,i+1)*force2(:,i+1));
	end
	
	% 关节i受力矩
    Torque(i) = torque2(3,i);
end