
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

LIB=libabsl_int128.a
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
    $(OBJDIR)/int128.o 

$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building $@"
	@$(CXX) -c $(DEFAULT_COPTS) $(INCLUDES) -o $@ $<

$(LIBDIR)/$(LIB): $(OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(OBJS)
