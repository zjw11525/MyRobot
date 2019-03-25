#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "math.h"  


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
float Is_a = 0;
float Is_b = 0;
float Is_c = 0;
float Is=0;
float AdcResult[2];//AD采样结果数组
float AD_Out[2] = {0.0, 0.0};

// used in Control_process
int position_times = 0;//位置环控制频次
int velocity_times = 0;//速度环控制频次
int current_times = 0;//电流环控制频次
int mode_choose = 0;//控制模式选择

float iREF;//电流期望
float iFB;//电流反馈 
extern float pREF;//位置期望
extern float pFB;//位置反馈
extern float sREF;//速度期望
extern float sFB;//速度反馈


Uint16 i_var = 0;

float pCONTROLLER(void);//位置PID控制函数
float sCONTROLLER(void);//速度PID控制函数
float iCONTROLLER(float iREF,float iFB);//电流PID控制函数

float Present_Motor_Position = 0.0;//电机当前位置
float Position_TEMP = 0.0;


//	used in sCalculation速度计算所用变量
long Position_Rota[2];
long Position_Rota_joint[2];
int icounter = 0;
float Speed_Current_temp = 0.0;
float Speed_Current_temp_joint = 0.0;
float Speed_Current_joint = 0.0;
int i=0;

int direction;//电机旋转方向
Uint16 motor_data;//电机码盘读数
float motor_position = 0;//电机位置

int H1_COMMUTATION = 0;   //霍尔
int	H2_COMMUTATION = 0;   
int	H3_COMMUTATION = 0; 
int SP=610;//占空比

void RESOLVER_DATCON(void)//电机位置解算
{

		direction=EQep1Regs.QEPSTS.bit.QDF;
	if(direction==0&&EQep1Regs.QPOSCNT>4000)
		{
			EQep1Regs.QPOSCNT=4000;
		}
	
	motor_data =EQep1Regs.QPOSCNT;

	motor_position = ((float)motor_data*360/4000);


	
}

void DelayForDataReading(void)
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



void ADC(void)//电流采样
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

