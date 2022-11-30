package() {
  # Check if both Trivy options are set.
  if [ ! "${PARAM_FILE}" == "" ] && [ ! "${PARAM_IMAGE}" == "" ]; then
    echo "Image and File system values have been set, please call the Skpr orb with only one.";
    exit 1;
  fi

  # Check if both Trivy options are empty/unset.
  if [ "${PARAM_FILE}" == "" ] && [ "${PARAM_IMAGE}" == "" ]; then
    echo "No configuration value has been set, applying defaults...";
    PARAM_IMAGE="runtime"
  fi

  # Perform file scanning
  if [ ! "${PARAM_FILE}" == "" ]; then
      if [ ! -f "${PARAM_FILE}" ]; then
        echo "Input file does not exist at path: ${PARAM_FILE}";
      fi
      trivy fs "${PARAM_FILE}";
  fi

  # Perform image scanning
  if [ ! "${PARAM_IMAGE}" == "" ]; then
    # Validate input options
    if [ ! "${PARAM_IMAGE}" == "compile" ] && [ ! "${PARAM_IMAGE}" == "runtime" ]; then
      echo "Invalid value specified for image reference, expected 'compile' or runtime' but got '${PARAM_IMAGE}'.";
    fi
    # Scan the image.
    cat < skpr-manifest.json | jq -c ".[]" | jq "select(.type == \"${PARAM_IMAGE}\")" | jq  '.tag' -r | xargs -n1 trivy image $1;
  fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    package
fi
