
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

LIB=libabsl_time_zone.a
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
INCLUDES = -I$(GRPC_ROOT)/third_party/abseil-cpp $(SCORPIO_INCLUDES)

all: $(LIBDIR)/$(LIB)

clean:
	rm  -rf $(OBJDIR) $(LIBDIR)/$(LIB)

OBJS=\
    $(OBJDIR)/src/time_zone_fixed.o \
    $(OBJDIR)/src/time_zone_format.o \
    $(OBJDIR)/src/time_zone_if.o \
    $(OBJDIR)/src/time_zone_impl.o \
    $(OBJDIR)/src/time_zone_info.o \
    $(OBJDIR)/src/time_zone_libc.o \
    $(OBJDIR)/src/time_zone_lookup.o \
    $(OBJDIR)/src/time_zone_posix.o \
    $(OBJDIR)/src/zone_info_source.o \

WTF=$(OBJDIR)/src/time_zone_fixed.h \
    $(OBJDIR)/src/time_zone_if.h \
    $(OBJDIR)/src/time_zone_impl.h \
    $(OBJDIR)/src/time_zone_info.h \
    $(OBJDIR)/src/time_zone_libc.h \
    $(OBJDIR)/src/time_zone_posix.h \
    $(OBJDIR)/src/tzfile.h

$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building $@"
	@$(CXX) -c $(DEFAULT_COPTS) $(INCLUDES) -o $@ $<

$(LIBDIR)/$(LIB): $(OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(OBJS)
