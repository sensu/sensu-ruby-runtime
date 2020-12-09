#!/bin/bash

if [ -z "$TAG" ]; then exit 0; fi

git clone https://github.com/sensu/sensu-go-bonsai-asset.git bonsai

for archive in dist/*.tar.gz; do
    bonsai/github-release-upload.sh github_api_token=$GITHUB_TOKEN repo_slug="$REPO_SLUG" tag="${TAG}" filename="$archive"
done

bonsai/github-release-upload.sh github_api_token=$GITHUB_TOKEN repo_slug="$REPO_SLUG" tag="${TAG}" filename="dist/$(cat dist/sha512_file)"

bonsai/github-release-event.sh github_api_token=$GITHUB_TOKEN repo_slug="$REPO_SLUG" tag="${TAG}"
