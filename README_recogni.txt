# Building grpc with FreeRTOS

#  1. Checkout grpc tree and build grpc libs

The run_distrib_test_riscv.sh script below will install cmake for you if needed but
some other pre-reqs may still be missing....

# Clone and build grpc tools and cross compile:
    git clone -b recogni https://github.com/recogni/grpc
    cd grpc
    git submodule update --init
    Edit test/distrib/cpp/run_distrib_test_riscv.sh
      set RISCV_TOOLCHAIN=your_riscv_crosscompile_toolchain_location_

    test/distrib/cpp/run_distrib_test_riscv.sh clean


# 2. Checkout and build Scorpio
    git clone -b brett/dev/grpc_play --recursive git@github.com:recogni/scorpio-fw
    cd scorpio-fw
    make setup

    # Attempt to build scpu image with grpc.
    # This build fails for now at the final link stage becasue its essentially trying
    # to build grpc for linux but link with our FreeRTOS, hence all Linux related
    # system calls will be unresolved.

    cd src/scpu
    make clean;make

    #However, to successfully build a riscv *Linux* version of grpc server,
    # you can do this:

    cd src/scpru/rtos/grpc
    make; make exe
