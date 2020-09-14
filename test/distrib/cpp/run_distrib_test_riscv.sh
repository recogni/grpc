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

#These are private, no need to mess with.
BUILD_AREA=riscv_build
TMP_TOOLCHAIN=/tmp/riscv_root

set -ex

# Verify toolchain
if [ ! -x ${RISCV_TOOLCHAIN}/bin/riscv64-unknown-elf-gcc ]; then
    echo "RISCV_TOOLCHAIN should point to a previously created cross compile environment."
    echo "See https://github.com/recogni/scorpio-fw for how to create one."
    exit
fi

cd "$(dirname "$0")/../../.."

# Brett: just need to do once...ever.
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then
# Install openssl (to use instead of boringssl)
apt-get update && apt-get install -y libssl-dev

# Install CMake 3.16
apt-get update && apt-get install -y wget
wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.16.1/cmake-3.16.1-Linux-x86_64.sh
sh cmake-linux.sh -- --skip-license --prefix=/usr
rm cmake-linux.sh

# Build and install gRPC for the host architecture.
# We do this because we need to be able to run protoc and grpc_cpp_plugin
# while cross-compiling.
mkdir -p "cmake/build"
pushd "cmake/build"
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DgRPC_INSTALL=ON \
  -DgRPC_BUILD_TESTS=OFF \
  -DgRPC_SSL_PROVIDER=package \
  ../..
make -j4 install
##make install
popd
fi  

echo "Removing old build"
rm -rf cmake/${BUILD_AREA}/


# Download toolchain if needed.
if [ ! -d ${TMP_TOOLCHAIN}/riscv ]
then
    mkdir -p ${TMP_TOOLCHAIN}
    pushd ${TMP_TOOLCHAIN}
    mkdir riscv
    cp -r ${RISCV_TOOLCHAIN}/* riscv
else
    pushd ${TMP_TOOLCHAIN}
fi

#SET(CMAKE_SYSTEM_PROCESSOR riscv64)


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

# Build and install gRPC for raspberry pi.
# This build will use the host architecture copies of protoc and
# grpc_cpp_plugin that we built earlier because we installed them
# to a location in our PATH (/usr/local/bin).
mkdir -p "cmake/${BUILD_AREA}"
pushd "cmake/${BUILD_AREA}"
cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/riscv_root/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/tmp/riscv_root/grpc_install \
      ../..
make -j4 install
##make install
popd

# Build helloworld example for raspberry pi.
# As above, it will find and use protoc and grpc_cpp_plugin
# for the host architecture.
mkdir -p "examples/cpp/helloworld/cmake/${BUILD_AREA}"
pushd "examples/cpp/helloworld/cmake/${BUILD_AREA}"
cmake -DCMAKE_TOOLCHAIN_FILE=/tmp/riscv_root/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DProtobuf_DIR=/tmp/riscv_root/stage/lib/cmake/protobuf \
      -DgRPC_DIR=/tmp/riscv_root/stage/lib/cmake/grpc \
      ../..
make
popd
