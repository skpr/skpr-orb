#!/usr/env bash

stackhawk_scan() {

  if [ ! "${PARAM_KEY}" == "" ]; then

    docker run --rm --detach -v /root/project/ --name data alpine:3.4 sleep 30;
    docker cp /root/project/stackhawk.yml data:/stackhawk.yml;
    docker run --rm -e API_KEY=$PARAM_KEY --volumes-from=data --name=stackhawk stackhawk/hawkscan:latest --repo-dir=/;

  else
    echo "API key was not provided."
  fi

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    stackhawk_scan
fi
