#!/bin/env bash

restore() {
  # Get Backups
  docker run --rm \
          -v "$(pwd):$(pwd)" \
          -w "$(pwd)" \
          -e SKPR_USERNAME="${SKPR_USERNAME}" \
          -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
          "${SKPR_CLI_DOCKER_IMAGE}" \
          skpr backup list "${SKPR_SOURCE}" --json > backups.json;

	SKPR_BACKUP=$(cat < backups.json | jq -r '[.][0][0].Name')
	if $? -gt 0; then
		echo "Failed to get name of most recent backup"
		exit 1
	fi

  docker run --rm \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v "$(pwd):$(pwd)" \
          -w "$(pwd)" \
          -e SKPR_USERNAME="${SKPR_USERNAME}" \
          -e SKPR_PASSWORD="${SKPR_PASSWORD}" \
          "${SKPR_CLI_DOCKER_IMAGE:-skpr/cli:latest}" \
          skpr restore create --wait "${SKPR_TARGET}" "${SKPR_BACKUP}";
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
	restore
fi
