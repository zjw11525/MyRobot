#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File

#if CPU_FRQ_120MHZ
	#define ADC_MODCLK 0x2 // HSPCLK = SYSCLKOUT/2*ADC_MODCLK = 120/(2*2)   = 30.0 MHz
#endif
#define ADC_CKPS   0x2   // ADC module clock = HSPCLK/2*ADC_CKPS   = 30.0MHz/(2*2) = 7.5MHz
#define ADC_SHCLK  0x7   // S/H width in ADC module periods= (1+ADC_SLHCL)*ADC clocks


void POWER_IO_Init(void);
void PWM_GPio_Init(void);
void spi_GPio_Init(void);  //add in 0515
void POSSPEED_Init(void);


void DelayForDataReading();	// used in Mcbsp_spi_init

Uint16 i2 = 0;	// used in Mcbsp_spi_init

void CPUTimer0_Init(void)
{
   InitCpuTimers(); 
   
#if (CPU_FRQ_150MHZ)
   ConfigCpuTimer(&CpuTimer0, 150, 500);
#endif

#if (CPU_FRQ_100MHZ)
   ConfigCpuTimer(&CpuTimer0, 100, 500);
#endif

#if (CPU_FRQ_120MHZ)
   ConfigCpuTimer(&CpuTimer0, 120, 10000);
#endif

   	CpuTimer0Regs.TCR.bit.TSS = 0;
}

void GPIO_Init(void)
{
	EALLOW;		//init display I/O
	GpioCtrlRegs.GPAPUD.bit.GPIO11 = 0;
	GpioCtrlRegs.GPAMUX1.bit.GPIO11 = 0;
	GpioCtrlRegs.GPADIR.bit.GPIO11 = 1;
	GpioDataRegs.GPASET.bit.GPIO11 = 1;
	
	GpioCtrlRegs.GPBPUD.bit.GPIO50 = 0;
	
	GpioCtrlRegs.GPBDIR.bit.GPIO50 = 1;
	GpioDataRegs.GPBSET.bit.GPIO50 = 1;
	EDIS;

	InitECanaGpio();	//init CAN I/O
	POWER_IO_Init();	//init Power I/O
	PWM_GPio_Init();	//init PWM I/O
	spi_GPio_Init();	//init Spi I/O
}



void POWER_IO_Init(void) //
{
//Set as I/O Port
 	EALLOW;
//IO->25 is defined as I/O for ENABLE_1
	GpioCtrlRegs.GPAPUD.bit.GPIO25 = 0;  	// Enable pullup on GPIO25
  	GpioCtrlRegs.GPAMUX2.bit.GPIO25 = 0; 	// GPIO25 = GPIO25
   	GpioCtrlRegs.GPADIR.bit.GPIO25 = 1; 	// GPIO25 = output    BREAK
	GpioDataRegs.GPASET.bit.GPIO25 = 1;		//ENABLE ACTIVE
//	GpioDataRegs.GPACLEAR.bit.GPIO25 = 1;	//DISABLE ACTIVE
//IO->26 is defined as I/O for DRIVE
	GpioCtrlRegs.GPAPUD.bit.GPIO26 = 0;  	// Enable pullup on GPIO26
  	GpioCtrlRegs.GPAMUX2.bit.GPIO26 = 0; 	// GPIO26 = GPIO26
   	GpioCtrlRegs.GPADIR.bit.GPIO26 = 1;  	// GPIO26 = output    DRIVE
//	GpioDataRegs.GPACLEAR.bit.GPIO26 = 1;	//ENABLE IR2136
	GpioDataRegs.GPASET.bit.GPIO26 = 1;		//DISABLE IR2136
//IO->27 is defined as I/O for FAULT
	GpioCtrlRegs.GPAPUD.bit.GPIO29 = 0;  	// Enable pullup on GPIO29
  	GpioCtrlRegs.GPAMUX2.bit.GPIO29 = 0; 	// GPIO29 = GPIO29
   	GpioCtrlRegs.GPADIR.bit.GPIO29 = 1;  	// GPIO29 = output    FAULT  
   	GpioDataRegs.GPACLEAR.bit.GPIO29 = 1;
//IO->29 is defined as I/O for WP
	GpioCtrlRegs.GPAPUD.bit.GPIO27 = 0;  	// Enable pullup on GPIO27
  	GpioCtrlRegs.GPAMUX2.bit.GPIO27 = 0; 	// GPIO27 = GPIO27
   	GpioCtrlRegs.GPADIR.bit.GPIO27 = 0;  	// GPIO27 = input    WP
    
    EDIS;
} 


