#!/bin/env bash

backup() {
	# shellcheck disable=SC2086
	if [[ "$SKPR_CLI_USE_DOCKER_IMAGE" = "true" ]]
	then
		docker run -it \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(pwd):$(pwd) \
            -w $(pwd) \
            -e SKPR_USERNAME=$SKPR_USERNAME \
            -e SKPR_PASSWORD=$SKPR_PASSWORD \
            skpr/cli:${SKPR_CLI_DOCKER_IMAGE} \
            skpr mysql image pull dev
	else
		skpr mysql image pull ${SKPR_ENVIRONMENT}
	fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
	backup
fi
