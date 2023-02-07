stackhawk_scan() {

  if [ ! "${PARAM_KEY}" == "" ]; then
    docker run -e API_KEY="${PARAM_KEY}" --rm -v $(pwd):/hawk:rw -it stackhawk/hawkscan:latest
  else
    echo "API key was not provided."
  fi

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    trivy_file_scan
fi
