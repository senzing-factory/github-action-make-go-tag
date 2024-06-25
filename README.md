# github-action-make-go-tag

## Synopsis

From a [Semantic Version],
create a Go module tag.

## Overview

This repository is a GitHub Workflow that makes
a tag in the format "vM.m.P", which is a [Semantic Version]
prefixed with "v", whenever a semantically versioned tag is created.

**Note:** As itself, "v0.0.0" is not a semantic version. See
[Is “v1.2.3” a semantic version?]

## Use

1. To use, create a `.github/workflows/make-go-tag.yaml` file with the following contents:

    ```yaml
    name: make-go-tag.yaml

    on:
      push:
        tags:
          - "[0-9]+.[0-9]+.[0-9]+"

    jobs:
      build:
        name: Make a vM.m.P tag
        runs-on: ubuntu-latest
        steps:
          - name: Checkout repository
            uses: actions/checkout@v3
          - name: Make go version tag
            uses: senzing-factory/github-action-make-go-tag@v2
    ```

## References

1. GitHub workflow
    1. [Documentation]
    1. [GitHub actions]

[Documentation]: https://docs.github.com/en/rest/reference/actions
[GitHub actions]: https://github.com/features/actions
[Is “v1.2.3” a semantic version?]: https://semver.org/#is-v123-a-semantic-version
[Semantic Version]: https://semver.org/
