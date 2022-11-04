package() {
    if [ -z "${SKPR_VERSION}" ]; then
        if [ -z "${CIRCLE_TAG}" ]; then
          echo "Falling back to 'git describe' to determine version."
          SKPR_VERSION=$(git describe --tags --always)
        else
          echo "Using 'CIRCLE_TAG' to determine version."
          SKPR_VERSION=${CIRCLE_TAG}
        fi
        # shellcheck disable=SC2086
        echo "export SKPR_VERSION=$SKPR_VERSION" >> $BASH_ENV
    fi
    echo "Packaging version: ${SKPR_VERSION}"
    # shellcheck disable=SC2086
    skpr package ${SKPR_VERSION}
    if [ "${PARAM_TRIVY}" == "true" ];
      skpr package ${SKPR_VERSION} --no-push --print-manifest > manifect.json
      cat manifest.json | jq -c '.[] | select(.type == "runtime") | .tag' -r | xargs -i  sh -c 'trivy image {} --format=json'
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    package
fi
