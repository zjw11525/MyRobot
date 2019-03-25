#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "math.h"  

#define CPU_FRQ_120MHZ   1


interrupt void cpu_timer0_isr(void);
interrupt void epwm1_isr(void);

//	初始化
void CPUTimer0_Init(void);
void GPIO_Init(void);
void EPWM1Init(void);//PWM1初始化配置
void EPWM2Init(void);//PWM2初始化配置
void EPWM3Init(void);//PWM3初始化配置
void ADCInit(void);//ADC模块初始化
void POSSPEED_Init(void);//位置计数模块初始化

void Control_process(void);//控制函数

int LED =0;
long I_LED = 0;
int loop = 0;     
int en_2136=0;


void main(void)
{
	
	InitSysCtrl();//system time reset   	
	GPIO_Init();	//init I/O		

   	DINT;
	
	InitPieCtrl();   
   	IER = 0x0000;
   	IFR = 0x0000;
   	InitPieVectTable();
	
	EALLOW; 
   	PieVectTable.TINT0 = &cpu_timer0_isr;  	
	PieVectTable.EPWM1_INT = &epwm1_isr;
  	EDIS;
  	
  	CPUTimer0_Init();
	

	InitEQep1Gpio();
	POSSPEED_Init();
	
	EALLOW;
   	SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0;
   	EDIS;		
	
	EPWM1Init();	

	EPWM2Init();	

	EPWM3Init();	
		
	EALLOW;
   	SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
   	EDIS;
  	
  	ADCInit();
	
 	IER |= M_INT1;//Timer_0
 	IER |= M_INT3;//PWM
   	
	PieCtrlRegs.PIEIER1.bit.INTx7 = 1;//Enable Timer_0 interrupt可用于测时间
	PieCtrlRegs.PIEIER3.bit.INTx1 = 1;//Enable PWM1 interrupt 
	EINT;   // Enable Global interrupt INTM
	ERTM;   // Enable Global realtime interrupt DBGM   


	while(1)
	{     

			

			if(en_2136==1)
			{GpioDataRegs.GPBCLEAR.bit.GPIO50 = 1;}//使能2136
			else
			{GpioDataRegs.GPBSET.bit.GPIO50=1;}
			

        	if(LED == 0)//程序运行指示信号灯
        	{
        		I_LED++;
        		if(I_LED == 1110000)   //  10000--> 111Hz    1110000-->1Hz
        		{
        			LED = 1;
        			GpioDataRegs.GPACLEAR.bit.GPIO11 = 1;
        		}        		
        	}
        	
        	if(LED == 1)
        	{
        		I_LED--;
        		if(I_LED == 0)
        		{
        			LED = 0;
        			GpioDataRegs.GPASET.bit.GPIO11 = 1;
        		}        		
        	}
        
	}
}


interrupt void cpu_timer0_isr(void)
{
	DINT;
	CpuTimer0Regs.TCR.bit.TIF = 1;

   CpuTimer0.InterruptCount++;

   	PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;
   	EINT;
}


interrupt void epwm1_isr(void)//PWM中断函数
{

	EPwm1Regs.ETCLR.bit.INT = 1;
	BLDCM_PWM_DRIVER();//直流无刷驱动

if(loop%2)
{

	Control_process();//控制函数
}	
loop ++;
if (loop > 800) loop = 1;   
   
   PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}


