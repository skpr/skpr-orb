#!/bin/env bash

deploy() {
    if [ -z "${SKPR_VERSION}" ]; then
        if [ -z "${CIRCLE_TAG}" ]; then
          echo "Falling back to 'git describe' to determine version."
          SKPR_VERSION=$(git describe --tags --always)
        else
          echo "Using 'CIRCLE_TAG' to determine version."
          SKPR_VERSION=${CIRCLE_TAG}
        fi
        echo "export SKPR_VERSION=$SKPR_VERSION" >> "${BASH_ENV}"
    fi
    echo "Deploying version: ${SKPR_VERSION}"
    docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "$(pwd):$(pwd)" \
            -w "$(pwd)" \
            -e SKPR_USERNAME="${SKPR_USERNAME}" \
            -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
            "${SKPR_CLI_DOCKER_IMAGE}" \
            skpr deploy "${SKPR_ENV}" "${SKPR_VERSION}";
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    deploy
fi
