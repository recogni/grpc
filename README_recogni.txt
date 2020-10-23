# Building grpc with FreeRTOS

#  Checkout grpc tree and build grpc libs

The run_distrib_test_riscv.sh script below will install cmake for you if needed but
some other pre-reqs may still be missing....

#1  Clone and build grpc tools and cross compile:
    mkdir ~/grpc_tree; cd ~/grpc_tree
    git clone --recurse-submodules -b recogni https://github.com/recogni/grpc
    cd grpc
    Edit test/distrib/cpp/run_distrib_test_riscv.sh
      set RISCV_TOOLCHAIN=your_riscv_crosscompile_toolchain_location_
      set SCORPIO_TREE to your scorpio build tree

    test/distrib/cpp/run_distrib_test_riscv.sh clean


#2  Checkout and build Scorpio
    mkdir ~/scorpio;cd ~/scorpio
    git clone -b brett/dev/grpc_play --recursive git@github.com:recogni/scorpio-fw
    cd scorpio-fw
    make setup

    Edit src/scpu/rtos/grpc_server/Makefile
      set GRPC_DIR = ~/grpc_tree/grpc  # Point to grpc directory in step 1.

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
