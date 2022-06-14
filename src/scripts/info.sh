info() {
    # shellcheck disable=SC2086
    if [ ! -z "${SKPR_WORKDIR}" ]; then
      cd ${SKPR_WORKDIR};
    fi
    echo "Getting Skpr info for $SKPR_ENV"
    SKPR_DOMAIN=$(skpr info $SKPR_ENV | jq -r ".Ingress.Domain")
    SKPR_URL="https://$SKPR_DOMAIN"
    echo "Skpr URL: $SKPR_URL"
    echo "export SKPR_URL=$SKPR_URL" >> $BASH_ENV
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    info
fi