void PWM_GPio_Init(void)
{

	EALLOW;
    GpioCtrlRegs.GPAPUD.bit.GPIO0 = 0;   // Enable pullup on GPIO0
    GpioCtrlRegs.GPAPUD.bit.GPIO1 = 0;   // Enable pullup on GPIO1
    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;  // GPIO0 = PWM1A
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;  // GPIO1 = PWM1B   
    EDIS;


    EALLOW;
	GpioCtrlRegs.GPAPUD.bit.GPIO2 = 0;   // Enable pullup on GPIO2
	GpioCtrlRegs.GPAPUD.bit.GPIO3 = 0;   // Enable pullup on GPIO3
	GpioCtrlRegs.GPAMUX1.bit.GPIO2 = 1;  // GPIO2 = PWM2A
	GpioCtrlRegs.GPAMUX1.bit.GPIO3 = 1;  // GPIO3 = PWM2B
    EDIS;
    
    EALLOW;
    GpioCtrlRegs.GPAPUD.bit.GPIO4 = 0;   // Enable pullup on GPIO4
    GpioCtrlRegs.GPAPUD.bit.GPIO5 = 0;   // Enable pullup on GPIO5
    GpioCtrlRegs.GPAMUX1.bit.GPIO4 = 1;  // GPIO4 = PWM3A
    GpioCtrlRegs.GPAMUX1.bit.GPIO5 = 1;  // GPIO5 = PWM3B
    EDIS;
    

}

void spi_GPio_Init(void) //  add in 0515
{

  EALLOW;
/* Enable internal pull-up for the selected pins */
// Pull-ups can be enabled or disabled by the user.  
// This will enable the pullups for the specified pins.
// Comment out other unwanted lines.

//MCBSP SPI for joint
	GpioCtrlRegs.GPAPUD.bit.GPIO21 = 0;		// Enable pull-up on GPIO21
	GpioCtrlRegs.GPAQSEL2.bit.GPIO21 = 3; // Asynch input GPIO21
	GpioCtrlRegs.GPAMUX2.bit.GPIO21 = 2; // Configure GPIO21 as MDRA

	GpioCtrlRegs.GPAPUD.bit.GPIO22 = 0;		// Enable pull-up on GPIO22
	GpioCtrlRegs.GPAQSEL2.bit.GPIO22 = 3; // Asynch input GPIO22 
	GpioCtrlRegs.GPAMUX2.bit.GPIO22 = 2; // Configure GPIO22 as MCLKXA

	GpioCtrlRegs.GPAPUD.bit.GPIO23 = 0;		// Enable pull-up on GPIO23
	GpioCtrlRegs.GPAQSEL2.bit.GPIO23 = 3; // Asynch input GPIO23 
	GpioCtrlRegs.GPAMUX2.bit.GPIO23 = 0; // Configure GPIO23 as I/O for SPITE
    GpioCtrlRegs.GPADIR.bit.GPIO23 = 1;		// set as out

    GpioCtrlRegs.GPAPUD.bit.GPIO18 = 0;   // Enable pull-up on GPIO18 (RD_J_L)
    GpioCtrlRegs.GPAPUD.bit.GPIO20 = 0;   // Enable pull-up on GPIO21 (RD_J_H)

    GpioCtrlRegs.GPAQSEL2.bit.GPIO18 = 3; // Asynch input GPIO18 (RD_J_L)
    GpioCtrlRegs.GPAQSEL2.bit.GPIO20 = 3; // Asynch input GPIO20 (RD_J_H)
    
    GpioCtrlRegs.GPAMUX2.bit.GPIO18 = 0; // Configure GPIO18 as I/O //  RD_J_L
    GpioCtrlRegs.GPADIR.bit.GPIO18 = 1;		// set as out
    
    GpioCtrlRegs.GPAMUX2.bit.GPIO20 = 0; // Configure GPIO20 as I/O //  RD_J_H
    GpioCtrlRegs.GPADIR.bit.GPIO20 = 1;		// set as out

//SPI for motor
    GpioCtrlRegs.GPBPUD.bit.GPIO54 = 0;   // Enable pull-up on GPIO54 (SPISIMOA)
    GpioCtrlRegs.GPBPUD.bit.GPIO55 = 0;   // Enable pull-up on GPIO55 (SPISOMIA)
    GpioCtrlRegs.GPBPUD.bit.GPIO56 = 0;   // Enable pull-up on GPIO56 (SPICLKA)
    GpioCtrlRegs.GPBPUD.bit.GPIO57 = 0;   // Enable pull-up on GPIO57 (SPISTEA)
    


/* Set qualification for selected pins to asynch only */
// This will select asynch (no qualification) for the selected pins.
// Comment out other unwanted lines.


    GpioCtrlRegs.GPBQSEL2.bit.GPIO54 = 3; // Asynch input GPIO54 (SPISIMOA)
    GpioCtrlRegs.GPBQSEL2.bit.GPIO55 = 3; // Asynch input GPIO55 (SPISOMIA)
    GpioCtrlRegs.GPBQSEL2.bit.GPIO56 = 3; // Asynch input GPIO56 (SPICLKA)
    GpioCtrlRegs.GPBQSEL2.bit.GPIO57 = 3; // Asynch input GPIO57 (SPISTEA)
    
    
/* Configure SPI-A pins using GPIO regs*/
// This specifies which of the possible GPIO pins will be SPI functional pins.
// Comment out other unwanted lines.

    GpioCtrlRegs.GPBMUX2.bit.GPIO54 = 1; // Configure GPIO54 as SPISIMOA
    GpioCtrlRegs.GPBMUX2.bit.GPIO55 = 1; // Configure GPIO55 as SPISOMIA
    GpioCtrlRegs.GPBMUX2.bit.GPIO56 = 1; // Configure GPIO56 as SPICLKA
    GpioCtrlRegs.GPBMUX2.bit.GPIO57 = 0; // Configure GPIO57 as I/O //  SPISTEA
    GpioCtrlRegs.GPBDIR.bit.GPIO57 = 1;		// set as out

    EDIS;
} 

void spi_init()				 // add in 0515
{    
//	Step 1. Clear the SPI SW RESET bit (SPICCR.7) to 0 to force the SPI to the reset state.
	SpiaRegs.SPICCR.bit.SPISWRESET = 0; 
//	Step 2. Initialize the SPI configuration, format, baud rate as desired.
	//format
	SpiaRegs.SPICCR.bit.SPILBK = 0;
	SpiaRegs.SPICCR.bit.SPICHAR = 0x7;
	SpiaRegs.SPICCR.bit.CLKPOLARITY = 1;
	//baud rate	
	SpiaRegs.SPIBRR =0x001D;					// BBR=29   baud = 30M/30 = 1M	

	SpiaRegs.SPICTL.all =0x0006;    		     // Enable master mode, normal phase,
                                                 // enable talk, and SPI int disabled.
 //   SpiaRegs.SPISTS.all=0x0000;
//Step 3. Set the SPI SW RESET bit to 1 to release the SPI from the reset state.	
    SpiaRegs.SPICCR.bit.SPISWRESET = 1;
    
 //   SpiaRegs.SPIPRI.bit.FREE = 1;                // Set so breakpoints don't disturb xmission
    
}

void spi_fifo_init()										
{
// Initialize SPI FIFO registers
    SpiaRegs.SPIFFTX.all=0xE040;
    SpiaRegs.SPIFFRX.all=0x204f;
    SpiaRegs.SPIFFCT.all=0x0;
}  



