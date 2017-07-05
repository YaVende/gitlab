#!/bin/bash
# If CI_COMMIT_TAG is present and is in the form vXX.XX.XX
if [[ -v CI_COMMIT_TAG && $CI_COMMIT_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo $CI_COMMIT_TAG
  exit 0

# If CI_COMMIT_REF_NAME is master
elif [[ $CI_COMMIT_REF_NAME =~ ^master$ ]]; then
  echo latest
  exit 0

# If CI_COMMIT_REF_NAME is development
elif [[ $CI_COMMIT_REF_NAME =~ ^development$ ]]; then
  echo development
  exit 0

# If CI_COMMIT_REF_NAME starts with "feature" or "release"
elif [[ $CI_COMMIT_REF_NAME =~ ^(feature|release)/.+$ ]]; then
  # Replace slashes with hyphens and return it
  echo $CI_COMMIT_REF_NAME | sed 's/\//_/g'
  exit 0
fi

exit 1
