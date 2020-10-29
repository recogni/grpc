

This describes different ways to (attempt to) build grpc:
    1) Vanilla: Build vanilla grpc helloworld libraries and executable binaries for either riscv linux or x86 linux.  No relation to FreeRTOS or scorpio.
    2) Hybrid: Build linux based grpc libs but try to link with scorpio/FreeRTOS to see what linux APIs are missing.
    3) Newlib: Build newlib based grpc libs and try to link with scoprio/freertos. This is what we need to make work.

Build vanilla linux executables for either x86 or riscv:
==========================================================
  mkdir ~/grpc_tree
  cd ~/grpc_tree
  git clone -b recogni --recurse-submodules https://github.com/recogni/grpc
  cd grpc/
  test/distrib/cpp/run_distrib_test_x86.sh clean           # Build x86 version. Builds, runs, functions

  edit test/distrib/cpp/run_distrib_test_riscv.sh
     > set RISCV_TOOLCHAIN=your_riscv_crosscompile_toolchain_location

  test/distrib/cpp/run_distrib_test_riscv.sh clean linux   # Build riscv version.  Unable to run or test (since no riscv linux machine)

Hybrid: Build riscv/linux grpc libraries and try to link them with
FreeRTOS/scorpio to see what Linux APIs are missing from FreeRTOS.
==================================================================

# Checkout and build grpc_play branch of Scorpio which has the grpc_server code under scorpio:
  mkdir ~/scorpio
  cd ~/scorpio
  git clone -b brett/dev/grpc_play --recursive git@github.com:recogni/scorpio-fw
  cd scorpio-fw
  make setup

  Edit src/scpu/rtos/grpc_server/Makefile
      set GRPC_DIR = ~/grpc_tree/grpc  # Point to grpc directory in step 1.

  cd src/scpu
  make clean
  make 2>&1 | grep undefined | grep -v scorpio-fw-gcc | cut -d':' -f3-  | sort | uniq 

# To verify the grpc libraries in the above are correct we can build a riscv Linux greeter_server executable
# (unfortunatly we don't have a rsicv based linux machine to run it on):

  cd src/scpru/rtos/grpc_server
  make; make exe

# Can also build an x86 based linux executable that we can run and test:
# (Still in src/scpru/rtos/grpc)

  Edit Makefile:
    set PROC = x86 (instead of riscv)
  make;make exe


Newlib: Build grpc libs against FreeRTOS and scorpio using newlib 
(riscv64-unknown-elf-gcc vs riscv64-unknown-linux-gnu-gcc)
This uses 'use_libs' scorpio branch.
==========================================================

# Step 1: Build library based scorpio (Note: using different branch):
  mkdir ~/scorpio_use_libs
  cd ~/scorpio_use_libs
  git clone -b brett/dev/use_libs --recursive git@github.com:recogni/scorpio-fw
  cd scorpio-fw
  make setup

  cd src/scpu
  make clean;make

# Step 2: In your grpc tree:
  edit test/distrib/cpp/run_distrib_test_riscv.sh
     > set RISCV_TOOLCHAIN=your_riscv_crosscompile_toolchain_location
     > set SCORPIO_TREE=scorpio_tree_just created/scorpio-fw

  test/distrib/cpp/run_distrib_test_riscv.sh clean newlib 

  This will not complete due to various errors....


