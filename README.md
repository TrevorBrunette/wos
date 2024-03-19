## Building and running

1. Install `docker` or `podman`
2. Build it `./scripts/build.sh`
3. Run it `./scripts/run.sh`

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
