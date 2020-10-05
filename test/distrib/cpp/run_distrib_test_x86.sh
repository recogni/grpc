#!/bin/bash
#Build hello world demo programs for x86
#Taken from https://grpc.io/docs/languages/cpp/quickstart/
#

MY_INSTALL_DIR=/tmp/native_build
BUILD_AREA=cmake/native_build

set -e

mkdir -p $MY_INSTALL_DIR
export PATH="$MY_INSTALL_DIR/bin:$PATH"

case "$1" in
    clean*)
        # Clean up prior builds
        echo "Removing ${BUILD_AREA}"
        rm -rf ${BUILD_AREA}
        sudo rm -rf examples/cpp/helloworld/${BUILD_AREA}
        rm -rf ${MY_INSTALL_DIR}
        
        case "$1" in
            cleanonly)
                echo "Clean & exit"
                exit
                ;;
        esac
        ;;
    *)
        ;;
esac


# Build libs
mkdir -p ${BUILD_AREA}
pushd ${BUILD_AREA}
cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR  ../..
make -j4
make install
popd

#Build app
pushd examples/cpp/helloworld/
sudo mkdir -p ${BUILD_AREA}
pushd ${BUILD_AREA}
sudo cmake -DCMAKE_PREFIX_PATH=$MY_INSTALL_DIR ../..
sudo make -j4
popd
popd

