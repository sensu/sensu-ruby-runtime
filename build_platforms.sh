#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts



# Debian platform
platform="debian" test_platforms="debian:8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi
