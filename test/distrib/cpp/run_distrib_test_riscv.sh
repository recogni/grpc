#!/bin/bash
# Copyright 2017 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# grpc/test/distrib/cpp/run_distrib_test_riscv.sh

#
# Modify this to point to your RISCV cross compile toolchain
#
RISCV_TOOLCHAIN=/opt/scorpio-fw-gcc/

#
#Point to the scorpio-fw directory of your scorpio tree
#(where you have built scorpio libraries).
#
SCORPIO_TREE=/home/brett/scorp_oct19_libs/scorpio-fw

#Ask user to hit return at each major step,
ONE_STEP=false   # set to true or false

#These are private, no need to mess with.
RISCV_BUILD_AREA=cmake/riscv_build        # RISCV libraries and binaries
HOST_BUILD_AREA=cmake/build               # Host libraries and binaries
TMP_TOOLCHAIN=/tmp/riscv_root             # x86 based crosscompile toolchain,
                                          # as well as riscv crosscompiled support tools

SKIP_CMAKE=true

# Bail on errors
set -e

# Add options here
while [[ $# -gt 0 ]]
do
    case "$1" in
        *clean*)
            # Keyword 'clean' removes (causing a rebuild) of the 
            # host arch build tools, libs etc.

            echo "Removing staging area..."
            rm -rf  ${TMP_TOOLCHAIN}/stage

            echo "Cleaning $TMP_TOOLCHAIN and ${RISCV_BUILD_AREA}"
            if [ "$1" = "deepclean" ]; then
                echo "Removing TMP_TOOLCHAIN"
                rm -rf $TMP_TOOLCHAIN
            fi
            rm -rf ${RISCV_BUILD_AREA}/
            sudo rm -rf ${HOST_BUILD_AREA}/
            rm -rf examples/cpp/helloworld/${RISCV_BUILD_AREA}
            if [ "$1" = "cleanonly" ]; then
                echo "Clean & exit"
                exit
            fi
            shift
            ;;
        linux)
            BUILD_TYPE=linux
            shift
            ;;
        newlib)
            BUILD_TYPE=newlib
            shift
            ;;
        *)
            #echo "Leave $TMP_TOOLCHAIN in place"
            shift
            ;;
    esac
done

if [ -z $BUILD_TYPE ];then
    echo Must pick a build type, either newlib or linux
    exit
fi

echo build_riscv.sh build type is $BUILD_TYPE

rm -f cmake/riscv_build/CMakeFiles/CMakeOutput.log
rm -f cmake/riscv_build/CMakeFiles/CMakeError.log

# Verify toolchain

#This script makes a copy of the existing RISCV toolchain ($RISCV_TOOLCHAIN)
# in $TMP_TOOLCHAIN) since this script adds significantly to it.
# This also lets us trivialy remove the entire temp toolchain for cleaning.

if [ ! -x ${RISCV_TOOLCHAIN}/bin/riscv64-unknown-elf-gcc ]; then
    echo "RISCV_TOOLCHAIN should point to a previously created cross compile environment."
    echo "See https://github.com/recogni/scorpio-fw for how to create one."
    exit
else
    echo "Found valid riscv toolchain in place at ${RISCV_TOOLCHAIN}"
fi

#rootdir= root of grpc dir
#makedir= dir with makefiles
makedir=test/distrib/cpp/makefiles
cd "$(dirname "$0")/../../.."
rootdir=$(pwd)

#
# Create & install: 
#   x86 toolchains
#   x86 grpc & libs 
#

echo  "1.0: Install/update local cmake version if needed"
$ONE_STEP && echo  "Hit Return" && read ans

#
# Install CMake 3.16 only if needed
#
if [ -x /usr/bin/cmake ] && /usr/bin/cmake --version 2>/dev/null | grep -q 3.16.1; then
    echo "cmake already up to date"
else
    apt-get update && apt-get install -y wget
    wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1-Linux-x86_64.sh
    sh cmake-linux.sh -- --skip-license --prefix=/usr
    rm cmake-linux.sh

    # Assume we only need to check libssl-dev the first time cmake is installed.
    # Install openssl (to use instead of boringssl)
    apt-get update && apt-get install -y libssl-dev
