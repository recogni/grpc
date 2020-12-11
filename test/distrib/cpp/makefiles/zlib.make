
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make


OBJDIR := $(CROSS_OBJ)/libz
LIBDIR := $(CROSS_LIB)

C_FLAGS := -O3 -DNDEBUG -fPIC -std=gnu99
SCORPIO_DEFINES += -DGRPC_USE_PROTO_LITE 
C_INCLUDES := -I.  # For zconf.h


LIBZ_SRCS := \
adler32.c \
compress.c \
crc32.c \
deflate.c \
gzclose.c \
gzlib.c \
gzread.c \
gzwrite.c \
inflate.c \
infback.c \
inftrees.c \
inffast.c \
trees.c \
uncompr.c \
zutil.c

LIBZ_OBJS := $(LIBZ_SRCS:%.c=$(OBJDIR)/%.o)

$(OBJDIR)/%.o: %.c
	@echo "Building Zlib $@"
	@$(GCC) -c $(SCORPIO_DEFINES) $(C_INCLUDES) $(SCORPIO_INCLUDES) $(C_FLAGS) -o $@ $<

all: prep $(LIBDIR)/libzstatic.a

$(LIBDIR)/libzstatic.a: $(LIBZ_OBJS)
	@echo "=> Create $@"
	@$(AR) qc $@ $^
	@$(RANLIB) $@

.PHONY: prep
prep:
	@mkdir -p $(OBJDIR) $(LIBDIR)

.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(LIBDIR)/libzstatic.a
