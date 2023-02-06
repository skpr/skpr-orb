# shellcheck disable=SC2120,SC2148
trivy_image_scan() {

  if [ "${PARAM_TYPE}" == "" ]; then
    echo "Input file path has not been set.";
    exit 1;
  fi

  if [ "${PARAM_TYPE}" == "compile" ]; then
    cat < skpr-manifest.json | jq -c ".[]" | jq "select(.type == \"compile\")" | jq  '.tag' -r | xargs -n1 trivy image $1;
  fi

  if [ "${PARAM_TYPE}" == "runtime" ]; then
    cat < skpr-manifest.json | jq -c ".[]" | jq "select(.type == \"runtime\")" | jq  '.tag' -r | xargs -n1 trivy image $1;
  fi

  if [ ! "${PARAM_TYPE}" == "compile" ] && [ ! "${PARAM_TYPE}" == "runtime" ]; then
    echo "Invalid image category.";
    exit 1;
  fi

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    trivy_image_scan
fi