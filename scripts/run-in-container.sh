#!/bin/bash

BUILD_IMAGE="${BUILD_IMAGE:-trevorbrunette/wos-build}"

__container_cmd=""
__script_dir="$(dirname "${BASH_SOURCE[0]}")"
__repo_path="$(realpath -- "$__script_dir/..")"

if [ -z "$__repo_path" ]; then
  echo "Failed to determine the path to the current repo (see above error)"
  exit 1
fi

# Check the path for a suitable container runtime
if [ -n "$CONTAINER_RUNTIME" ]; then
  __container_cmd="$CONTAINER_RUNTIME"
elif command -v podman &>/dev/null; then
  __container_cmd="podman"
elif command -v docker &>/dev/null; then
  __container_cmd="docker"
fi


build_container() {
  local current="$(git rev-parse HEAD)"

  # Parse the label of the current image
  local built="$(
    "$__container_cmd" image inspect "$BUILD_IMAGE" 2>/dev/null | \
    grep -Po 'pro.trevor.wos.hash":\s*\"\K[^"]+' | \
    head -1 || :)"

  # Only build the container if forced to or if the git hash changes.  This
  # allows users to get updates when they merge but not rebuild the container
  # on every single build.
  if [ "$current" != "$built" ] || [ -n "$FORCE_REBUILD" ]; then
    "$__container_cmd" build -t "$BUILD_IMAGE" \
      --label "pro.trevor.wos.hash=$current" \
       "$__repo_path/scripts/container" || return $?
  fi
}


run_in_container() {
  if [ -z "$__container_cmd" ] || [ -n "$DISABLE_CONTAINER_BUILD" ]; then
    echo "Could not find docker or podman or containerized builds were disabled with DISABLE_CONTAINER_BUILD.  Executing outside the container."
    export RUNNING_IN_CONTAINER=1  # Don't try to rerun in the container if run_self_in_container is called
    exec "$@" # no return
  fi

  build_container

  local container_args="--rm --init"

  # If stdout and stderr are terminals run docker interactively
  if [ -t 1 ] && [ -t 2 ]; then
    container_args+=" -it"
  fi

  # Remap the host path exactly so tools like git worktrees still work
  container_args+=" -v $__repo_path:$__repo_path"
  container_args+=" -w $(pwd)"

  container_args+=" -e RUNNING_IN_CONTAINER=1 -e CONTAINER_DEBUG"

  # Pass through environment variables used by scripts
  container_args+=" -e FORCE_REBUILD"

  "$__container_cmd" run $container_args "$BUILD_IMAGE" "$@" || return $?
}


# Run the current process in the docker container (if it isn't currently)
# Usage: run_self_in_container "$@"
run_self_in_container() {
  if [ -z "$RUNNING_IN_CONTAINER" ]; then
    run_in_container "$0" "$@"
    exit $?
  fi
}


# If we're running standalone run the command we're passed in the container
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
  run_in_container "$@" || exit $?
fi
