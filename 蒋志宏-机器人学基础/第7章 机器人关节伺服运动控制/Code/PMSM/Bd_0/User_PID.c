#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "math.h"  

/******************************************************************************************/
//Position PID Controller Here.位置环PID
/******************************************************************************************/

float pKP = 0.5;// PID参数
float pKI = 0.01;
float pKD = 0.00001;
float pREF = 0.0;//位置期望
float pFB = 0.0;//位置反馈
float pERR = 0.0;//位置误差
float pERR1 = 0.0;
float pERR2 = 0.0;
float pOUT = 0.0;
float pOUT_LAST = 0.0;
float pOUT_UP_LIM = 20.0;//位置环输出限幅
float pOUT_DOWN_LIM = -20.0;

float pCONTROLLER(void)
{
	while(pREF > 360.0)	{pREF -= 360.0;}
	while(pREF < 0.0)	{pREF += 360.0;}
	pERR = pREF - pFB;

	pOUT = pOUT_LAST + ((pKP * (pERR - pERR1)) + (pKI * pERR) + (pKD * (pERR - 2 * pERR1 + pERR2)));
	
	if ( pOUT > pOUT_UP_LIM )         pOUT = pOUT_UP_LIM;
	else if ( pOUT < pOUT_DOWN_LIM )  pOUT = pOUT_DOWN_LIM;
	
	pERR2 = pERR1;
	pERR1 = pERR;
	
	pOUT_LAST = pOUT;
	
	return pOUT;
}


/******************************************************************************************/
//Speed PID Controller Here.速度环PID
/******************************************************************************************/
float sKP = 0.01;//PID参数
float sKI = 0.001;
float sKD = 0.0;
float sREF = 0.0;//速度期望
float sFB = 0.0;//速度反馈
float sERR = 0.0;//速度误差
float sERR1 = 0.0;
float sERR2 = 0.0;
float sOUT = 0.0;
float spOUT=0.0;
float sOUT_LAST = 0.0;
float sOUT_UP_LIM = 5;//速度环PID输出限幅
float sOUT_DOWN_LIM = -5;
float sREF_LAST = 0.0;

float sCONTROLLER(void)
{

	sERR = sREF - sFB;
	sOUT = sOUT_LAST + ((sKP * (sERR - sERR1)) + (sKI * sERR) + (sKD * (sERR - 2 * sERR1 + sERR2)));
	
	if ( sOUT > sOUT_UP_LIM )         sOUT = sOUT_UP_LIM;
	else if ( sOUT < sOUT_DOWN_LIM )  sOUT = sOUT_DOWN_LIM;
	
	sERR2 = sERR1;
	sERR1 = sERR;
	
	sOUT_LAST = sOUT;
	sREF_LAST = sREF;

	return sOUT;
}

float current_limit = 24.0;
/******************************************************************************************/
//d axis Current PID Controller Here.d轴电流PID控制
/******************************************************************************************/
float iKP_d = 0.2;//PID参数
float iKI_d = 0.01;
float iKD_d = 0.0001;

float iERR_d = 0.0;//误差
float iERR1_d = 0.0;
float iERR2_d = 0.0;
float iOUT_d = 0.0;
float iOUT_df=0.0;
float iOUT_LAST_d = 0.0;
float iOUT_UP_LIM_d = 2.0;//电流环PID输出限幅
float iOUT_DOWN_LIM_d = -2.0;

float iCONTROLLER_d(float iREF,float iFB)
{

	iERR_d = iREF - iFB;
	
	iOUT_d = iOUT_LAST_d + ((iKP_d * (iERR_d - iERR1_d)) + (iKI_d * iERR_d) + (iKD_d * (iERR_d - 2 * iERR1_d + iERR2_d)));

	if ( iOUT_d > iOUT_UP_LIM_d )         iOUT_d = iOUT_UP_LIM_d;
	else if ( iOUT_d < iOUT_DOWN_LIM_d )  iOUT_d = iOUT_DOWN_LIM_d;
	
	iERR2_d = iERR1_d;
	iERR1_d = iERR_d;
	
	iOUT_LAST_d = iOUT_d;
	iOUT_df=-iOUT_d;
	return iOUT_df;
}


/******************************************************************************************/
//q axis Current PID Controller Here.q轴电流环PID
/******************************************************************************************/
float iKP_q = 0.2;//PID参数
float iKI_q = 0.01;
float iKD_q = 0.0001;

float iERR_q = 0.0;//误差
float iERR1_q = 0.0;
float iERR2_q = 0.0;
float iOUT_q;
float iOUT_qf;
float iOUT_LAST_q = 0.0;
float iOUT_UP_LIM_q = 3.0;//电流环PID输出限幅
float iOUT_DOWN_LIM_q = -3.0;

float iCONTROLLER_q(float iREF,float iFB)
{
	
	iERR_q = iREF - iFB;

	iOUT_q = iOUT_LAST_q + ((iKP_q * (iERR_q - iERR1_q)) + (iKI_q * iERR_q) + (iKD_q * (iERR_q - 2 * iERR1_q + iERR2_q)));

	if ( iOUT_q > iOUT_UP_LIM_q )        iOUT_q = iOUT_UP_LIM_q;
	else if ( iOUT_q < iOUT_DOWN_LIM_q )  iOUT_q = iOUT_DOWN_LIM_q;

	iERR1_q = iERR_q;
	iERR2_q = iERR1_q;
	iOUT_LAST_q = iOUT_q;

	return iOUT_q;
	
}

