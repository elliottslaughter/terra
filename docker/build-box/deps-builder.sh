#!/usr/bin/env bash

echo building dependencies
set -e
source /hbb_exe/activate
set -x

#TODO: improve this check
CPUCOUNT=$(cat /proc/cpuinfo | grep siblings | head -n 1 | tr -d 'siblings\t: ')
MEMCOUNT=$(cat /proc/meminfo | grep MemAvailable | head -n 1\
           | tr -d 'MemAvailable:\t' | tr -d " kB")
MEMCOUNT=$(expr $MEMCOUNT / 6000000)
THREADS=$(printf "$CPUCOUNT\n$MEMCOUNT" | sort -n | head -n 1)
echo building on $THREADS threads


pushd ninja
python ./configure.py --bootstrap
cp ./ninja /bin/ninja
popd

mkdir -p llvm-project/build
pushd llvm-project/build
env CFLAGS="-g -O2 -I/hbb_exe/include -fPIC" CXXFLAGS="-g -O2 -I/hbb_exe/include -fPIC" LDFLAGS="-fPIC" \
  bash -c "cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS='clang;libcxx;libcxxabi' -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_STATIC_LIBS=ON -DLLVM_BUILD_TOOLS=OFF -DCMAKE_INSTALL_PREFIX=/hbb_exe -S ../llvm -B ./ \
  -DCMAKE_C_FLAGS='-g -O2 -I/hbb_exe/include -fPIC' -DCMAKE_CXX_FLAGS='-g -O2 -I/hbb_exe/include -fPIC' -DCMAKE_LD_FLAGS='-fPIC' && \
  cmake --build . -j $THREADS && \
  cmake --build . --target install"
popd

#mkdir clang-build
#pushd clang-build
#env CFLAGS="$STATICLIB_CFLAGS -fPIC" CXXFLAGS="$STATICLIB_CXXFLAGS -fPIC" LDFLAGS="-fPIC" \
#  bash -c "cmake --prefix=/hbb_exe --enable-static ../cfe-7.0.1.src && \
#  make -j8 && \
#  make install"
#popd
