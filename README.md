# WesternOS

A toy kernel and operating system.

## Installation

Install `qemu qemu-system-aarch64 arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib cmake ninja`

## Execution

Run `scripts/build.sh` to build the kernel binary

Run `scripts/run.sh` to run the kernel in QEMU

## Build container environment variables

The following environment variables control the container.

Variable | Description
----|----
CONTAINER_RUNTIME | Path to/command to use as the container runtime
BUILD_IMAGE | The tag to use for the docker image
FORCE_REBUILD | Rebuild the container everytime (also removes build files)
DISABLE_CONTAINER_BUILD | Run scripts on the host not in the container

Example:

```
FORCE_REBUILD=1 ./scripts/build.sh
```
