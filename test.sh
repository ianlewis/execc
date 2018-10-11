#!/bin/bash -eu

run_shellcheck() {
    if [ -x "$(command -v shellcheck)" ]; then
        shellcheck $@
    else
        # if this session isn't interactive, then we don't want to allocate a
        # TTY, which would fail, but if it is interactive, we do want to attach
        # so that the user can send e.g. ^C through.
        DOCKER_FLAGS=""
        if [[ $- == *i* ]]; then
            DOCKER_FLAGS="${DOCKER_FLAGS} -t"
        fi

        docker run --rm -i ${DOCKER_FLAGS} \
                --name df-shellcheck \
                -v $(pwd):/mnt:ro \
                -w /mnt \
                gcr.io/ianlewis-dockerfiles/shellcheck \
                $@
    fi
}

run_shellcheck execc
