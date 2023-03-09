#!/bin/env bash

trivy_file_scan() {

  if [ "${PARAM_FILE}" == "" ]; then
    echo "Input file path has not been set.";
    exit 1;
  fi

  if [ ! -f "${PARAM_FILE}" ]; then
    echo "Input file does not exist at path: ${PARAM_FILE}";
  fi

  docker run --rm \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v "$(pwd):$(pwd)" \
          -w "$(pwd)" \
          -e SKPR_USERNAME="${SKPR_USERNAME}" \
          -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
          "${SKPR_CLI_DOCKER_IMAGE}" \
          trivy fs "${PARAM_FILE}";

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    trivy_file_scan
fi
