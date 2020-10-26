# Building grpc with FreeRTOS

#  Checkout grpc tree and build grpc libs

The run_distrib_test_riscv.sh script below will install cmake for you if needed but
some other pre-reqs may still be missing....

#1  Checkout and build a library based Scorpio
    mkdir ~/my_scorpio_dir
    cd ~/my_scorpio_dir
    git clone -b brett/dev/use_libs --recursive git@github.com:recogni/scorpio-fw
    cd scorpio-fw
    make setup

    pushd modules/littlefs
    git checkout brett/dev/build_as_library
    popd

    cd src/scpu
    make clean;make


#2  Clone and build grpc tools and cross compile:
    mkdir ~/grpc_tree; cd ~/grpc_tree
    git clone --recurse-submodules -b recogni https://github.com/recogni/grpc
    cd grpc

    Edit test/distrib/cpp/run_distrib_test_riscv.sh:
      set RISCV_TOOLCHAIN=your_riscv_crosscompile_toolchain_location_
      set SCORPIO_TREE to your scorpio build tree (~/my_scorpio_dir)

    test/distrib/cpp/run_distrib_test_riscv.sh clean


