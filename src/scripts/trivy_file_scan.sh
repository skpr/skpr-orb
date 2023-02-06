trivy_file_scan() {

  if [ "${PARAM_FILE}" == "" ]; then
    echo "Input file path has not been set.";
    exit 1;
  fi

  if [ ! -f "${PARAM_FILE}" ]; then
    echo "Input file does not exist at path: ${PARAM_FILE}";
  fi

  trivy fs "${PARAM_FILE}";

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    trivy_file_scan
fi
