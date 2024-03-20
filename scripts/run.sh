#!/usr/bin/env bash
set -e

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )
BUILD="build"
EXE="wos"

# If not already inside enter the container
source "$DIR/scripts/run-in-container.sh"
run_self_in_container "$@"

# Qemu doesn't seem to like -audio or -audiodev so set the driver to none so it stays somewhat quiet
export QEMU_AUDIO_DRV=none

echo "Press Ctrl+A and then X to exit QEMU"
qemu-system-arm -M versatilepb -m 128M -nographic -kernel "$DIR/$BUILD/$EXE"

