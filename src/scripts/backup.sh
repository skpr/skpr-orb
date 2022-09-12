#!/bin/env bash

backup() {
	# shellcheck disable=SC2086
	skpr backup create --wait ${SKPR_TARGET}
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
	backup
fi
