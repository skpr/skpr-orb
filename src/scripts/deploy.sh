#!/bin/env bash

deploy() {
    echo "Deploying version: ${SKPR_VERSION}"
    docker run --rm \
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
