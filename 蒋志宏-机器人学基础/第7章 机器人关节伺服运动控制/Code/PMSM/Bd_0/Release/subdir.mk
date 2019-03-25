################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../DSP2833x_Adc.c \
../DSP2833x_CpuTimers.c \
../DSP2833x_DefaultIsr.c \
../DSP2833x_ECan.c \
../DSP2833x_EPwm.c \
../DSP2833x_EQep.c \
../DSP2833x_GlobalVariableDefs.c \
../DSP2833x_Gpio.c \
../DSP2833x_PieCtrl.c \
../DSP2833x_PieVect.c \
../DSP2833x_SysCtrl.c \
../DSP2833x_Xintf.c \
../User_Init.c \
../User_PID.c \
../User_Program.c \
../main.c 

ASM_SRCS += \
../DSP2833x_ADC_cal.asm \
../DSP2833x_CodeStartBranch.asm \
../DSP2833x_usDelay.asm 

CMD_SRCS += \
../DSP2833x_Headers_nonBIOS.cmd \
../F28335.cmd 

ASM_DEPS += \
./DSP2833x_ADC_cal.pp \
./DSP2833x_CodeStartBranch.pp \
./DSP2833x_usDelay.pp 

OBJS += \
./DSP2833x_ADC_cal.obj \
./DSP2833x_Adc.obj \
./DSP2833x_CodeStartBranch.obj \
./DSP2833x_CpuTimers.obj \
./DSP2833x_DefaultIsr.obj \
./DSP2833x_ECan.obj \
./DSP2833x_EPwm.obj \
./DSP2833x_EQep.obj \
./DSP2833x_GlobalVariableDefs.obj \
./DSP2833x_Gpio.obj \
./DSP2833x_PieCtrl.obj \
./DSP2833x_PieVect.obj \
./DSP2833x_SysCtrl.obj \
./DSP2833x_Xintf.obj \
./DSP2833x_usDelay.obj \
./User_Init.obj \
./User_PID.obj \
./User_Program.obj \
./main.obj 

C_DEPS += \
./DSP2833x_Adc.pp \
./DSP2833x_CpuTimers.pp \
./DSP2833x_DefaultIsr.pp \
./DSP2833x_ECan.pp \
./DSP2833x_EPwm.pp \
./DSP2833x_EQep.pp \
./DSP2833x_GlobalVariableDefs.pp \
./DSP2833x_Gpio.pp \
./DSP2833x_PieCtrl.pp \
./DSP2833x_PieVect.pp \
./DSP2833x_SysCtrl.pp \
./DSP2833x_Xintf.pp \
./User_Init.pp \
./User_PID.pp \
./User_Program.pp \
./main.pp 

OBJS__QTD += \
".\DSP2833x_ADC_cal.obj" \
".\DSP2833x_Adc.obj" \
".\DSP2833x_CodeStartBranch.obj" \
".\DSP2833x_CpuTimers.obj" \
".\DSP2833x_DefaultIsr.obj" \
".\DSP2833x_ECan.obj" \
".\DSP2833x_EPwm.obj" \
".\DSP2833x_EQep.obj" \
".\DSP2833x_GlobalVariableDefs.obj" \
".\DSP2833x_Gpio.obj" \
".\DSP2833x_PieCtrl.obj" \
".\DSP2833x_PieVect.obj" \
".\DSP2833x_SysCtrl.obj" \
".\DSP2833x_Xintf.obj" \
".\DSP2833x_usDelay.obj" \
".\User_Init.obj" \
".\User_PID.obj" \
".\User_Program.obj" \
".\main.obj" 

ASM_DEPS__QTD += \
".\DSP2833x_ADC_cal.pp" \
".\DSP2833x_CodeStartBranch.pp" \
".\DSP2833x_usDelay.pp" 

C_DEPS__QTD += \
".\DSP2833x_Adc.pp" \
".\DSP2833x_CpuTimers.pp" \
".\DSP2833x_DefaultIsr.pp" \
".\DSP2833x_ECan.pp" \
".\DSP2833x_EPwm.pp" \
".\DSP2833x_EQep.pp" \
".\DSP2833x_GlobalVariableDefs.pp" \
".\DSP2833x_Gpio.pp" \
".\DSP2833x_PieCtrl.pp" \
".\DSP2833x_PieVect.pp" \
".\DSP2833x_SysCtrl.pp" \
".\DSP2833x_Xintf.pp" \
".\User_Init.pp" \
".\User_PID.pp" \
".\User_Program.pp" \
".\main.pp" 

ASM_SRCS_QUOTED += \
"../DSP2833x_ADC_cal.asm" \
"../DSP2833x_CodeStartBranch.asm" \
"../DSP2833x_usDelay.asm" 

C_SRCS_QUOTED += \
"../DSP2833x_Adc.c" \
"../DSP2833x_CpuTimers.c" \
"../DSP2833x_DefaultIsr.c" \
"../DSP2833x_ECan.c" \
"../DSP2833x_EPwm.c" \
"../DSP2833x_EQep.c" \
"../DSP2833x_GlobalVariableDefs.c" \
"../DSP2833x_Gpio.c" \
"../DSP2833x_PieCtrl.c" \
"../DSP2833x_PieVect.c" \
"../DSP2833x_SysCtrl.c" \
"../DSP2833x_Xintf.c" \
"../User_Init.c" \
"../User_PID.c" \
"../User_Program.c" \
"../main.c" 


# Each subdirectory must supply rules for building sources it contributes
DSP2833x_ADC_cal.obj: ../DSP2833x_ADC_cal.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_ADC_cal.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_Adc.obj: ../DSP2833x_Adc.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_Adc.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_CodeStartBranch.obj: ../DSP2833x_CodeStartBranch.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_CodeStartBranch.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_CpuTimers.obj: ../DSP2833x_CpuTimers.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_CpuTimers.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_DefaultIsr.obj: ../DSP2833x_DefaultIsr.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_DefaultIsr.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_ECan.obj: ../DSP2833x_ECan.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_ECan.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_EPwm.obj: ../DSP2833x_EPwm.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_EPwm.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_EQep.obj: ../DSP2833x_EQep.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_EQep.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_GlobalVariableDefs.obj: ../DSP2833x_GlobalVariableDefs.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_GlobalVariableDefs.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_Gpio.obj: ../DSP2833x_Gpio.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_Gpio.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_PieCtrl.obj: ../DSP2833x_PieCtrl.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_PieCtrl.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_PieVect.obj: ../DSP2833x_PieVect.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_PieVect.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_SysCtrl.obj: ../DSP2833x_SysCtrl.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_SysCtrl.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_Xintf.obj: ../DSP2833x_Xintf.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_Xintf.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

DSP2833x_usDelay.obj: ../DSP2833x_usDelay.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="DSP2833x_usDelay.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

User_Init.obj: ../User_Init.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="User_Init.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

User_PID.obj: ../User_PID.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="User_PID.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

User_Program.obj: ../User_Program.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="User_Program.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '

main.obj: ../main.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: Compiler'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g -O2 --include_path="D:/ccs/ccsv4/tools/compiler/c2000/include" --include_path="D:/Program Files (x86)/Texas Instruments/xdais_7_10_00_06/packages/ti/xdais" --include_path="E:/workspace/workspace_501_1212/DSP2833x_common/include" --include_path="E:/workspace/workspace_501_1212/DSP2833x_headers/include" --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 --preproc_with_compile --preproc_dependency="main.pp" $(GEN_OPTS_QUOTED) $(subst #,$(wildcard $(subst $(SPACE),\$(SPACE),$<)),"#")
	@echo 'Finished building: $<'
	@echo ' '