void EPWM1Init(void)
{
// Setup TBCLK
	EPwm1Regs.TBPRD		= 1200;					   // Set timer period
	EPwm1Regs.TBPHS.half.TBPHS = 0x0000;           // Phase is 0
	EPwm1Regs.TBCTR = 0x0000;                      // Clear counter
	
// Set Compare values
   EPwm1Regs.CMPA.half.CMPA = 600;     // Set compare A value
   //EPwm1Regs.CMPB = EPWM1_MAX_CMPB;               // Set Compare B value	
		
// Setup counter mode
   EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN; // Count up
   EPwm1Regs.TBCTL.bit.PHSEN = TB_DISABLE;        // Disable phase loading
   EPwm1Regs.TBCTL.bit.HSPCLKDIV = 0;       // Clock ratio to SYSCLKOUT
   EPwm1Regs.TBCTL.bit.CLKDIV = 0;
   
// Setup shadowing
	EPwm1Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
	EPwm1Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
	EPwm1Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;  // Load on Zero
	EPwm1Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;   

// Set actions
	EPwm1Regs.AQCTLA.bit.CAU = 1;             // Set PWM1A on event A, up count
	EPwm1Regs.AQCTLA.bit.CAD = 2;           // Clear PWM1A on event A, down count
   
	EPwm1Regs.AQCTLB.bit.CBU = 2;          // Set PWM1B on event A, down count
	EPwm1Regs.AQCTLB.bit.CBD = 1;			 // Set PWM1B on event A, up count
   
      // Active Low PWMs - Setup Deadband
	EPwm1Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
   	EPwm1Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
	EPwm1Regs.DBCTL.bit.IN_MODE = DBA_ALL;
	EPwm1Regs.DBRED = 120;
	EPwm1Regs.DBFED = 120;

   
	EPwm1Regs.ETSEL.bit.INTSEL = ET_CTR_PRD;     // Select INT on Period event
	EPwm1Regs.ETSEL.bit.INTEN = 1;  // Enable INT
	EPwm1Regs.ETPS.bit.INTPRD = ET_1ST;   
   
}

void EPWM2Init(void)
{
// Setup TBCLK
	EPwm2Regs.TBPRD		= 1200;					   // Set timer period
	EPwm2Regs.TBPHS.half.TBPHS = 0x0000;           // Phase is 0
	EPwm2Regs.TBCTR = 0x0000;                      // Clear counter
	
// Set Compare values
   EPwm2Regs.CMPA.half.CMPA = 600;     // Set compare A value
   //EPwm1Regs.CMPB = EPWM1_MAX_CMPB;               // Set Compare B value	
		
// Setup counter mode
   EPwm2Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN; // Count up
   EPwm2Regs.TBCTL.bit.PHSEN = TB_DISABLE;        // Disable phase loading
   EPwm2Regs.TBCTL.bit.HSPCLKDIV = 0;       // Clock ratio to SYSCLKOUT
   EPwm2Regs.TBCTL.bit.CLKDIV = 0;
   
// Setup shadowing
	EPwm2Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
	EPwm2Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
	EPwm2Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;  // Load on Zero
	EPwm2Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;   

// Set actions
	EPwm2Regs.AQCTLA.bit.CAU = 1;             // Set PWM1A on event A, up count
	EPwm2Regs.AQCTLA.bit.CAD = 2;           // Clear PWM1A on event A, down count
   
	EPwm2Regs.AQCTLB.bit.CBU = 2;          // Set PWM1B on event A, down count
	EPwm2Regs.AQCTLB.bit.CBD = 1;			 // Set PWM1B on event A, up count
   
      // Active Low PWMs - Setup Deadband
	EPwm2Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
   	EPwm2Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
	EPwm2Regs.DBCTL.bit.IN_MODE = DBA_ALL;
	EPwm2Regs.DBRED = 120;
	EPwm2Regs.DBFED = 120;
   
}

