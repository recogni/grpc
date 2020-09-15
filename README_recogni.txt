Stand alone linux grpc cross compile for riscv:

git clone -b recogni https://github.com/recogni/grpc
cd grpc
git submodule update --init
sudo test/distrib/cpp/run_distrib_test_riscv.sh

