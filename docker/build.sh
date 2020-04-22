#!/bin/bash

set -e

IFS=- read distro release <<< "$1"

if [[ $distro = 14.04 ]]; then
    docker build --build-arg release=$release -t terralang/terra:$distro-$release -f docker/Dockerfile.$distro-upstream .
else
    docker build --build-arg release=$release -t terralang/terra:$distro-$release -f docker/Dockerfile.$distro .
fi
