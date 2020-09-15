Stand alone linux grpc cross compile for riscv:

git clone -b recogni https://github.com/recogni/grpc
cd grpc
git submodule update --init

# Edit test/distrib/cpp/run_distrib_test_riscv.sh to set RISCV_TOOLCHAIN=
# to your toolchain location.

sudo test/distrib/cpp/run_distrib_test_riscv.sh

