#!/bin/env bash

purge() {
  echo "Purging path '${SKPR_PATH}' on environment '${SKPR_ENV}..."
  docker run --rm \
          -v "$(pwd):$(pwd)" \
          -w "$(pwd)" \
          -e SKPR_USERNAME="${SKPR_USERNAME}" \
          -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
          "${SKPR_CLI_DOCKER_IMAGE}" \
          skpr purge create "${SKPR_ENVIRONMENT}" "${SKPR_PATH}";
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
	purge
fi