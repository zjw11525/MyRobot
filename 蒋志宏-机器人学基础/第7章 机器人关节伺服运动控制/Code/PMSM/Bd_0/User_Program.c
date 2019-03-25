#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "math.h"  

// Average of ADC
#define sqrt3				1.732050808
#define pi                  3.141592654

//	used in ADC
float Sensor_Coeff[2] = {9.41, 9.41};//电流传感器系数
float Voltage_Offset[2] = {1.31, 1.308};//电流传感器电压偏置

float Ia_Current = 0.0;//a相电流
float Ib_Current = 0.0;//b相电流
float Ia_average = 0.0;//a相电流平均
float Ib_average = 0.0;//b相电流平均
float Ia_Buffer[5] = {0.0,0.0,0.0,0.0,0.0};//采集五次取平均
float Ib_Buffer[5] = {0.0,0.0,0.0,0.0,0.0};
float min_a, max_a,min_b, max_b,s_a,s_b;//电流滤波中间变量
float AdcResult[2];//AD采样结果数组
float AD_Out[2] = {0.0, 0.0};

// used in Control_process
int position_times = 0;//位置环控制频次
int velocity_times = 0;//速度环控制频次
int current_times = 0;//电流环控制频次
int mode_choose = 0;//控制模式选择

float iREF_d;//d轴电流期望  
float iFB_d;//d轴电流反馈
float iREF_q;//q轴电流期望
float iFB_q;//q轴电流反馈 
extern float pREF;//位置期望
extern float pFB;//位置反馈
extern float sREF;//速度期望
extern float sFB;//速度反馈

Uint16 i_var = 0;

float pCONTROLLER(void);//位置PID控制函数
float sCONTROLLER(void);//速度PID控制函数
float iCONTROLLER_d(float iREF_d,float iFB_d);//d轴电流PID控制函数
float iCONTROLLER_q(float iREF_q,float iFB_q);//q轴电流PID控制函数

float Present_Motor_Position = 0.0;//电机当前位置
float Position_TEMP = 0.0;
float Theta_S = 0.0;//电机转过角度

//SVPWM控制算法所用变量
float Us_alpha = 0.0;
float Us_beta = 0.0;
float Is_alpha = 0.0;
float Is_beta = 0.0;
float Us_d = 0;
float Us_q = 0;
float Is_a = 0;
float Is_b = 0;
float Is_d = 0;
float Is_q = 0;

float Udc = 0.0;
int Us_quadrant = 0;

//	used in sCalculation速度计算所用变量
long Position_Rota[2];
int icounter = 0;
float Speed_Current_temp = 0.0;
float Speed_Current_temp_joint = 0.0;
float Speed_Current_joint = 0.0;


//	used in PWM
float Time_Coefficient = 120.0e6; // change to 120M
float Half_Tpwm	= 50.0e-6;
int Time_C_a = 0;
int Time_C_b = 0;
int Time_C_c = 0;
int t;

int direction;
int i_sin=0;


// read position data 
Uint16 i = 0;

Uint16 motor_data;
float motor_position = 0;//电机位置



void RESOLVER_DATCON(void)//电机码盘位置读取
{

		direction=EQep1Regs.QEPSTS.bit.QDF;
	if(direction==0&&EQep1Regs.QPOSCNT>4000)
		{
			EQep1Regs.QPOSCNT=4000;
		}

	motor_data =EQep1Regs.QPOSCNT;

	motor_position = ((float)motor_data*0.09);


	
}

void DelayForDataReading(void)//延时
{
	asm(" RPT #5 || NOP");   //110 ns
}

void DelayUs(volatile Uint16 Usec)
{
	while(Usec--)
	{
		asm(" RPT #5 || NOP");   //1 us loop at 150 MHz CPUCLK
	}
} 

void Inverse_PARK()          //逆Park变换
{
	Us_alpha = cos(Theta_S)*Us_d - sin(Theta_S)*Us_q;
	Us_beta  = sin(Theta_S)*Us_d + cos(Theta_S)*Us_q;
}

