#From examples/cpp/helloworld/cmake/riscv_build/CMakeFiles/greeter_server.dir/build.make
#Run from top level...

#
#Pick either riscv or x86
#
PROC = riscv
#PROC = x86

LIB = newlib
#
# Riscv settings
#
ifeq ($(PROC),riscv)

ROOT = /tmp/riscv_root
ROOT_BIN = $(ROOT)/riscv/bin

ifeq ($(LIB),newlib)
SYSROOT_PATH = $(ROOT)/riscv/riscv64-unknown-elf
SYSROOT = --sysroot=$(SYSROOT_PATH)
CROSS_LIB = $(ROOT)/stage/lib
CROSS_INC = $(ROOT)/stage/include
G++ = riscv64-unknown-elf-g++

else

SYSROOT_PATH = $(ROOT)/riscv/sysroot
SYSROOT = --sysroot=$(SYSROOT_PATH)
CROSS_LIB = $(ROOT)/stage/lib
CROSS_INC = $(ROOT)/stage/include
G++ = riscv64-unknown-linux-gnu-g++
endif

PROTOC = /usr/local/bin/protoc
CROSS_INC_PATH = -isystem $(CROSS_INC)

else
#
# x86 settings
#
ROOT = /tmp/native_build
ROOT_BIN = /usr/bin
CROSS_LIB = $(ROOT)/lib
G++ = c++
PROTOC = $(ROOT)/bin/protoc-3.13.0.0
X86lib = x86_64-linux-gnu
endif


TMP_ROOT := /tmp/server_app_$(PROC)
SRC := $(TMP_ROOT)/src
OUT := $(TMP_ROOT)/dest
POUT := $(OUT)/proto

CXX_INCLUDES :=  -I$(POUT)  $(CROSS_INC_PATH)
CXX_FLAGS :=  -std=c++11 -O3 -DNDEBUG
CXX_DEFINES := -DCARES_STATICLIB -D__CLANG_SUPPORT_DYN_ANNOTATION__

LIBS :=  \
$(CROSS_LIB)/libgrpc++_reflection.a   \
$(CROSS_LIB)/libgrpc++_unsecure.a   \
$(CROSS_LIB)/libprotobuf.a   \
$(CROSS_LIB)/libprotobuf-lite.a  \
$(CROSS_LIB)/libgrpc_unsecure.a  \
$(CROSS_LIB)/libz.a  \
$(CROSS_LIB)/libcares.a \
$(CROSS_LIB)/libre2.a  \
$(CROSS_LIB)/libabsl_status.a  \
$(CROSS_LIB)/libabsl_bad_optional_access.a  \
$(CROSS_LIB)/libabsl_cord.a  \
$(CROSS_LIB)/libgpr.a  \
$(CROSS_LIB)/libabsl_synchronization.a  \
$(CROSS_LIB)/libabsl_stacktrace.a  \
$(CROSS_LIB)/libabsl_symbolize.a  \
$(CROSS_LIB)/libabsl_debugging_internal.a  \
$(CROSS_LIB)/libabsl_demangle_internal.a  \
$(CROSS_LIB)/libabsl_graphcycles_internal.a  \
$(CROSS_LIB)/libabsl_time.a  \
$(CROSS_LIB)/libabsl_civil_time.a  \
$(CROSS_LIB)/libabsl_time_zone.a  \
$(CROSS_LIB)/libabsl_malloc_internal.a  \
$(CROSS_LIB)/libabsl_str_format_internal.a  \
$(CROSS_LIB)/libabsl_strings.a  \
$(CROSS_LIB)/libabsl_strings_internal.a  \
$(CROSS_LIB)/libabsl_int128.a  \
$(CROSS_LIB)/libabsl_throw_delegate.a  \
$(CROSS_LIB)/libabsl_base.a  \
$(CROSS_LIB)/libabsl_raw_logging_internal.a  \
$(CROSS_LIB)/libabsl_dynamic_annotations.a  \
$(CROSS_LIB)/libabsl_log_severity.a  \
$(CROSS_LIB)/libabsl_spinlock_wait.a  \
$(CROSS_LIB)/libaddress_sorting.a  \
$(CROSS_LIB)/libupb.a \
-lpthread


#Build server and async_server
all: clean prep examples/protos/helloworld.proto
	@echo Compling server app protobufs
	$(PROTOC) --grpc_out $(POUT) --cpp_out $(POUT) -I $(SRC) --plugin=protoc-gen-grpc="/usr/local/bin/grpc_cpp_plugin" $(SRC)/helloworld.proto
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o $(OUT)/helloworld.pb.cc.o -c $(POUT)/helloworld.pb.cc
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o $(OUT)/helloworld.grpc.pb.cc.o -c $(POUT)/helloworld.grpc.pb.cc

	@echo Build server
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o $(OUT)/greeter_server.cc.o -c $(SRC)/greeter_server.cc
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_FLAGS)  $(OUT)/greeter_server.cc.o $(OUT)/helloworld.pb.cc.o $(OUT)/helloworld.grpc.pb.cc.o  -o $(OUT)/greeter_server  $(LIBS)

	@echo Build async_server
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o $(OUT)/greeter_async_server.cc.o -c $(SRC)/greeter_async_server.cc
	$(ROOT_BIN)/$(G++) $(SYSROOT) $(CXX_FLAGS)  $(OUT)/greeter_async_server.cc.o $(OUT)/helloworld.pb.cc.o $(OUT)/helloworld.grpc.pb.cc.o  -o $(OUT)/greeter_async_server  $(LIBS)
	@echo server app executable: $(OUT)/greeter_server

.PHONY: clean
clean:
	@echo Cleaning up server app in  $(TMP_ROOT)
	@rm -rf $(TMP_ROOT)

.PHONY: prep
prep:
	@echo Create seerver app dirs, copy source
	@mkdir -p $(OUT)
	@mkdir -p $(POUT)
	@mkdir -p $(SRC)
	@cp examples/protos/helloworld.proto $(SRC)
	@cp examples/cpp/helloworld/greeter_server.cc $(SRC)
	@cp examples/cpp/helloworld/greeter_async_server.cc $(SRC)

