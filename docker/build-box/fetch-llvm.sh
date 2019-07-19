#!/usr/bin/env bash

# git clone -q -b release_70  https://github.com/llvm-mirror/llvm llvm
# git clone -q -b release_70  https://github.com/llvm-mirror/clang llvm/tools/clang
# git clone -q -b release_70  https://github.com/llvm-mirror/clang-tools-extra llvm/tools/clang/tools/extra
# git clone -q -b release_70  https://github.com/llvm-mirror/compiler-rt llvm/projects/compiler-rt
# git clone -q -b release_70  https://github.com/llvm-mirror/libcxx llvm/projects/libcxx
# git clone -q -b release_70  https://github.com/llvm-mirror/libcxxabi llvm/projects/libcxxabi
# git clone -q -b release_70  https://github.com/llvm-mirror/lld llvm/tools/lld

git clone -b release https://github.com/ninja-build/ninja

git clone -q -b release/7.x https://github.com/llvm/llvm-project.git
