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
    skpr package "${SKPR_VERSION}" --print-manifest > manifest.json

    if [ "${PARAM_TRIVY}" == "true" ]; then

      # Check if both Trivy options are set.
      if [ ! "${PARAM_TRIVY_FILE}" == "" ] && [ ! "${PARAM_TRIVY_IMAGE}" == "" ]; then
        echo "Image and File system values have been set, please call the Skpr orb with only one.";
        exit 1;
      fi

      # Check if both Trivy options are empty/unset.
      if [ "${PARAM_TRIVY_FILE}" == "" ] && [ "${PARAM_TRIVY_IMAGE}" == "" ]; then
        echo "No configuration value has been set, applying defaults...";
        PARAM_TRIVY_IMAGE="runtime"
      fi

      # Perform file scanning
      if [ ! "${PARAM_TRIVY_FILE}" == "" ]; then
          if [ ! -f "${PARAM_TRIVY_FILE}" ]; then
            echo "Input file does not exist at path: ${PARAM_TRIVY_FILE}";
          fi
          sh -c "trivy fs ${PARAM_TRIVY_FILE}";
      fi

      # Perform image scanning
      if [ ! "${PARAM_TRIVY_IMAGE}" == "" ]; then
        # Validate input options
        if [ ! "${PARAM_TRIVY_IMAGE}" == "compile" ] && [ ! "${PARAM_TRIVY_IMAGE}" == "runtime" ]; then
          echo "Invalid value specified for image reference, expected 'compile' or runtime' but got '${PARAM_TRIVY_IMAGE}'.";
        fi
        # Scan the image.
        cat < manifest.json | jq -c ".[]" | jq "select(.type == \"${PARAM_TRIVY_IMAGE}\")" | jq  '.tag' -r | xargs -n1 sh -c "trivy image $0";
      fi
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    package
fi
