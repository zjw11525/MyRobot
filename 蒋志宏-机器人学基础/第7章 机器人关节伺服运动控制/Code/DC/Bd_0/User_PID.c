#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "math.h"  

/******************************************************************************************/
//位置环PID
/******************************************************************************************/

float pKP = 0.04;// PID参数
float pKI = 0.03;
float pKD = 0.00001;
float pREF = 0.0;//位置期望
float pFB = 0.0;//位置反馈
float pERR = 0.0;//位置误差
float pERR1 = 0.0;
float pERR2 = 0.0;
float pOUT = 0.0;
float pOUT_LAST = 0.0;
float pOUT_UP_LIM = 20.0;//位置输出限幅
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
//速度环 PID 控制.速度环PID
/******************************************************************************************/

float sKP = 0.0002;//PID参数
float sKI = 0.02;
float sKD = 0.0;
float sREF = 0.0;//速度期望
float sFB = 0.0;//速度反馈
float sERR = 0.0;//速度误差
float sERR1 = 0.0;
float sERR2 = 0.0;
float sOUT = 0.0;
float spOUT=0.0;
float sOUT_LAST = 0.0;
float sOUT_UP_LIM = 10;//输出限幅
float sOUT_DOWN_LIM = -10;
extern int SP;//占空比

float sCONTROLLER(void)
{

	sERR = sREF - sFB;
	sOUT = sOUT_LAST + ((sKP * (sERR - sERR1)) + (sKI * sERR) + (sKD * (sERR - 2 * sERR1 + sERR2)));

	if ( sOUT > sOUT_UP_LIM )         sOUT = sOUT_UP_LIM;
	else if ( sOUT < sOUT_DOWN_LIM )  sOUT = sOUT_DOWN_LIM;
	
	sERR2 = sERR1;
	sERR1 = sERR;
	
	sOUT_LAST = sOUT;

	return sOUT;
	
}



/******************************************************************************************/
//电流环 PID 控制.
/******************************************************************************************/

float iKP = 0.05;//PID参数
float iKI = 0.01;
float iKD = 0.0001;

float iERR = 0.0;//电流误差
float iERR1 = 0.0;
float iERR2 = 0.0;
float iOUT;

float iOUT_LAST = 0.0;
float iOUT_UP_LIM = 1.0;//电流输出限幅
float iOUT_DOWN_LIM = -1.0;
int SP_set=0;//占空比
float iCONTROLLER(float i_REF,float i_FB)
{

	
	iERR = i_REF - i_FB;

	iOUT = iOUT_LAST + ((iKP * (iERR - iERR1)) + (iKI * iERR) + (iKD * (iERR - 2 * iERR1 + iERR2)));

	if ( iOUT > iOUT_UP_LIM )        iOUT = iOUT_UP_LIM;
	else if ( iOUT < iOUT_DOWN_LIM )  iOUT = iOUT_DOWN_LIM;

	iERR1 = iERR;
	iERR2 = iERR1;
	iOUT_LAST = iOUT;
	SP_set = 600 + (int)(iOUT*100);
	return SP_set;

}

