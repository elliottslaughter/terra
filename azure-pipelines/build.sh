#!/bin/bash

set -e
set -x

if [[ $(uname) = Linux ]]; then
    cat /etc/lsb-release

    export LLVM_CONFIG=llvm-config-$LLVM_VER
    export CLANG=clang-$LLVM_VER

    sudo apt-get update -qq
    sudo apt-get install -qq build-essential cmake git software-properties-common wget
    sudo apt-get install -qq libncurses5-dev zlib1g-dev # FIXME: https://github.com/zdevito/terra/issues/307
fi

./travis.sh
