;// TI File $Revision: /main/1 $
;// Checkin $Date: August 18, 2006   13:46:03 $
;//###########################################################################
;//
;// FILE:  DSP2833x_DBGIER.asm
;//
;// TITLE: Set the DBGIER register
;//
;// DESCRIPTION:
;//  
;//  Function to set the DBGIER register (for realtime emulation).
;//  Function Prototype: void SetDBGIER(Uint16)
;//  Useage: SetDBGIER(value);
;//  Input Parameters: Uint16 value = value to put in DBGIER register. 
;//  Return Value: none          
;//
;//###########################################################################
;// $TI Release: DSP2833x/DSP2823x Header Files V1.20 $
;// $Release Date: August 1, 2008 $
;//###########################################################################	
		.global _SetDBGIER
		.text
		
_SetDBGIER:
		MOV 	*SP++,AL
		POP 	DBGIER
		LRETR
		