void CLARK(void)//Clark变换
{
	Is_alpha = 1.5 * Is_a;
	Is_beta = sqrt3/2.0 * Is_a+sqrt3 * Is_b;
}


void PARK()//PARK变换
{
	Is_d = cos(Theta_S)*Is_alpha + sin(Theta_S)*Is_beta;
	Is_q = -sin(Theta_S)*Is_alpha + cos(Theta_S)*Is_beta;
}

void ADC(void)//电流信号ADC采样
{
	// Start SEQ1 
	AdcRegs.ADCTRL2.all = 0x06000; 
	while (AdcRegs.ADCST.bit.SEQ1_BSY == 1); // Wait for AD Sampling.

 	AdcResult[0] = (float)(AdcRegs.ADCRESULT0>>4);	
    AdcResult[1] = (float)(AdcRegs.ADCRESULT1>>4);

	AD_Out[0] = AdcResult[0]*3.0/4095.0;			//Reference Voltage is 3.0V; 12bit ADC.
	AD_Out[1] = AdcResult[1]*3.0/4095.0;     		
	AdcRegs.ADCTRL2.bit.RST_SEQ1 = 1;	 //Reset SEQ1
    
	Ia_Current = Sensor_Coeff[0] * (AD_Out[0] - Voltage_Offset[0]);		
    Ib_Current = Sensor_Coeff[1] * (AD_Out[1] - Voltage_Offset[1]);	
  

      Ia_Buffer[4] =  Ia_Buffer[3];
      Ia_Buffer[3] =  Ia_Buffer[2];		
      Ia_Buffer[2] =  Ia_Buffer[1];
      Ia_Buffer[1] =  Ia_Buffer[0];
      Ia_Buffer[0] =  Ia_Current;
      
      Ib_Buffer[4] =  Ib_Buffer[3];
      Ib_Buffer[3] =  Ib_Buffer[2];
      Ib_Buffer[2] =  Ib_Buffer[1];
      Ib_Buffer[1] =  Ib_Buffer[0];
      Ib_Buffer[0] =  Ib_Current;


    s_a = min_a = max_a = Ia_Buffer[0];
    for(i = 0; i <5;i++)
    {
        s_a+=Ia_Buffer[i];//求和。
        if(min_a > Ia_Buffer[i]) min_a = Ia_Buffer[i];//最小值。
        if(max_a < Ia_Buffer[i]) max_a = Ia_Buffer[i];//最大值。
    }
    s_a -= min_a+max_a;//去掉最大最小两个值。
	Ia_average= s_a/3;   
    
        s_b = min_b = max_b = Ib_Buffer[0];
    for(i = 0; i <5;i++)
    {
        s_b+=Ib_Buffer[i];//求和。
        if(min_b > Ib_Buffer[i]) min_b = Ib_Buffer[i];//最小值。
        if(max_b < Ib_Buffer[i]) max_b = Ib_Buffer[i];//最大值。
    }
    s_b -= min_b+max_b;//去掉最大最小两个值。
    Ib_average=s_b/3;    
   
	Is_a = Ia_average;
	Is_b = Ib_average;
}

