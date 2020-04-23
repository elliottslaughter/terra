#!/bin/bash

set -e

IFS=- read distro release <<< "$1"
if [[ -n $2 ]]; then
    tag="-t terralang/terra:$2"
fi

docker build --build-arg release=$release $tag -f docker/Dockerfile.$distro .
