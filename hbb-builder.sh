#!/usr/bin/env bash

set -e

source /hbb_shlib/activate

set -x
# --std=c++11 -nodefaultlibs -lc++ -lc++abi -lm -lc -lgcc_s -lgcc
mkdir -p /io/build
cd /io/build
#  --std=c++11 -nostdinc++ -I/usr/local/include/c++/v1
#  -DCMAKE_EXE_LINKER_FLAGS="-L/hbb_shlib/lib -static-libstdc++ -Wl,--verbose"
unset LDFLAGS
cmake -DCMAKE_PREFIX_PATH=/hbb_exe -DCMAKE_C_FLAGS="-I/hbb_shlib/include" -DCMAKE_CXX_FLAGS="-I/hbb_shlib/include" -G "Ninja" .. && cmake --build . --target TerraExecutable

