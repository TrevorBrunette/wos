#!/usr/bin/env bash
set -e

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )

# If not already inside enter the container
source "$DIR/scripts/run-in-container.sh"
run_self_in_container "$@"

BUILD="build"

mkdir -p "$DIR/$BUILD"
cd "$DIR/$BUILD"

if [ -n "$FORCE_REBUILD" ]; then
    rm -r ./**
fi

# Configure CMake if we haven't already
if [ ! -f build.ninja ]; then
    cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake ../
fi

ninja
