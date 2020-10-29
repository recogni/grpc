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

# Bail on errors
set -e

# Add options here
while [[ $# -gt 0 ]]
do
    case "$1" in
        clean*)
            # Keyword 'clean' removes (causing a rebuild) of the 
            # host arch build tools, libs etc.

            echo "Cleaning $TMP_TOOLCHAIN and ${RISCV_BUILD_AREA}"
            rm -rf $TMP_TOOLCHAIN
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

cd "$(dirname "$0")/../../.."

#
# Create & install: 
#   x86 toolchains
#   x86 grpc & libs 
#
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then
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

    # Build and install gRPC including libraries for the host architecture.
    # We do this because we need to be able to run protoc and grpc_cpp_plugin
    # while cross-compiling.
    # These binaries get installed in to /usr/local/bin.
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
    sudo make -j4 install
    popd
else
    echo "Host versions of protoc and grpc_plugin already in place"
fi  


# Copy toolchain if needed.
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then  
    echo "3.0: Copying riscv cross compile env"
    $ONE_STEP && echo "Hit Return" && read ans
        mkdir -p ${TMP_TOOLCHAIN}
    pushd ${TMP_TOOLCHAIN}
    mkdir riscv
    cp -r ${RISCV_TOOLCHAIN}/* riscv
else
    #echo "RISCV cross compilers up to date"
    pushd ${TMP_TOOLCHAIN}
fi

# Guarantee we definetly aren't using libc pthread
if [ "$BUILD_TYPE" = "newlib" ]
then
    if [ -f ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/include/pthread.h ]
    then
       echo "Renaming pthread.h"
       mv ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/include/pthread.h ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/include/pthread.h.test
    fi
fi

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

# unknown-linux-gnu  works for linux but we'll prob need unknown-elf for FreeRTOS.
# unknown-elf fails when abseil is unable to find Threads package (prob just cuz its
# the first to look for it)..
echo "set(devel_root ${TMP_TOOLCHAIN})" > toolchain.cmake
echo "set(CMAKE_C_FLAGS \"-I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/FreeRTOS_POSIX \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/FreeRTOS-Plus-POSIX/include \
   -I${SCORPIO_TREE}/modules/Lab-Project-FreeRTOS-POSIX/include/private \
   -T ${SCORPIO_TREE}/src/scpu/main/link.ld -nostartfiles -static -nostdlib \
   ${SCORPIO_TREE}/src/scpu/main/boot.o \
   ${SCORPIO_TREE}/src/scpu/rtos/playground.o \
   -Wl,-L ${SCORPIO_TREE}/src/scpu \
   -llfs -lscpu -llfs -lscpu -lpthreads -lc -lgcc -lscpu \
   ${TMP_TOOLCHAIN}/riscv/riscv64-unknown-elf/lib/libc.a \
   \")" >> toolchain.cmake

cat >> toolchain.cmake <<'EOT'
SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR riscv64)
set(CMAKE_STAGING_PREFIX ${devel_root}/stage)
set(tool_root ${devel_root}/riscv)
#set(CMAKE_SYSROOT ${tool_root}/sysroot)
set(CMAKE_SYSROOT ${tool_root}/riscv64-unknown-elf)
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
