#!/bin/env bash

restore() {
	SKPR_BACKUP=$(skpr backup list "${SKPR_SOURCE}" --json | jq -r '[.][0][0].Name')
	if $? -gt 0; then
		echo "Failed to get name of most recent backup"
		exit 1
	fi
	# shellcheck disable=SC2086
	echo "export SKPR_BACKUP=${SKPR_BACKUP}" >>$BASH_ENV

	# shellcheck disable=SC2086
	skpr restore create ${SKPR_TARGET} ${SKPR_BACKUP}
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
	restore
fi