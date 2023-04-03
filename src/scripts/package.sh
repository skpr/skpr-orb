#!/bin/env bash

package() {
    if [ ! "${PARAM_PACKAGE_SKIP}" == "1" ]; then
      echo "Packaging version: ${SKPR_VERSION}"
      docker run --rm \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v "$(pwd):$(pwd)" \
              -w "$(pwd)" \
              -e SKPR_USERNAME="${SKPR_USERNAME}" \
              -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
              "${SKPR_CLI_DOCKER_IMAGE}" \
              skpr package "${SKPR_VERSION}" --print-manifest > skpr-manifest.json;
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    package
fi
