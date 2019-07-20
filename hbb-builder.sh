#!/usr/bin/env bash

set -e

source /hbb_shlib/activate

set -x
# --std=c++11 -nodefaultlibs -lc++ -lc++abi -lm -lc -lgcc_s -lgcc
mkdir -p /io/build
cd /io/build
#  --std=c++11 -nostdinc++ -I/usr/local/include/c++/v1
cmake -DCMAKE_PREFIX_PATH=/hbb_exe -DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS" -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" -G "Ninja" .. && cmake --build . --target TerraExecutable

