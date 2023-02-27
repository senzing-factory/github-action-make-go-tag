#!/bin/sh
set -eu

# Reference: https://github.com/rickstaa/action-create-tag/blob/main/entrypoint.sh

# Apply hotfix for 'fatal: unsafe repository' error.
git config --global --add safe.directory "${GITHUB_WORKSPACE}"

cd "${GITHUB_WORKSPACE}" || exit

git checkout main
git pull
export GIT_SHA=$(git rev-list -n 1 ${GITHUB_REF_NAME})

env

git tag -a "v${GIT_TAG}" -m "Go module tag for version ${GITHUB_REF_NAME} by ${GITHUB_ACTOR}" ${GIT_SHA}
git push origin --tags
