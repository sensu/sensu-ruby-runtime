#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts

# Alpine platform
platform="alpine" test_platforms="alpine:latest alpine:3 alpine:3.8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi
platform="alpine3.8" test_platforms="alpine:latest alpine:3 alpine:3.8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

