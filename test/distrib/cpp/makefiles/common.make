PROC = riscv

ifeq ($(PROC),riscv)
SCORPIO_DEFINES := -DSCORPIO 
ROOT := /tmp/riscv_root
BIN := $(ROOT)/riscv/bin
else
ROOT = /tmp/x86_root
endif

GCC := $(BIN)/riscv64-unknown-elf-gcc
CXX := $(BIN)/riscv64-unknown-elf-g++
AR  := $(BIN)/riscv64-unknown-elf-ar
NM  := $(BIN)/riscv64-unknown-elf-nm
RANLIB  := $(BIN)/riscv64-unknown-elf-ranlib

ARFLAGS=rsc

CROSS_LIB = $(ROOT)/stage/lib
CROSS_OBJ = $(ROOT)/stage/obj

SCORPIO := /home/brett/scorp_oct19_libs/scorpio-fw
GRPC_ROOT := /home/brett/grpc_oct15/grpc/



SCORPIO_INCLUDES := \
-I$(SCORPIO)/modules/FreeRTOS-Kernel/include \
-I$(SCORPIO)/modules/FreeRTOS-Kernel/portable/GCC/RISC-V \
-I$(SCORPIO)/src/scpu \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include/portable \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include/portable/recogni \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/include/FreeRTOS_POSIX \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/include \
-I$(SCORPIO)/modules/Lab-Project-FreeRTOS-POSIX/include/private \
-I$(SCORPIO)/modules/FreeRTOS-Plus-TCP/include \
-I$(SCORPIO)/modules/FreeRTOS-Plus-TCP/portable/Compiler/GCC \
-I$(SCORPIO)/src/scpu/hal \
-I$(SCORPIO)/src/scpu/include \
-I$(SCORPIO)/src/common/include


