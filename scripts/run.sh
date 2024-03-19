#!/usr/bin/env bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
BUILD="build"
EXE="wos"

echo "Press Ctrl+A and then X to exit QEMU"

qemu-system-arm -M versatilepb -m 128M -nographic -kernel "$DIR/$BUILD/$EXE"
