
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

LIB=libabsl_strings.a
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
    $(OBJDIR)/ascii.o \
    $(OBJDIR)/charconv.o \
    $(OBJDIR)/escaping.o \
    $(OBJDIR)/internal/charconv_bigint.o \
    $(OBJDIR)/internal/charconv_parse.o \
    $(OBJDIR)/internal/memutil.o \
    $(OBJDIR)/match.o \
    $(OBJDIR)/numbers.o \
    $(OBJDIR)/str_cat.o \
    $(OBJDIR)/str_replace.o \
    $(OBJDIR)/str_split.o \
    $(OBJDIR)/string_view.o \
    $(OBJDIR)/substitute.o 

Why_hdrs=\
    $(OBJDIR)/internal/charconv_bigint.h \
    $(OBJDIR)/internal/charconv_parse.h \
    $(OBJDIR)/internal/memutil.h \
    $(OBJDIR)/internal/str_join_internal.h \
    $(OBJDIR)/internal/str_split_internal.h \
    $(OBJDIR)/internal/stl_type_traits.h

$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building $@"
	@$(CXX) -c $(DEFAULT_COPTS) $(INCLUDES) -o $@ $<

$(LIBDIR)/$(LIB): $(OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(OBJS)
