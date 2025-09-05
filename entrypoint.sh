#!/usr/bin/env bash
set -e

# Apply hotfix for 'fatal: unsafe repository' error.

git config --global --add safe.directory "${GITHUB_WORKSPACE}"

# Required git configuration.

# Configure git and gpg if GPG key is provided.
if [ -n "${GPG_PRIVATE_KEY}" ]; then
  # Import the GPG key.
  echo "[INFO] Importing GPG key."
  echo "${GPG_PRIVATE_KEY}" | gpg --batch --yes --import

  # If GPG_PASSPHRASE is set, unlock the key.
  if [ -n "${GPG_PASSPHRASE}" ]; then
    echo "[INFO] Unlocking GPG key."
    echo "${GPG_PASSPHRASE}" | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 --output /dev/null --sign
  fi

  # Retrieve GPG key information.
  public_key_id=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | cut -d'/' -f2)
  signing_key_email=$(gpg --list-keys --keyid-format=long "${public_key_id}" | grep uid | sed 's/.*<\(.*\)>.*/\1/')
  signing_key_username=$(gpg --list-keys --keyid-format=long "${public_key_id}" | grep uid | sed 's/uid\s*\[\s*.*\]\s*//; s/\s*(.*//')

  # Setup git user name, email, and signing key.
  echo "[INFO] Setup git user name, email, and signing key."
  git config --global user.name "${signing_key_username}"
  git config --global user.email "${signing_key_email}"
  git config --global user.signingkey "${public_key_id}"
  git config --global commit.gpgsign true
  git config --global tag.gpgSign true
else
  # Setup git user name and email.
  echo "[INFO] Setup git user name and email."
  git config --global user.name "${GITHUB_ACTOR}"
  git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

# Set up remote URL for token.
if [ -n "${GITHUB_TOKEN}" ]; then
  echo "[INFO] gh auth login --with-token < ${GITHUB_TOKEN}"
  gh auth login --with-token < "${GITHUB_TOKEN}"
fi

# Make the tag.

echo "[INFO] cd ${GITHUB_WORKSPACE} || exit"
cd "${GITHUB_WORKSPACE}" || exit
echo "[INFO] git tag -a v${GITHUB_REF_NAME} -m Go module tag for version ${GITHUB_REF_NAME} by ${GITHUB_ACTOR} ${GITHUB_WORKFLOW_SHA}"
git tag -a "v${GITHUB_REF_NAME}" -m "Go module tag for version ${GITHUB_REF_NAME} by ${GITHUB_ACTOR} ${GITHUB_WORKFLOW_SHA}"
git push origin "v${GITHUB_REF_NAME}"
