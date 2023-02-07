#!/usr/env bash

stackhawk_configure() {

  if [ "${PARAM_ID}" == "" ]; then
    echo "Application ID was not provided.";
  fi

  if [ "${PARAM_ENV}" == "" ]; then
    echo "Application Environment was not provided.";
  fi

  if [ "${PARAM_HOST}" == "" ]; then
    echo "Application Endpoint was not provided.";
  fi

  echo "Creating configuration file at: $(pwd)/stackhawk.yml";
  echo "{'app': {'applicationId': '${PARAM_ID}', 'env': '${PARAM_ENV}', 'host': '${PARAM_HOST}'}}" | yq --yaml-output > ./stackhawk.yml;
  cat ./stackhawk.yml;

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    stackhawk_configure
fi
