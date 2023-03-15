#!/bin/env bash

info() {
    echo "Getting Skpr info for $SKPR_ENV"
    docker run --rm \
            -v "$(pwd):$(pwd)" \
            -w "$(pwd)" \
            -e SKPR_USERNAME="${SKPR_USERNAME}" \
            -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
            "${SKPR_CLI_DOCKER_IMAGE}" \
            skpr info "${SKPR_ENV}" > info.json;
    SKPR_DOMAIN=$(cat < info.json | jq -r ".Ingress.Domain")
    SKPR_URL="https://${SKPR_DOMAIN}"
    echo "Skpr URL: $SKPR_URL"
    echo "export SKPR_URL=$SKPR_URL" >> "${BASH_ENV}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    info
fi
