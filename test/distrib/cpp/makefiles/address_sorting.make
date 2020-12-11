
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

CXXFLAGS?=-O3 -g
LDFLAGS?=

ADDRESS_SORTING_FLAGS := $(SCORPIO_DEFINES) -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers $(SCORPIO_INCLUDES) -I./include
ARFLAGS?=rsc

OBJDIR := $(CROSS_OBJ)/address_sorting
LIBDIR := $(CROSS_LIB)

.PHONY: all
all: $(LIBDIR)/address_sorting.a 

OFILES=\
	$(OBJDIR)/address_sorting.o\
	$(OBJDIR)/address_sorting_posix.o\


$(OBJDIR)/%.o: %.c 
	@mkdir -p $$(dirname $@)
	@echo "Build Address_sorting $@"
	@$(GCC) -c -o $@ -std=c99 $(ADDRESS_SORTING_FLAGS) $*.c

$(LIBDIR)/address_sorting.a: $(OFILES)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $(LIBDIR)/address_sorting.a $(OFILES)

.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(LIBDIR)/address_sorting.a
