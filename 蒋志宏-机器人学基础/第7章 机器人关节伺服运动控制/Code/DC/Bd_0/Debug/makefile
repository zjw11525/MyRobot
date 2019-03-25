################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

EMPTY := 
SPACE := $(EMPTY) $(EMPTY)

ORDERED_OBJS += \
$(GEN_CMDS_QUOTED) \
"./main.obj" \
"./User_Program.obj" \
"./User_PID.obj" \
"./User_Init.obj" \
"./DSP2833x_usDelay.obj" \
"./DSP2833x_Xintf.obj" \
"./DSP2833x_SysCtrl.obj" \
"./DSP2833x_PieVect.obj" \
"./DSP2833x_PieCtrl.obj" \
"./DSP2833x_Gpio.obj" \
"./DSP2833x_GlobalVariableDefs.obj" \
"./DSP2833x_EQep.obj" \
"./DSP2833x_EPwm.obj" \
"./DSP2833x_ECan.obj" \
"./DSP2833x_DefaultIsr.obj" \
"./DSP2833x_CpuTimers.obj" \
"./DSP2833x_CodeStartBranch.obj" \
"./DSP2833x_Adc.obj" \
"./DSP2833x_ADC_cal.obj" \
-l"rts2800_fpu32.lib" \
"../28335_RAM_lnk.cmd" \
"../DSP2833x_Headers_nonBIOS.cmd" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: Bd_0.out

# Tool invocations
Bd_0.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: $@'
	@echo 'Invoking: Linker'
	"D:/ccs/ccsv4/tools/compiler/c2000/bin/cl2000" --silicon_version=28 -g --diag_warning=225 --large_memory_model --unified_memory --float_support=fpu32 -z -m"Bd_0.map" --stack_size=0x300 --warn_sections -i"D:/ccs/ccsv4/tools/compiler/c2000/lib" -i"D:/ccs/ccsv4/tools/compiler/c2000/include" --reread_libs --rom_model -o "Bd_0.out" $(ORDERED_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(C2000_EXECUTABLE_OUTPUTS__QTD) "Bd_0.out"
	-$(RM) ".\DSP2833x_ADC_cal.obj" ".\DSP2833x_Adc.obj" ".\DSP2833x_CodeStartBranch.obj" ".\DSP2833x_CpuTimers.obj" ".\DSP2833x_DefaultIsr.obj" ".\DSP2833x_ECan.obj" ".\DSP2833x_EPwm.obj" ".\DSP2833x_EQep.obj" ".\DSP2833x_GlobalVariableDefs.obj" ".\DSP2833x_Gpio.obj" ".\DSP2833x_PieCtrl.obj" ".\DSP2833x_PieVect.obj" ".\DSP2833x_SysCtrl.obj" ".\DSP2833x_Xintf.obj" ".\DSP2833x_usDelay.obj" ".\User_Init.obj" ".\User_PID.obj" ".\User_Program.obj" ".\main.obj" 
	-$(RM) ".\DSP2833x_ADC_cal.pp" ".\DSP2833x_CodeStartBranch.pp" ".\DSP2833x_usDelay.pp" 
	-$(RM) ".\DSP2833x_Adc.pp" ".\DSP2833x_CpuTimers.pp" ".\DSP2833x_DefaultIsr.pp" ".\DSP2833x_ECan.pp" ".\DSP2833x_EPwm.pp" ".\DSP2833x_EQep.pp" ".\DSP2833x_GlobalVariableDefs.pp" ".\DSP2833x_Gpio.pp" ".\DSP2833x_PieCtrl.pp" ".\DSP2833x_PieVect.pp" ".\DSP2833x_SysCtrl.pp" ".\DSP2833x_Xintf.pp" ".\User_Init.pp" ".\User_PID.pp" ".\User_Program.pp" ".\main.pp" 
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