fi

if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then
    # Build and install gRPC including libraries for the host architecture.
    # We do this because we need to be able to run protoc and grpc_cpp_plugin
    # while cross-compiling.
    # These binaries get installed in to /usr/local/bin.
    echo "1.1: Stash any config files from RISCV build"
    [ -f ${rootdir}/third_party/cares/cares/ares_config.h ] && rm ${rootdir}/third_party/cares/cares/ares_config.h
    [ -f ${rootdir}/third_party/zlib/zconf.h ] && rm ${rootdir}/third_party/zlib/zconf.h

    echo  "1.5: Build host versions of protoc and grpc_plugin"
    $ONE_STEP && echo  "Hit Return" && read ans
    mkdir -p ${HOST_BUILD_AREA}
    pushd ${HOST_BUILD_AREA}
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_SSL_PROVIDER=package \
      ../..
    echo "2.0: Finished native cmake, about to make"
    $ONE_STEP && echo "Hit Return" && read ans
    #sudo make -j4 install
    sudo make install
    popd
else
    echo "Host versions of protoc and grpc_plugin already in place"
fi  


#FIXME Map linux errno to freertos.  Complete hack for now. FIXME
#Adds an #Ifdef SCORPIO block to the file.
function fix_errno()
{
    local file=${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/include/c++/9.2.0/riscv64-unknown-elf/bits/error_constants.h
    mv ${file} ${file}.orig
    cat ${file}.orig | head -n 41 > ${file}
    cat << EOF >> ${file}
#ifdef SCORPIO
#define BLAH 5
      address_family_not_supported = 	BLAH,
      address_in_use = 				    BLAH,
      address_not_available = 			BLAH,
      already_connected = 			    BLAH,
      argument_list_too_long = 			BLAH,
      argument_out_of_domain = 			BLAH,
      bad_address = 				    BLAH,
      bad_file_descriptor = 			BLAH,
#ifdef _GLIBCXX_HAVE_EBADMSG
      bad_message = 				    BLAH,
#endif
      broken_pipe = 				    BLAH,
      connection_aborted = 			    BLAH,
      connection_already_in_progress = 	BLAH,
      connection_refused = 			    BLAH,
      connection_reset = 			    BLAH,
      cross_device_link = 			    BLAH,
      destination_address_required = 	BLAH,
      device_or_resource_busy = 		BLAH,
      directory_not_empty = 			BLAH,
      executable_format_error = 		BLAH,
      file_exists = 	       			BLAH,
      file_too_large = 				    BLAH,
      filename_too_long = 			    BLAH,
      function_not_supported = 			BLAH,
      host_unreachable = 			    BLAH,
#ifdef _GLIBCXX_HAVE_EIDRM
      identifier_removed = 			    BLAH,
#endif
      illegal_byte_sequence = 			BLAH,
      inappropriate_io_control_operation = 	BLAH,
      interrupted = 				    BLAH,
      invalid_argument = 			    BLAH,
      invalid_seek = 				    BLAH,
      io_error = 				        BLAH,
      is_a_directory = 				    BLAH,
      message_size = 				    BLAH,
      network_down = 				    BLAH,
      network_reset = 				    BLAH,
      network_unreachable = 			BLAH,
      no_buffer_space = 			    BLAH,
      no_child_process = 			    BLAH,
#ifdef _GLIBCXX_HAVE_ENOLINK
      no_link = 				        BLAH,
#endif
      no_lock_available = 			    BLAH,
#ifdef _GLIBCXX_HAVE_ENODATA
      no_message_available = 			BLAH,
#endif
      no_message = 				        BLAH,
      no_protocol_option = 			    BLAH,
      no_space_on_device = 			    BLAH,
#ifdef _GLIBCXX_HAVE_ENOSR
      no_stream_resources = 			BLAH,
#endif
      no_such_device_or_address = 		BLAH,
      no_such_device = 				    BLAH,
      no_such_file_or_directory = 		BLAH,
      no_such_process = 			    BLAH,
      not_a_directory = 			    BLAH,
      not_a_socket = 				    BLAH,
#ifdef _GLIBCXX_HAVE_ENOSTR
      not_a_stream = 				    BLAH,
#endif
      not_connected = 				    BLAH,
      not_enough_memory = 			    BLAH,
#ifdef _GLIBCXX_HAVE_ENOTSUP
      not_supported = 				    BLAH,
#endif
#ifdef _GLIBCXX_HAVE_ECANCELED
      operation_canceled = 			    BLAH,
#endif
      operation_in_progress = 			BLAH,
      operation_not_permitted = 		BLAH,
      operation_not_supported = 		BLAH,
      operation_would_block = 			BLAH,

#ifdef _GLIBCXX_HAVE_EOWNERDEAD
      owner_dead = 				        BLAH,
#endif
      permission_denied = 			    BLAH,
#ifdef _GLIBCXX_HAVE_EPROTO
      protocol_error = 				    BLAH,
#endif
      protocol_not_supported = 			BLAH,
      read_only_file_system = 			BLAH,
      resource_deadlock_would_occur = 	BLAH,
      resource_unavailable_try_again = 	BLAH,
      result_out_of_range = 			BLAH,
#ifdef _GLIBCXX_HAVE_ENOTRECOVERABLE
      state_not_recoverable = 			BLAH,
#endif
#ifdef _GLIBCXX_HAVE_ETIME
      stream_timeout = 				    BLAH,
#endif
#ifdef _GLIBCXX_HAVE_ETXTBSY
      text_file_busy = 				    BLAH,
#endif
      timed_out = 				        BLAH,
      too_many_files_open_in_system = 	BLAH,
      too_many_files_open = 			BLAH,
      too_many_links = 				    BLAH,
      too_many_symbolic_link_levels = 	BLAH,
#ifdef _GLIBCXX_HAVE_EOVERFLOW
      value_too_large = 			    BLAH,
#endif
      wrong_protocol_type = 			BLAH
#else //SCORPIO
EOF
    cat ${file}.orig | sed '1,41d' >> ${file}
    sed -i '/EPROTOTYPE/a#endif //SCORPIO' ${file}
}

#
# Native build finished.  Now start crosscompile process.
#

# Copy toolchain if needed.
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then  
    echo "3.0: Native build complete. Copying riscv cross compile env"

    $ONE_STEP && echo "Hit Return" && read ans
    mkdir -p ${TMP_TOOLCHAIN}
    pushd ${TMP_TOOLCHAIN}
    mkdir riscv
    cp -r ${RISCV_TOOLCHAIN}/* riscv

    fix_errno

    file=riscv/riscv64-unknown-elf/include/pthread.h
    if [ -f ${file} ]; then
       echo "Renaming pthread.h"
       mv ${file} ${TMP_TOOLCHAIN}/${file}.orig
    fi

    file=riscv/riscv64-unknown-elf/include/sys/time.h
    if [ -f ${file} ]; then
       echo "Renaming time.h"
       mv ${file} ${TMP_TOOLCHAIN}/${file}.orig
    fi

    file=riscv/riscv64-unknown-elf/include/c++/9.2.0/ctime
    if [ ! -f ${file}.orig ]; then
        cp ${file} ${file}.orig
        sed -i '/using ::tm;/a  using ::mktime;\n#ifndef SCORPIO' ${file}
        sed -i '/using ::strftime;/a#endif //SCORPIO' ${file}
    fi

    file=riscv/riscv64-unknown-elf/include/sys/_timeval.h
    if [ ! -f ${file}.orig ]; then
        mv ${file} ${file}.orig
        echo "#ifndef SCORPIO" | cat - ${file}.orig > ${file}
        echo "#endif //SCORPIO" >> ${file}
    fi

    file=riscv/riscv64-unknown-elf/include/sys/stat.h
    if [ -f ${file} ]; then
        sed -i 's!#include <sys/_timespec.h>!// Brett #include <sys/_timespec.h>!' ${file}
    else
        echo "WTF, No stat.h!"
        exit
    fi
    popd
fi

if [ "$SKIP_CMAKE" = "true" ]
then
    echo "Start building Make based cross compile libs"
    # These place objects ad resulting .a files in  ${TMP_TOOLCHAIN}/riscv, so these should not interfere with cmake.

    # From: ~/grpc_oct15/grpc/cmake/riscv_build/CMakeFiles/Makefile2
    #all: CMakeFiles/grpc++_reflection.dir/all
    #all: CMakeFiles/gpr.dir/all
    #all: CMakeFiles/grpc_unsecure.dir/all
    #all: CMakeFiles/grpc++_unsecure.dir/all
    #all: CMakeFiles/address_sorting.dir/all
    #all: CMakeFiles/check_epollexclusive.dir/all
    #all: CMakeFiles/grpc_plugin_support.dir/all
    #all: CMakeFiles/upb.dir/all
    #all: CMakeFiles/gen_legal_metadata_characters.dir/all
    #all: CMakeFiles/grpc++_error_details.dir/all
    #all: CMakeFiles/gen_percent_encoding_tables.dir/all
    #all: CMakeFiles/grpc_cpp_plugin.dir/all
    #all: CMakeFiles/gen_hpack_tables.dir/all
    #all: third_party/abseil-cpp/all
    #all: third_party/cares/cares/all
    #all: third_party/protobuf/all
    #all: third_party/re2/all
    #all: third_party/zlib/all

    echo "Copying config files"
    cp ${rootdir}/${makedir}/ares_config.h ${rootdir}/third_party/cares/cares/ares_config.h
    cp ${rootdir}/${makedir}/zconf.h       ${rootdir}/third_party/zlib/zconf.h

#     Directory                                     Makefile
#     --------                                      -------
MAKELIST="\
    third_party/re2                                 re2.make
    third_party/zlib                                zlib.make
    third_party/address_sorting                     address_sorting.make
    third_party/cares/cares                         cares.make
    third_party/abseil-cpp/absl/base                absl_base.make
    third_party/abseil-cpp/absl/base                absl_dynamic.make
    third_party/abseil-cpp/absl/base                absl_exponential_biased.make
    third_party/abseil-cpp/absl/base                absl_log_severity.make
    third_party/abseil-cpp/absl/base                absl_malloc_internal.make
    third_party/abseil-cpp/absl/base                absl_raw_logging_internal.make
    third_party/abseil-cpp/absl/base                absl_spinlock_wait.make
    third_party/abseil-cpp/absl/base                absl_throw_delegate.make
    third_party/abseil-cpp/absl/debugging           absl_debugging_internal.make
    third_party/abseil-cpp/absl/debugging           absl_demangle_internal.make
    third_party/abseil-cpp/absl/debugging           absl_stacktrace.make
    third_party/abseil-cpp/absl/debugging           absl_symbolize.make
    third_party/abseil-cpp/absl/hash                absl_city.make
    third_party/abseil-cpp/absl/hash                absl_hash.make
    third_party/abseil-cpp/absl/strings             absl_strings.make
    third_party/abseil-cpp/absl/strings             absl_strings_internal.make
    third_party/abseil-cpp/absl/synchronization     absl_graphcycles_internal.make
    third_party/abseil-cpp/absl/types               absl_bad_optional_access.make
    third_party/abseil-cpp/absl/types               absl_bad_variant_access.make
    third_party/abseil-cpp/absl/container            absl_raw_hash_set.make
    third_party/abseil-cpp/absl/container            absl_hashtablez_sampler.make
    third_party/abseil-cpp/absl/numeric              absl_int128.make
    third_party/abseil-cpp/absl/strings              absl_cord.make
    third_party/abseil-cpp/absl/strings              absl_str_format_internal.make
    third_party/abseil-cpp/absl/time/internal/cctz   absl_civil_time.make
    third_party/abseil-cpp/absl/time                 absl_time.make
    third_party/abseil-cpp/absl/time/internal/cctz   absl_time_zone.make
    /home/brett/grpc_oct15/grpc                      gpr.make"

    # Need to revisit these that don't build
NO_BUILD="\
    third_party/abseil-cpp/absl/synchronization      absl_synchronization.make
    "

# target=clean
while read dir makefile; do
    echo -e "\ncd ${dir}, execute ${makefile}"
    make --no-print-directory -C ${dir} -f ${rootdir}/${makedir}/${makefile} $target
    if [ $? -ne 0 ]; then
        echo "XXXXXXXXXXXXXXX Make ${makefile} FAILED!"
        exit 1
    fi
done <<< "$MAKELIST"

fi    #SKIP_CMAKE

pushd ${TMP_TOOLCHAIN}

#Eventually we may have to add flags... for example (stolen from QNX platform):
#set(CMAKE_CXX_FLAGS "-Vgcc_ntoaarch64 -O2 -Wc,-Wall -DBUILDENV_qss -g -Os -Wall -march=armv8-a -mcpu=cortex-a57 -mtune=cortex-a57 \
#        -fstack-protector-strong -DNDEBUG -DFMT_HEADER_ONLY -EL -DVARIANT_le -std=c++11 -stdlib=libstdc++ -lang-c++ \
#        -I . \
#        -I$ENV{TOOLCHAIN_PATH}/usr/include \
#        -I$ENV{TOOLCHAIN_PATH}/usr/include/WF \
#        -I$ENV{TOOLCHAIN_PATH}/usr/include/KHR \
#        -I$ENV{INSTALL_ROOT_nto}/usr/include \
#        -Wl,-L$ENV{INSTALL_ROOT_nto}/aarch64le/lib \
#        -Wl,-L$ENV{INSTALL_ROOT_nto}/aarch64le/usr/lib \
#        -Wl,-L$ENV{TOOLCHAIN_PATH}/aarch64le/lib \
#        -Wl,-L$ENV{TOOLCHAIN_PATH}/aarch64le/usr/lib")

# Currently in ${TMP_TOOLCHAIN}

if [ "$BUILD_TYPE" = "linux" ]
then

echo "set(devel_root ${TMP_TOOLCHAIN})" > toolchain.cmake
cat >> toolchain.cmake <<'EOT'
SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR riscv64)
set(CMAKE_STAGING_PREFIX ${devel_root}/stage)
set(tool_root ${devel_root}/riscv)
set(CMAKE_SYSROOT ${tool_root}/sysroot)
set(CMAKE_C_COMPILER ${tool_root}/bin/riscv64-unknown-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${tool_root}/bin/riscv64-unknown-linux-gnu-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOT

else  # not 'linux", must be "newlib"

if [ "$SKIP_CMAKE" = "true" ]
then
    echo "Skipping CMake and using newlib, built all libs."
    exit
fi

# unknown-linux-gnu  works for linux but we'll prob need unknown-elf for FreeRTOS.
# unknown-elf fails when abseil is unable to find Threads package (prob just cuz its
# the first to look for it)..
echo "set(devel_root ${TMP_TOOLCHAIN})" > toolchain.cmake
## echo "set(CMAKE_C_INCLUDES ${SCORPIO_TREE})" >> toolchain.cmake
# --sysroot=/opt/scorpio-fw-gcc/sysroot \
echo "set(CMAKE_C_FLAGS \"  \
   -DRISCV \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Kernel/include \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Kernel/portable/GCC/RISC-V \
   -I${SCORPIO_TREE}/src/scpu \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/FreeRTOS_POSIX \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/private \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Plus-TCP/include \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Plus-TCP/portable/Compiler/GCC \
   -I${SCORPIO_TREE}/src/scpu/hal \
   -I${SCORPIO_TREE}/src/scpu/include \
   -I${SCORPIO_TREE}/src/common/include \
   -T ${SCORPIO_TREE}/src/scpu/main/link.ld -nostartfiles -static -nostdlib \
   ${SCORPIO_TREE}/src/scpu/main/boot.o \
   ${SCORPIO_TREE}/src/scpu/rtos/playground.o \
   -Wl,-L ${SCORPIO_TREE}/src/scpu \
   -llfs -lscpu -llfs -lscpu -lpthreads -lc -lgcc -lscpu \
   ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/lib/libc.a \
   \")" >> toolchain.cmake

echo "set(CMAKE_CXX_FLAGS \"  \
   -DRISCV \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Kernel/include \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Kernel/portable/GCC/RISC-V \
   -I${SCORPIO_TREE}/src/scpu \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/FreeRTOS_POSIX \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/private \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Plus-TCP/include \
   -I${SCORPIO_TREE}/modules/FreeRTOS-Plus-TCP/portable/Compiler/GCC \
   -I${SCORPIO_TREE}/src/scpu/hal \
   -I${SCORPIO_TREE}/src/scpu/include \
   -I${SCORPIO_TREE}/src/common/include \
   -T ${SCORPIO_TREE}/src/scpu/main/link.ld -nostartfiles -static -nostdlib \
   ${SCORPIO_TREE}/src/scpu/main/boot.o \
   ${SCORPIO_TREE}/src/scpu/rtos/playground.o \
   -Wl,-L ${SCORPIO_TREE}/src/scpu \
   -llfs -lscpu -llfs -lscpu -lpthreads -lscpu \
   ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/lib/libg.a \
   \")" >> foo
   # \")" >> toolchain.cmake

echo "set(CMAKE_CXX_FLAGS \"  \
   -DRISCV \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/FreeRTOS_POSIX \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/private \
    \")" >> toolchain.cmake

# DIdn;t seem to change anythng
#  ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/lib/libstdc++.a  
#   ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/lib/libm.a 

cat >> toolchain.cmake <<'EOT'
SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR riscv64)
set(CMAKE_STAGING_PREFIX ${devel_root}/stage)
set(tool_root ${devel_root}/riscv)
#set(CMAKE_SYSROOT /opt/scorpio-fw-gcc/sysroot)
#set(CMAKE_SYSROOT ${tool_root}/sysroot)
#Brett just switched this back to systroot 11/4
#set(CMAKE_SYSROOT ${tool_root}/riscv64-unknown-elf)
set(CMAKE_C_COMPILER ${tool_root}/bin/riscv64-unknown-elf-gcc)
set(CMAKE_CXX_COMPILER ${tool_root}/bin/riscv64-unknown-elf-g++)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOT

fi  # BUILD_TYPE

popd

# Create the Makefiles that will cross compile for riscv 
echo "4.0: Create Makefile for Riscv builds in ${RISCV_BUILD_AREA}"
$ONE_STEP && echo "Hit Return" && read ans
mkdir -p "${RISCV_BUILD_AREA}"
pushd "${RISCV_BUILD_AREA}"

cmake -DCMAKE_TOOLCHAIN_FILE=${TMP_TOOLCHAIN}/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${TMP_TOOLCHAIN}/grpc_install \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
      ../..

# Execute makefiles to build all needed libraries, executables, etc.
echo "5: Build riscv libs and executables"
$ONE_STEP && echo "Hit Return" && read ans
make -j4 install
popd

#
# Use the Makefile to buld app vs cmake.
#
make -f test/distrib/cpp/run_distrib_test_hello.mk LIB=$BUILD_TYPE
exit

#
#Don't use cmake anymore.
#

# Now that libraries, tools, etc are built, go ahead and build
# the final app.
echo "6.0: Build riscv version of example app"
$ONE_STEP && echo "Hit Return" && read ans
mkdir -p "examples/cpp/helloworld/${RISCV_BUILD_AREA}"
pushd "examples/cpp/helloworld/${RISCV_BUILD_AREA}"
cmake -DCMAKE_TOOLCHAIN_FILE=${TMP_TOOLCHAIN}/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DProtobuf_DIR=${TMP_TOOLCHAIN}/stage/lib/cmake/protobuf \
      -DgRPC_DIR=${TMP_TOOLCHAIN}/stage/lib/cmake/grpc \
      ../..
make
popd
