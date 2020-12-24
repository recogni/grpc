
MAKEFILESDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILESDIR)/common.make

LIB=libprotobuf.a
OBJDIR := $(CROSS_OBJ)/$(basename $(LIB))
LIBDIR := $(CROSS_LIB)

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
-Wno-sign-compare  \
-Wno-unused-variable \
-Wno-unused-parameter

DEFAULT_COPTS= $(SCORPIO_DEFINES) $(GCC_FLAGS)
INCLUDES = $(SCORPIO_INCLUDES) -I../..

all: $(LIBDIR)/$(LIB)

clean:
	rm  -rf $(OBJDIR) $(LIBDIR)/$(LIB)

OBJS=\
   $(OBJDIR)/any_lite.o \
   $(OBJDIR)/arena.o \
   $(OBJDIR)/extension_set.o \
   $(OBJDIR)/generated_enum_util.o \
   $(OBJDIR)/generated_message_table_driven_lite.o \
   $(OBJDIR)/generated_message_util.o \
   $(OBJDIR)/implicit_weak_message.o \
   $(OBJDIR)/io/coded_stream.o \
   $(OBJDIR)/io/io_win32.o \
   $(OBJDIR)/io/strtod.o \
   $(OBJDIR)/io/zero_copy_stream.o \
   $(OBJDIR)/io/zero_copy_stream_impl.o \
   $(OBJDIR)/io/zero_copy_stream_impl_lite.o \
   $(OBJDIR)/message_lite.o \
   $(OBJDIR)/parse_context.o \
   $(OBJDIR)/repeated_field.o \
   $(OBJDIR)/stubs/bytestream.o \
   $(OBJDIR)/stubs/common.o \
   $(OBJDIR)/stubs/int128.o \
   $(OBJDIR)/stubs/status.o \
   $(OBJDIR)/stubs/statusor.o \
   $(OBJDIR)/stubs/stringpiece.o \
   $(OBJDIR)/stubs/stringprintf.o \
   $(OBJDIR)/stubs/structurally_valid.o \
   $(OBJDIR)/stubs/strutil.o \
   $(OBJDIR)/stubs/time.o \
   $(OBJDIR)/wire_format_lite.o \
   $(OBJDIR)/any.o \
   $(OBJDIR)/any.pb.o \
   $(OBJDIR)/api.pb.o \
   $(OBJDIR)/compiler/importer.o \
   $(OBJDIR)/compiler/parser.o \
   $(OBJDIR)/descriptor.o \
   $(OBJDIR)/descriptor.pb.o \
   $(OBJDIR)/descriptor_database.o \
   $(OBJDIR)/duration.pb.o \
   $(OBJDIR)/dynamic_message.o \
   $(OBJDIR)/empty.pb.o \
   $(OBJDIR)/extension_set_heavy.o \
   $(OBJDIR)/field_mask.pb.o \
   $(OBJDIR)/generated_message_reflection.o \
   $(OBJDIR)/generated_message_table_driven.o \
   $(OBJDIR)/io/gzip_stream.o \
   $(OBJDIR)/io/printer.o \
   $(OBJDIR)/io/tokenizer.o \
   $(OBJDIR)/map_field.o \
   $(OBJDIR)/message.o \
   $(OBJDIR)/reflection_ops.o \
   $(OBJDIR)/service.o \
   $(OBJDIR)/source_context.pb.o \
   $(OBJDIR)/struct.pb.o \
   $(OBJDIR)/stubs/substitute.o \
   $(OBJDIR)/text_format.o \
   $(OBJDIR)/timestamp.pb.o \
   $(OBJDIR)/type.pb.o \
   $(OBJDIR)/unknown_field_set.o \
   $(OBJDIR)/util/delimited_message_util.o \
   $(OBJDIR)/util/field_comparator.o \
   $(OBJDIR)/util/field_mask_util.o \
   $(OBJDIR)/util/internal/datapiece.o \
   $(OBJDIR)/util/internal/default_value_objectwriter.o \
   $(OBJDIR)/util/internal/error_listener.o \
   $(OBJDIR)/util/internal/field_mask_utility.o \
   $(OBJDIR)/util/internal/json_escaping.o \
   $(OBJDIR)/util/internal/json_objectwriter.o \
   $(OBJDIR)/util/internal/json_stream_parser.o \
   $(OBJDIR)/util/internal/object_writer.o \
   $(OBJDIR)/util/internal/proto_writer.o \
   $(OBJDIR)/util/internal/protostream_objectsource.o \
   $(OBJDIR)/util/internal/protostream_objectwriter.o \
   $(OBJDIR)/util/internal/type_info.o \
   $(OBJDIR)/util/internal/type_info_test_helper.o \
   $(OBJDIR)/util/internal/utility.o \
   $(OBJDIR)/util/json_util.o \
   $(OBJDIR)/util/message_differencer.o \
   $(OBJDIR)/util/time_util.o \
   $(OBJDIR)/util/type_resolver_util.o \
   $(OBJDIR)/wire_format.o \
   $(OBJDIR)/wrappers.pb.o 

$(OBJDIR)/%.o: %.cc
	@mkdir -p $$(dirname $@)
	@echo "Building $@"
	@$(CXX) -c $(DEFAULT_COPTS) $(INCLUDES) -o $@ $<

$(LIBDIR)/$(LIB): $(OBJS)
	@mkdir -p $$(dirname $@)
	@echo "=> Create $@"
	@$(AR) $(ARFLAGS) $@ $(OBJS)

