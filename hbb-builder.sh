#!/usr/bin/env bash

set -e

source /hbb_shlib/activate

set -x
# --std=c++11 -nodefaultlibs -lc++ -lc++abi -lm -lc -lgcc_s -lgcc
mkdir -p /io/build
cd /io/build
cmake -DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CXXFLAGS --std=c++11 -nostdinc++ -I/usr/local/include/c++/v1" -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS -pthread" -G "Ninja" .. && cmake --build . --target TerraExecutable

