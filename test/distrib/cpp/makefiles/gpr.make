
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

LIB=libgpr.a
OBJDIR := $(CROSS_OBJ)/$(basename $(LIB))
LIBDIR := $(CROSS_LIB)

#COPTS comes from third_party/abseil-cpp/absl/copts/GENERATED...
GCC_FLAGS=\
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

DEFAULT_COPTS= $(SCORPIO_DEFINES) $(GCC_FLAGS)
INCLUDES = -I$(GRPC_ROOT)/include $(SCORPIO_INCLUDES) -I$(GRPC_ROOT) -I$(GRPC_ROOT)/third_party/abseil-cpp

all: $(LIBDIR)/$(LIB)

clean:
	rm  -rf $(OBJDIR) $(LIBDIR)/$(LIB)

OBJS=\
  $(OBJDIR)/src/core/lib/gpr/alloc.o \
  $(OBJDIR)/src/core/lib/gpr/atm.o \
  $(OBJDIR)/src/core/lib/gpr/cpu_iphone.o \
  $(OBJDIR)/src/core/lib/gpr/cpu_linux.o \
  $(OBJDIR)/src/core/lib/gpr/cpu_posix.o \
  $(OBJDIR)/src/core/lib/gpr/cpu_windows.o \
  $(OBJDIR)/src/core/lib/gpr/env_linux.o \
  $(OBJDIR)/src/core/lib/gpr/env_posix.o \
  $(OBJDIR)/src/core/lib/gpr/env_windows.o \
  $(OBJDIR)/src/core/lib/gpr/log.o \
  $(OBJDIR)/src/core/lib/gpr/log_android.o \
  $(OBJDIR)/src/core/lib/gpr/log_linux.o \
  $(OBJDIR)/src/core/lib/gpr/log_posix.o \
  $(OBJDIR)/src/core/lib/gpr/log_windows.o \
  $(OBJDIR)/src/core/lib/gpr/murmur_hash.o \
  $(OBJDIR)/src/core/lib/gpr/string.o \
  $(OBJDIR)/src/core/lib/gpr/string_posix.o \
  $(OBJDIR)/src/core/lib/gpr/string_util_windows.o \
  $(OBJDIR)/src/core/lib/gpr/string_windows.o \
  $(OBJDIR)/src/core/lib/gpr/sync.o \
  $(OBJDIR)/src/core/lib/gpr/sync_abseil.o \
  $(OBJDIR)/src/core/lib/gpr/sync_posix.o \
  $(OBJDIR)/src/core/lib/gpr/sync_windows.o \
  $(OBJDIR)/src/core/lib/gpr/time.o \
  $(OBJDIR)/src/core/lib/gpr/time_posix.o \
  $(OBJDIR)/src/core/lib/gpr/time_precise.o \
  $(OBJDIR)/src/core/lib/gpr/time_windows.o \
  $(OBJDIR)/src/core/lib/gpr/tls_pthread.o \
  $(OBJDIR)/src/core/lib/gpr/tmpfile_msys.o \
  $(OBJDIR)/src/core/lib/gpr/tmpfile_posix.o \
  $(OBJDIR)/src/core/lib/gpr/tmpfile_windows.o \
  $(OBJDIR)/src/core/lib/gpr/wrap_memcpy.o \
  $(OBJDIR)/src/core/lib/gprpp/arena.o \
  $(OBJDIR)/src/core/lib/gprpp/fork.o \
  $(OBJDIR)/src/core/lib/gprpp/global_config_env.o \
  $(OBJDIR)/src/core/lib/gprpp/host_port.o \
  $(OBJDIR)/src/core/lib/gprpp/mpscq.o \
  $(OBJDIR)/src/core/lib/gprpp/thd_posix.o \
  $(OBJDIR)/src/core/lib/gprpp/thd_windows.o \
  $(OBJDIR)/src/core/lib/profiling/basic_timers.o \
  $(OBJDIR)/src/core/lib/profiling/stap_timers.o


$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building $@"
	@$(CXX) -c $(DEFAULT_COPTS) $(INCLUDES) -o $@ $<

$(LIBDIR)/$(LIB): $(OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(OBJS)