void SVPWM()//SVPWM控制算法
{

	float Va,Vb,Vc;
	int A,B,C;
	float X,Y,Z;
	float Time_1,Time_2,Time_0;
	float Time_a,Time_b,Time_c;
	float Sum_Time1_Time2;	
	
	Udc = 28.0;

//	Us_beta = 0.0;
//	Us_alpha = 2.0;

	//svpwm

	//扇区选择
	
	X = sqrt3*Half_Tpwm*Us_beta/Udc;
	Y = sqrt3*Half_Tpwm*Us_beta/(2*Udc)+1.5*Half_Tpwm*Us_alpha/Udc;
	Z = sqrt3*Half_Tpwm*Us_beta/(2*Udc)-1.5*Half_Tpwm*Us_alpha/Udc;

	Va = Us_beta;
	Vb = 0.5*(-sqrt3*Us_alpha-Us_beta);
	Vc = 0.5*(sqrt3*Us_alpha-Us_beta);

	if(Va > 0)
		A = 1;
	else
		A = 0;

	if(Vb > 0)
		B = 1;
	else
		B = 0;

	if(Vc > 0)
		C = 1;
	else
		C = 0;

	Us_quadrant = 4*A+2*B+C;

	if(Us_quadrant == 0) 
		Us_quadrant = 1;

	switch(Us_quadrant)
	{
		case 1:
			Time_1 = Y;
			Time_2 = -X;
			
			//防止出现饱和
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;	
			}	
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;
			
			Time_a = Time_0;
			Time_c = Time_0+Time_1;
			Time_b = Time_0+Time_1+Time_2;
					
			break;
			
		case 2:
			Time_1 = -X;
			Time_2 = Z;
			
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;		
			}
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;

			Time_c = Time_0;
			Time_b = Time_0+Time_1;
			Time_a = Time_0+Time_1+Time_2;
			
			break;
			
		case 3:                                 
			Time_1 = -Y;
			Time_2 = -Z;
			
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;	
			}
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;

			Time_c = Time_0;
			Time_a = Time_0+Time_1;
			Time_b = Time_0+Time_1+Time_2;
			
			break;
			
		case 4:
			Time_1 = Z;
			Time_2 = Y;
			
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;		
			}
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;

			Time_b = Time_0;
			Time_a = Time_0+Time_1;
			Time_c = Time_0+Time_1+Time_2;
			
			break;
			
		case 5:
			Time_1 = -Z;
			Time_2 = X;
			
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;		
			}
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;

			Time_a = Time_0;
			Time_b = Time_0+Time_1;
			Time_c = Time_0+Time_1+Time_2;
			
			break;
			
		case 6:
			Time_1 = X;
			Time_2 = -Y;
			
			if(Time_1+Time_2 > Half_Tpwm)
			{
				Sum_Time1_Time2 = Time_1+Time_2;
				Time_1 = Time_1*Half_Tpwm/Sum_Time1_Time2;
				Time_2 = Time_2*Half_Tpwm/Sum_Time1_Time2;	
			}
			
			Time_0 = (Half_Tpwm-Time_1-Time_2)/2.0;
//			Time_7 = (Half_Tpwm-Time_1-Time_2)/2.0;

			Time_b = Time_0;
			Time_c = Time_0+Time_1;
			Time_a = Time_0+Time_1+Time_2;
			
			break;
	}
	
	Time_C_a = (int)(Time_a*Time_Coefficient);
	Time_C_b = (int)(Time_b*Time_Coefficient);
	Time_C_c = (int)(Time_c*Time_Coefficient);
	
//	Time_C_a = 4000;
//	Time_C_b = 4000;
//	Time_C_c = 4000;

    if(Time_C_a > 5999 ) Time_C_a = 5999;
    else if(Time_C_a < 1 ) Time_C_a = 1;
    
    if(Time_C_b > 5999 ) Time_C_b = 5999;
    else if(Time_C_b < 1 ) Time_C_b = 1;
    
    if(Time_C_c > 5999 ) Time_C_c = 5999;
    else if(Time_C_c < 1 ) Time_C_c = 1;
    
	EPwm1Regs.CMPA.half.CMPA =  Time_C_a;     // Set compare A value

	EPwm2Regs.CMPA.half.CMPA =  Time_C_b;     // Set compare A value

	EPwm3Regs.CMPA.half.CMPA =  Time_C_c;     // Set compare A value    
    
}


