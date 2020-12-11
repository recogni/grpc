
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

OBJDIR := $(CROSS_OBJ)/absl_base
LIBDIR := $(CROSS_LIB)

# Comes from .../grpc/third_party/abseil-cpp/absl/base/CMakeList.txt

#COPTS comes from third_party/abseil-cpp/absl/copts/GENERATED...
ABSL_GCC_FLAGS=\
-Wall \
-Wextra \
-Wcast-qual \
-Wconversion-null \
-Wmissing-declarations \
-Woverlength-strings \
-Wpointer-arith \
-Wunused-local-typedefs \
-Wunused-result \
-Wvarargs \
-Wvla \
-Wwrite-strings \
-Wno-missing-field-initializers \
-Wno-sign-compare 

ABSL_DEFAULT_COPTS= $(SCORPIO_DEFINES) $(ABSL_GCC_FLAGS) -DABSL_FORCE_THREAD_IDENTITY_MODE=2
ABSL_INCLUDES = -I$(GRPC_ROOT)/third_party/abseil-cpp $(SCORPIO_INCLUDES)

all: $(LIBDIR)/libabsl_base.a

clean:
	rm  -rf $(OBJDIR) $(LIBDIR)/libabsl_base.a

BASE_OBJS=\
    $(OBJDIR)/internal/cycleclock.o \
    $(OBJDIR)/internal/spinlock.o \
    $(OBJDIR)/internal/sysinfo.o \
    $(OBJDIR)/internal/thread_identity.o \
    $(OBJDIR)/internal/unscaledcycleclock.o 

$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building Base $@"
	@$(CXX) -c $(ABSL_DEFAULT_COPTS) $(ABSL_INCLUDES) $(C_FLAGS) -o $@ $<

$(LIBDIR)/libabsl_base.a: $(BASE_OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(BASE_OBJS)
#@$(AR) $(ARFLAGS) $(LIBDIR)/libabsl_base.a $(BASE_OBJS)

