Stand alone linux grpc cross compile for riscv:

git clone -b recogni https://github.com/recogni/grpc
cd grpc
git submodule update --init

Edit test/distrib/cpp/run_distrib_test_riscv.sh
  set RISCV_TOOLCHAIN=your_toolchain_location_

sudo test/distrib/cpp/run_distrib_test_riscv.sh
or
sudo test/distrib/cpp/run_distrib_test_riscv.sh clean

