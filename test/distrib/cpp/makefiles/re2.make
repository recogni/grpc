
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

# can override
CXXFLAGS?=-O3 -g
LDFLAGS?=
# required
RE2_CXXFLAGS?=-std=c++11 $(SCORPIO_DEFINES) -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -I. #$(CCICU) $(CCPCRE)
ARFLAGS?=rsc
NMFLAGS?=-p

OBJDIR := $(CROSS_OBJ)/re2
LIBDIR := $(CROSS_LIB)

.PHONY: all
all: $(LIBDIR)/libre2.a 

OFILES=\
	$(OBJDIR)/util/rune.o\
	$(OBJDIR)/util/strutil.o\
	$(OBJDIR)/re2/bitstate.o\
	$(OBJDIR)/re2/compile.o\
	$(OBJDIR)/re2/dfa.o\
	$(OBJDIR)/re2/filtered_re2.o\
	$(OBJDIR)/re2/mimics_pcre.o\
	$(OBJDIR)/re2/nfa.o\
	$(OBJDIR)/re2/onepass.o\
	$(OBJDIR)/re2/parse.o\
	$(OBJDIR)/re2/perl_groups.o\
	$(OBJDIR)/re2/prefilter.o\
	$(OBJDIR)/re2/prefilter_tree.o\
	$(OBJDIR)/re2/prog.o\
	$(OBJDIR)/re2/re2.o\
	$(OBJDIR)/re2/regexp.o\
	$(OBJDIR)/re2/set.o\
	$(OBJDIR)/re2/simplify.o\
	$(OBJDIR)/re2/stringpiece.o\
	$(OBJDIR)/re2/tostring.o\
	$(OBJDIR)/re2/unicode_casefold.o\
	$(OBJDIR)/re2/unicode_groups.o\

$(OBJDIR)/%.o: %.cc 
	@mkdir -p $$(dirname $@)
	@echo "Building RE2 $@"
	@$(CXX) -c -o $@ $(CPPFLAGS) $(RE2_CXXFLAGS) $(CXXFLAGS) -DNDEBUG $*.cc

$(LIBDIR)/libre2.a: $(OFILES)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $(LIBDIR)/libre2.a $(OFILES)

.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(LIBDIR)/libre2.a