void Position_Calculate(void)//所用电机为2对极根据电角度，位置分区
{
                           

	Present_Motor_Position = motor_data; 
	  

	if ((Present_Motor_Position >= 1873) && (Present_Motor_Position < 3873))
	{
	   	Position_TEMP = Present_Motor_Position-1873;
		Theta_S = 2.0*pi*Position_TEMP/2000;
	}
//2	

	if ((Present_Motor_Position >= 0) && (Present_Motor_Position < 1873))
	{
	   Position_TEMP = Present_Motor_Position+4000-3873;
	   Theta_S = 2.0*pi*Position_TEMP/2000;
	}
		if ((Present_Motor_Position >= 3873) && (Present_Motor_Position <4000))
	{
	   Position_TEMP = Present_Motor_Position-3873;
	   Theta_S = 2.0*pi*Position_TEMP/2000;
	}   
	
}


float sCalculation(void)//速度计算
{
    
    float Speed_Current = 0.0;
    
	Position_Rota[icounter] = motor_data;
	
	icounter++;
	if(icounter == 2)
	{

		Speed_Current_temp = (float)(Position_Rota[1] - Position_Rota[0]);
		if(Speed_Current_temp > 3000) Speed_Current_temp -= 4000;
	    else if(Speed_Current_temp < -3000) Speed_Current_temp += 4000; 

		Position_Rota[0] = Position_Rota[1];
		
		icounter = 1;
		
	}
	Speed_Current = (Speed_Current_temp /4000)*5000*2*3.1415;//PWM中断为10K每两次进一次控制函数，计算速度时时间为1/5000s

	return Speed_Current;
}

void Control_process(void)//控制函数
{
	EALLOW;
	GpioDataRegs.GPBDAT.bit.GPIO57 = 0;//Read Enable Signal _ Low
  	GpioDataRegs.GPADAT.bit.GPIO23 = 0;//Read Enable Signal for Joint  Low	

	GpioDataRegs.GPADAT.bit.GPIO18 = 0;//Read Enable Signal _ Low
	GpioDataRegs.GPADAT.bit.GPIO20 = 0;//Read Enable Signal _ High
  	EDIS;   
	
	for(i_var=0; i_var<50; i_var++)
   	{
      DelayForDataReading();
   	}	
   	
 	ADC();
 	
	CLARK();
	PARK();
	iFB_d = Is_d;
	iFB_q = Is_q;
	
	Position_Calculate();   

	pFB = motor_position;	
	
if(mode_choose==1)	//位置控制模式
{

	if(position_times==10)	// 位置环
	{
	sREF = pCONTROLLER();	

 	position_times=0;
	}	
	position_times++	;	
	if(velocity_times==2)	// 速度环
	{

	iREF_q = sCONTROLLER();
	
 	velocity_times=0;
	}	
	velocity_times++	;
	
	if(current_times==1)	// 电流环
	{
	iREF_d = 0.0;
	Us_d = iCONTROLLER_d(iREF_d,iFB_d);
	Us_q = iCONTROLLER_q(iREF_q,iFB_q);	

 	current_times=0;
	}	
	current_times++	;		

}
else if(mode_choose==2)	//速度控制模式
{


	if(velocity_times==2)	// 速度环
	{

	iREF_q = sCONTROLLER();
	
 	velocity_times=0;
	}	
	velocity_times++	;
	
	if(current_times==1)	// 电流环
	{
	iREF_d = 0.0;
	Us_d = iCONTROLLER_d(iREF_d,iFB_d);
	Us_q = iCONTROLLER_q(iREF_q,iFB_q);	

 	current_times=0;
	}	
	current_times++	;		

}
else if(mode_choose==3)	//电流控制模式
{



	if(current_times==1)	// 电流环
	{
	iREF_d = 0.0;
//	iREF_q = 0.0;
	Us_d = iCONTROLLER_d(iREF_d,iFB_d);
	Us_q = iCONTROLLER_q(iREF_q,iFB_q);

 	current_times=0;
	}	
	current_times++	;	

}

	Inverse_PARK();
	SVPWM();
	RESOLVER_DATCON();
	sFB = sCalculation();
	
}


