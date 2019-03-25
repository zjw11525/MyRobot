%此程序为RS10N型工业机器人的逆运动学求解程序
%程序输入为期望的末端位姿矩阵T，和机器人当前的关节角a（单位：弧度），其中T为4×4的矩阵，a为6维行向量
%程序输出为满足末端位姿矩阵的关节角joint，和判断是否奇异的标志位dd,其中joint为6维行向量，当dd=1时不奇异，当dd=0时，存在奇异问题
function [joint,dd]=Googo_Inkin_5(T,a)
	dd=1;

	P1=430;
	P2=99.56;
	P3=0;
	P4=650.74;
	P5=1.05;
	P6=700.23;
	P7=202;    

	T67=[1,0,0,0
    0,1,0,0
    0,0,1,P7
    0,0,0,1];

    T06=T*inv(T67);

	px =T06(1,4);
	py =T06(2,4);
	pz =T06(3,4);
	
	%变量初始化
	T01=zeros(4,4);
	T12=zeros(4,4);
	T23=zeros(4,4);
	T03=zeros(4,4);
	T36=zeros(4,4);
	r13=zeros(8,1);
	r23=zeros(8,1);
	r33=zeros(8,1);
	r21=zeros(8,1);
	r22=zeros(8,1);
	c5=zeros(8,1);
	s5=zeros(8,1);

	Theta=zeros(8,6);
	r13=0;
	r21=0;
	e22=0;
	r23=0;
	r33=0;

    %Theta为8×6的矩阵，每行代表逆运动学的一组解
	
	%求theta1，有两组解
	Theta(1,1)=atan2(py,px);
	Theta(2,1)=Theta(1,1);
	Theta(3,1)=Theta(1,1);
	Theta(4,1)=Theta(1,1);
	Theta(5,1)=atan2(-py,-px);
	Theta(6,1)=Theta(5,1);
	Theta(7,1)=Theta(5,1);
	Theta(8,1)=Theta(5,1);   
	 
	 for i=1:8
	     %求theta3，有两组解 
		 if abs(sin(Theta(i,1))) < 1e-6  %判断theta1是否为0
			 M=px/cos(Theta(i,1));
		 else
			 M=py/sin(Theta(i,1));
		 end
		 
		 N=pz-P1;
		 Q=((M+P2)^2+N^2-P5^2-P6^2-P4^2)/(2*P4);
		 Rou=sqrt(P5^2+P6^2);
		 
        %判断是否奇异，若奇异，则令dd=0;
		 if (1-Q^2/Rou^2)<0
			dd=0;
         end
          
    if 1-Q^2/Rou^2<0
         if sign(Q*Rou)==1
             Q=Rou;
         end
         if sign(Q*Rou)==-1
             Q=-Rou;
         end
     end

      if abs(Q/Rou)<0.001
          Q=Rou;
      end
      if abs(Q+Rou)<0.001
          Q=-Rou;
      end
         
         %根据theta1的两组解分别求解theta3
		 if i==1||i==2||i==5||i==6
			 Theta(i,3)=atan2(Q/Rou,sqrt(1-Q^2/Rou^2))-atan2(P5,P6);
		 else
			 Theta(i,3)=atan2(Q/Rou,-sqrt(1-Q^2/Rou^2))-atan2(P5,P6);
		 end
	 end
	 
	 
	%求theta2
	 for i=1:8
		 if abs(sin(Theta(i,1)))<0.000001
			 M=px/cos(Theta(i,1));
		 else
			 M=py/sin(Theta(i,1));
		 end
		 N=pz-P1;
		 K=M+P2;
		 P=P5*cos(Theta(i,3))+P6*sin(Theta(i,3))+P4;
		 Q=P5*sin(Theta(i,3))-P6*cos(Theta(i,3));
		 s2=(K*P-N*Q)/(P^2+Q^2);
         c2=(K*Q+N*P)/(P^2+Q^2);
         Theta(i,2)=atan2(s2,c2);         
     end

	%求theta5   
	   for j=1:8
			   
		t1=[cos(Theta(j,1)),    -sin(Theta(j,1)),   0,  0; 
			sin(Theta(j,1)),    cos(Theta(j,1)),    0,  0;
			0,  0,  1,  P1;
			0,  0,  0,  1];

		t2=[sin(Theta(j,2)) ,   cos(Theta(j,2)),   0,  -P2;
			0,  0,  1, 0;
			cos(Theta(j,2)),   -sin(Theta(j,2)),    0,  0;
			0,  0,  0,  1];

		t3=[cos(Theta(j,3)),    -sin(Theta(j,3)),   0,  P4;
			sin(Theta(j,3)),    cos(Theta(j,3)),    0,  0;
			0,  0,  1,  P3;
			0,  0,  0,  1];
	  
		   T03(:,:,j)=t1*t2*t3;
		   T36(:,:,j)=inv(T03(:,:,j))*T06;
		   
		   r11(j)=T36(1,1,j);
		   r12(j)=T36(1,2,j);
		   r13(j)=T36(1,3,j);
		   r21(j)=T36(2,1,j);
		   r22(j)=T36(2,2,j);
		   r23(j)=T36(2,3,j);
		   r31(j)=T36(3,1,j);
		   r32(j)=T36(3,2,j);
		   r33(j)=T36(3,3,j);
		  
	   end

	   for i2=1:8
		 c5(i2)=-r23(i2);
		 if c5(i2)>1
			 c5(i2)=1;
		 end
		 if c5(i2)<-1
			 c5(i2)=-1;
		 end
		 s5(i2)=sqrt(1-c5(i2)^2);
	   end

		s5(2)=-s5(2);
		s5(4)=-s5(4);
		s5(6)=-s5(6);
		s5(8)=-s5(8);

	   for i3=1:8
		   Theta(i3,5)=atan2(s5(i3),c5(i3));          
		   
	   end
	 
	 %求theta4,6
	 for i4=1:8     
		 s5=sin(Theta(i4,5));
		 c5=cos(Theta(i4,5));
		 if abs(s5)>0.0000000000001         
			 c4=r13(i4)/s5;
			 s4=r33(i4)/s5;
			 Theta(i4,4)=atan2(s4,c4);
			 s6=-r22(i4)/s5;
			 c6=r21(i4)/s5;
			 Theta(i4,6)=atan2(s6,c6);
		 else
			 Theta(i4,4)=a(4);
			 Theta(i4,6)=atan2(r31(i4),r32(i4))-a(4);         
		 end
	 end
	 

	%%%对数据进行筛选与处理
	for i=1:8
		for j=1:3
			if Theta(i,j)>pi
				Theta(i,j)=2*pi-Theta(i,j);
			end
			if Theta(i,j)<-pi
				Theta(i,j)=2*pi+Theta(i,j);
			end
		end
	end

	for i=1:8
		if abs(Theta(i,4)-a(4))>(2*pi-0.0001)
			if a(4)>0
				Theta(i,4)=Theta(i,4)+2*pi;
			end
			if a(4)<0
				Theta(i,4)=Theta(i,4)-2*pi;
			end
		end
		
		if abs(Theta(i,6)-a(6))>(2*pi-0.0001)
			if a(6)>0
				Theta(i,6)=Theta(i,6)+2*pi;
			end
			if a(6)<0
				Theta(i,6)=Theta(i,6)-2*pi;
			end
		end
	end
			
		for i=1:8
			if abs(Theta(i,1)+pi)<0.0001
				Theta(i,1)=pi;
			end
        end
	
     %计算每一组解与当前关节角的差值，选择与当前关节角相比运动量最小的一组作为最终解
	 for i=1:8
		 k(i,:)=Theta(i,:)-a;
		 kk(i,:)=abs(k(i,:));
     end
     
	 sum=zeros(1,8);
	 for i=1:8
	     sum(i)=kk(i,1)+kk(i,2)+kk(i,3)++kk(i,4)++kk(i,5)++kk(i,6);
	 end
	 [x,y]= find(sum==min(sum));
	 j_out=Theta(y,:);

	joint=j_out(1,:);

end



