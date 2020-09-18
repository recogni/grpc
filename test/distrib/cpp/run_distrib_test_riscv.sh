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

#Ask user to hit return at each major step,
ONE_STEP=false   # set to true or false

#These are private, no need to mess with.
RISCV_BUILD_AREA=riscv_build        # RISCV libraries and binaries
TMP_TOOLCHAIN=/tmp/riscv_root       # x86 toolchain, libs, etc

# Bail on errors
set -e

# Add options here
case "$1" in
    clean)
        # Keyword 'clean' removes (causing a rebuild) of the 
        # host arch build tools, libs etc.
        rm -rf $TMP_TOOLCHAIN

        # Do I always need to do this?
        rm -rf cmake/${RISCV_BUILD_AREA}/
        ;;
    *)
        echo "Leave $TMP_TOOLCHAIN in place"
        ;;
esac

# Verify toolchain
if [ ! -x ${RISCV_TOOLCHAIN}/bin/riscv64-unknown-elf-gcc ]; then
    echo "RISCV_TOOLCHAIN should point to a previously created cross compile environment."
    echo "See https://github.com/recogni/scorpio-fw for how to create one."
    exit
fi

cd "$(dirname "$0")/../../.."

#
# Create & install x86 toolchains
#
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then
    $ONE_STEP && echo  "1.0: Build local host version of grpc/Hit Return" && read ans

    #
    # Install CMake 3.16 only if needed
    #
    if [ -x /usr/bin/cmake ] && /usr/bin/cmake --version 2>/dev/null | grep -q 3.16.1; then
        echo "Have cmake, skip install"
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
    $ONE_STEP && echo  "1.5: Host compile protoc and grpc_plugin/Hit Return" && read ans
    mkdir -p "cmake/build"
    pushd "cmake/build"
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_SSL_PROVIDER=package \
      ../..
    make -j4 install
    popd
fi  


# Download toolchain if needed.
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then  
    $ONE_STEP && echo "2.0: Downloading risc cross compilers/Hit Return" && read ans
    mkdir -p ${TMP_TOOLCHAIN}
    pushd ${TMP_TOOLCHAIN}
    mkdir riscv
    cp -r ${RISCV_TOOLCHAIN}/* riscv
else
    $ONE_STEP && echo "2.0: Skip Downloading risc cross compilers/Hit Return" && read ans
    pushd ${TMP_TOOLCHAIN}
fi

#SET(CMAKE_SYSTEM_PROCESSOR riscv64)

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

cat > toolchain.cmake <<'EOT'
SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR xxriscv64)
set(devel_root /tmp/riscv_root)
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
popd

# This build will use the host architecture copies of protoc and
# grpc_cpp_plugin that we built earlier.
$ONE_STEP && echo "3.0: Do riscv builds/Hit Return" && read ans
mkdir -p "cmake/${RISCV_BUILD_AREA}"
pushd "cmake/${RISCV_BUILD_AREA}"
cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/riscv_root/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/tmp/riscv_root/grpc_install \
      ../..

#This is the heavy ifting....build all needed libraries,
# executables, etc.
$ONE_STEP && echo "3.1: Install riscv builds/Hit Return" && read ans
make -j4 install
popd

# Build helloworld example for raspberry pi.
# As above, it will find and use protoc and grpc_cpp_plugin
# for the host architecture.
$ONE_STEP && echo "4.0: Build riscv version of example app/Hit Return" && read ans
mkdir -p "examples/cpp/helloworld/cmake/${RISCV_BUILD_AREA}"
pushd "examples/cpp/helloworld/cmake/${RISCV_BUILD_AREA}"
cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/riscv_root/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DProtobuf_DIR=/tmp/riscv_root/stage/lib/cmake/protobuf \
      -DgRPC_DIR=/tmp/riscv_root/stage/lib/cmake/grpc \
      ../..
make
popd
