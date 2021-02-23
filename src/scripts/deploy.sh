deploy() {
    if [ -z "${SKPR_VERSION}" ]; then
        SKPR_VERSION=$(git describe --tags --always)
        echo "export SKPR_VERSION=$SKPR_VERSION" >> $BASH_ENV
    fi
    echo "Packaging version: ${SKPR_VERSION}"
    skpr deploy ${SKPR_ENV} ${SKPR_VERSION}
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    package
fi
