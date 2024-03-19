#!/bin/bash

debug() {
    if [ -n "$CONTAINER_DEBUG" ]; then
        echo "$@"
    fi
}

# Add our scripts to the path to make life easier
if [ -d "$(pwd)/scripts" ]; then
    export PATH="$(pwd)/scripts:$PATH"
fi

# If we weren't given a command run bash
if [ $# -eq 0 ]; then
    set -- "/bin/bash"
fi

# When running as root files created by the docker container are owed by root outside of the container
# When running in rootless mode files created by "root" in the container are owned by the correct user outside the container
# To make both cases work if our current uid doesn't match the owner of the repo create a user that does and run as them
file_uid="$(stat -c %u .)"
file_gid="$(stat -c %g .)"

debug "$(pwd) is owned by uid=$file_uid gid=$file_gid"

if [ "$file_uid" != "$(id -u)" ]; then
    CONTAINER_USER="wos"

    debug "Creating and running as $CONTAINER_USER"

    # Create a group and user for running our builds
    groupadd -g "${file_gid}" "${CONTAINER_USER}"
    useradd -u "${file_uid}" -g "${file_gid}" "${CONTAINER_USER}"

    echo "$CONTAINER_USER ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/wos
    chmod 400 /etc/sudoers.d/wos

    exec gosu "${CONTAINER_USER}" "$@"
fi

exec "$@"
