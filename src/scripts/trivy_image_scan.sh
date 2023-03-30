#!/bin/env bash

# shellcheck disable=SC2120,SC2148
trivy_image_scan() {

  if [ "${PARAM_TYPE}" == "" ]; then
    echo "Input file path has not been set.";
    exit 1;
  fi

  if [ "${PARAM_TYPE}" == "compile" ] || [ "${PARAM_TYPE}" == "runtime" ]; then
    cat < "skpr-manifest-${PARAM_TYPE}.json" | jq -c ".[]" | jq "select(.type == \"${PARAM_TYPE}\")" | jq  '.tag' -r > "manifest-target-${PARAM_TYPE}.txt"
    while IFS= read -r line
    do
      docker run --rm \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v "$(pwd):$(pwd)" \
              -w "$(pwd)" \
              -e SKPR_USERNAME="${SKPR_USERNAME}" \
              -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
              "${SKPR_CLI_DOCKER_IMAGE}" \
              trivy image "${line}";
    done < "manifest-target-${PARAM_TYPE}.txt"
  fi

  if [ ! "${PARAM_TYPE}" == "compile" ] && [ ! "${PARAM_TYPE}" == "runtime" ]; then
    echo "Invalid image category.";
    exit 1;
  fi

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    trivy_image_scan
fi