void EPWM3Init(void)
{
// Setup TBCLK
	EPwm3Regs.TBPRD		= 1200;					   // Set timer period
	EPwm3Regs.TBPHS.half.TBPHS = 0x0000;           // Phase is 0
	EPwm3Regs.TBCTR = 0x0000;                      // Clear counter
	
// Set Compare values
   EPwm3Regs.CMPA.half.CMPA = 600;     // Set compare A value
   //EPwm3Regs.CMPB = EPWM1_MAX_CMPB;               // Set Compare B value	
		
// Setup counter mode
   EPwm3Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN; // Count up
   EPwm3Regs.TBCTL.bit.PHSEN = TB_DISABLE;        // Disable phase loading
   EPwm3Regs.TBCTL.bit.HSPCLKDIV = 0;       // Clock ratio to SYSCLKOUT
   EPwm3Regs.TBCTL.bit.CLKDIV = 0;

// Setup shadowing
   EPwm3Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
   EPwm3Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
   EPwm3Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;  // Load on Zero
   EPwm3Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;   

// Set actions
	EPwm3Regs.AQCTLA.bit.CAU = 1;             // Set PWM3A on event A, up count
	EPwm3Regs.AQCTLA.bit.CAD = 2;           // Clear PWM3A on event A, down count
   	EPwm3Regs.AQCTLB.bit.CBU = 2;          // Set PWM3B on event A, down count
	EPwm3Regs.AQCTLB.bit.CBD = 1;			 // Set PWM3B on event A, up count
   
// Active Low PWMs - Setup Deadband
	EPwm3Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
   	EPwm3Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
	EPwm3Regs.DBCTL.bit.IN_MODE = DBA_ALL;
	EPwm3Regs.DBRED = 120;
	EPwm3Regs.DBFED = 120;

}

void ADCInit(void)
{
	EALLOW;
	SysCtrlRegs.HISPCP.all = ADC_MODCLK;	// HSPCLK = SYSCLKOUT/ADC_MODCLK
	EDIS;
	
	EALLOW;
	GpioCtrlRegs.GPAPUD.bit.GPIO13 = 0;   	// Enable pullup on GPIO13
    GpioCtrlRegs.GPAMUX1.bit.GPIO13 = 0;  	// GPIO13 = GPIO13
    GpioCtrlRegs.GPADIR.bit.GPIO13 = 1;  	// GPIO13 = output    ADC_R
   	GpioDataRegs.GPASET.bit.GPIO13 = 1;		// ENABLE AD
//	GpioDataRegs.GPACLEAR.bit.GPIO13 = 1;	// DISABLE AD
	EDIS;
	
	InitAdc();
	
	AdcRegs.ADCTRL1.bit.ACQ_PS = ADC_SHCLK;
	AdcRegs.ADCTRL3.bit.ADCCLKPS = ADC_CKPS;
	AdcRegs.ADCTRL1.bit.CPS = 0;
	AdcRegs.ADCTRL1.bit.SEQ_CASC = 0;        // 1  Cascaded mode
   

    AdcRegs.ADCCHSELSEQ1.bit.CONV00 = 0x0;	//A0
//	AdcRegs.ADCCHSELSEQ1.bit.CONV01 = 0x0;
//	AdcRegs.ADCCHSELSEQ1.bit.CONV02 = 0x0;
//	AdcRegs.ADCCHSELSEQ1.bit.CONV03 = 0x0;
	AdcRegs.ADCCHSELSEQ1.bit.CONV01 = 0x1;	//A1
//	AdcRegs.ADCCHSELSEQ2.bit.CONV05 = 0x1;
//	AdcRegs.ADCCHSELSEQ2.bit.CONV06 = 0x1;
//	AdcRegs.ADCCHSELSEQ2.bit.CONV07 = 0x1;
	
	AdcRegs.ADCMAXCONV.bit.MAX_CONV1 = 0x1;


}

void POSSPEED_Init(void)
{


	EQep1Regs.QDECCTL.bit.QSRC=00;
	
	EQep1Regs.QEPCTL.bit.FREE_SOFT=2;
	EQep1Regs.QEPCTL.bit.PCRM=0;
//	EQep1Regs.QEPCTL.bit.UTE=1;
//	EQep1Regs.QEPCTL.bit.QCLM=1;
	EQep1Regs.QPOSMAX=0x1F40;
	EQep1Regs.QEPCTL.bit.QPEN=1;
//	EQep1Regs.QPOSINIT=0;
//	EQep1Regs.QEPCTL.bit.IEI=2;
	
//	EQep1Regs.QCAPCTL.bit.UPPS=5;
//	EQep1Regs.QCAPCTL.bit.CCPS=7;
//	EQep1Regs.QCAPCTL.bit.CEN=1;
	
}



