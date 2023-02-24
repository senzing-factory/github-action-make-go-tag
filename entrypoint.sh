#!/bin/sh
set -eu

# Reference: https://github.com/rickstaa/action-create-tag/blob/main/entrypoint.sh

# Apply hotfix for 'fatal: unsafe repository' error (see #10).
git config --global --add safe.directory "${GITHUB_WORKSPACE}"

cd "${GITHUB_WORKSPACE}" || exit

export GIT_SHA=$(git rev-list -n 1 ${GIT_TAG})
git tag -a "v${GIT_TAG}" -m "Go module tag for version ${GIT_TAG}" ${GIT_SHA}
git push origin --tags
