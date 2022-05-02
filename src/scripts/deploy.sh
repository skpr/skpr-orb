deploy() {
    if [ -n "${CIRCLE_TAG}" ]; then
      # shellcheck disable=SC2086
      echo "export SKPR_VERSION=$CIRCLE_TAG" >> $BASH_ENV
    elif [ -z "${SKPR_VERSION}" ]; then
        SKPR_VERSION=$(git describe --tags --always)
        # shellcheck disable=SC2086
        echo "export SKPR_VERSION=$SKPR_VERSION" >> $BASH_ENV
    fi
    echo "Deploying version: ${SKPR_VERSION}"
    # shellcheck disable=SC2086
    skpr deploy ${SKPR_ENV} ${SKPR_VERSION}
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    deploy
fi
