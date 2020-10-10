# Building grpc with FreeRTOS

#  1. Checkout grpc tree and build grpc libs

The run_distrib_test_riscv.sh script below will install cmake for you if needed but
some other pre-reqs may still be missing....

# Clone and build grpc tools and cross compile:
    git clone -b recogni https://github.com/recogni/grpc
    cd grpc
    git submodule update --init
    Edit test/distrib/cpp/run_distrib_test_riscv.sh
      set RISCV_TOOLCHAIN=your_toolchain_location_

    test/distrib/cpp/run_distrib_test_riscv.sh clean


# 2. Checkout and build Scorpio
    git clone -b brett/dev/grpc_play --recursive git@github.com:recogni/scorpio-fw
    cd scorpio-fw
    make setup
    cd src/scpu
    make clean;make