void BLDCM_PWM_DRIVER(void)//直流无刷驱动程序
{
 	EALLOW;
	EPwm1Regs.CMPA.half.CMPA =SP;//设置占空比
	EPwm2Regs.CMPA.half.CMPA =SP;
	EPwm3Regs.CMPA.half.CMPA =SP;
	EDIS;



	if(H1_COMMUTATION == 0 && H2_COMMUTATION == 1 && H3_COMMUTATION == 0 )//SECTION-1,30~90度:A+,B-
	{
			
	EPwm2Regs.AQCTLA.all= 0x90;      //设置PWM2波形输出        
	EPwm2Regs.AQCSFRC.all=0x00;	
	EPwm2Regs.DBCTL.all=0x0b;

	EPwm1Regs.AQCTLA.all= 0x60;       //设置PWM1波形输出        
	EPwm1Regs.AQCSFRC.all=0x00;	
	EPwm1Regs.DBCTL.all=0x0b;  
   


	EPwm3Regs.AQCTLA.all= 0x00;      //设置PWM3波形输出         
	EPwm3Regs.AQSFRC.all=0x05;	
	EPwm3Regs.DBCTL.all=0x03; 
	
	Is=-Is_a;
	
	}

	else if(H1_COMMUTATION == 0 && H2_COMMUTATION == 1 && H3_COMMUTATION == 1 )//SECTION-1,30~90度:A+,B-
	{
	
	EPwm3Regs.AQCTLA.all= 0x90;             
	EPwm3Regs.AQCSFRC.all=0x00;	
	EPwm3Regs.DBCTL.all=0x0b;

	EPwm1Regs.AQCTLA.all= 0x60;            
	EPwm1Regs.AQCSFRC.all=0x00;	
	EPwm1Regs.DBCTL.all=0x0b;  
   


	EPwm2Regs.AQCTLA.all= 0x00;             
	EPwm2Regs.AQSFRC.all=0x05;	
	EPwm2Regs.DBCTL.all=0x03; 
	
	Is=-Is_a;
	}

	else if(H1_COMMUTATION == 0 && H2_COMMUTATION == 0 && H3_COMMUTATION == 1 )//SECTION-2,90~150度:A+,C-
	{

	
	EPwm3Regs.AQCTLA.all= 0x90;             
	EPwm3Regs.AQCSFRC.all=0x00;	
	EPwm3Regs.DBCTL.all=0x0b;

	EPwm2Regs.AQCTLA.all= 0x60;             
	EPwm2Regs.AQCSFRC.all=0x00;	
	EPwm2Regs.DBCTL.all=0x0b;  
   


	EPwm1Regs.AQCTLA.all= 0x00;             
	EPwm1Regs.AQSFRC.all=0x05;	
	EPwm1Regs.DBCTL.all=0x03; 
	
	Is=-Is_b;
	}


	else if(H1_COMMUTATION == 1 && H2_COMMUTATION == 0 && H3_COMMUTATION == 1 )//SECTION-3,150~210度:B+,C-
	{

	EPwm1Regs.AQCTLA.all= 0x90;             
	EPwm1Regs.AQCSFRC.all=0x00;	
	EPwm1Regs.DBCTL.all=0x0b;

	EPwm2Regs.AQCTLA.all= 0x60;            
	EPwm2Regs.AQCSFRC.all=0x00;	
	EPwm2Regs.DBCTL.all=0x0b;  
   


	EPwm3Regs.AQCTLA.all= 0x00;             
	EPwm3Regs.AQSFRC.all=0x05;	
	EPwm3Regs.DBCTL.all=0x03; 
	
	Is=-Is_b;
	
	
	}

	else if(H1_COMMUTATION == 1 && H2_COMMUTATION == 0 && H3_COMMUTATION == 0 )//SECTION-4,210~270度:A-,B+
	{
	
	EPwm1Regs.AQCTLA.all= 0x90;             
	EPwm1Regs.AQCSFRC.all=0x00;	
	EPwm1Regs.DBCTL.all=0x0b;

	EPwm3Regs.AQCTLA.all= 0x60;             
	EPwm3Regs.AQCSFRC.all=0x00;	
	EPwm3Regs.DBCTL.all=0x0b;  
   


	EPwm2Regs.AQCTLA.all= 0x00;             
	EPwm2Regs.AQSFRC.all=0x05;	
	EPwm2Regs.DBCTL.all=0x03;
	
	Is=Is_a; 
	}

	else if(H1_COMMUTATION == 1 && H2_COMMUTATION == 1 && H3_COMMUTATION == 0 )//SECTION-5,270~330度:A-,C+
	{
		
	EPwm2Regs.AQCTLA.all= 0x90;             
	EPwm2Regs.AQCSFRC.all=0x00;	
	EPwm2Regs.DBCTL.all=0x0b;

	EPwm3Regs.AQCTLA.all= 0x60;             
	EPwm3Regs.AQCSFRC.all=0x00;	
	EPwm3Regs.DBCTL.all=0x0b;  
   


	EPwm1Regs.AQCTLA.all= 0x00;             
	EPwm1Regs.AQSFRC.all=0x05;	
	EPwm1Regs.DBCTL.all=0x03; 
	
	Is=Is_b;
	}

	else;
}


float sCalculation(void)//电机速度计算
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
	Speed_Current = (Speed_Current_temp /4000)*5000*2*3.1415;

	return Speed_Current;
}

void Control_process(void)
{
	EALLOW;
 	H1_COMMUTATION = GpioDataRegs.GPADAT.bit.GPIO27;   //检测霍尔信号
	H2_COMMUTATION = GpioDataRegs.GPBDAT.bit.GPIO48;   
	H3_COMMUTATION = GpioDataRegs.GPBDAT.bit.GPIO49;  
	EDIS;

	
	for(i_var=0; i_var<50; i_var++)
   	{
      DelayForDataReading();
   	}	
   	
 	ADC();

pFB = motor_position;
sFB = sCalculation();
iFB=Is;
if(mode_choose==1)	//位置环模式控制
{
	if(position_times==40)	
	{
	sREF=pCONTROLLER();		

 	position_times=0;
	}	
	position_times++	;	
	
	if(velocity_times==8)	// 速度环
	{
		
	iREF=sCONTROLLER();

 	velocity_times=0;
	}	
	velocity_times++	;
	
		if(current_times==4)//电流环	
	{

	SP=iCONTROLLER(iREF,iFB);
	
 	current_times=0;
	}	
	current_times++	;		
		
}
else if(mode_choose==2)	//速度环模式控制
{

	if(velocity_times==8)	
	{

	iREF=sCONTROLLER();
	
 	velocity_times=0;
	}	
	velocity_times++	;
	
	if(current_times==4)	
	{

	SP=iCONTROLLER(iREF,iFB);
	
 	current_times=0;
	}	
	current_times++	;	
}

else if(mode_choose==3)	//电流环模式控制
{

	if(current_times==4)	
	{

	SP=iCONTROLLER(iREF,iFB);
	
 	current_times=0;
	}	
	current_times++	;	

}
	RESOLVER_DATCON();		
}



