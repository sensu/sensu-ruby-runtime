#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts

# Amazon 1 platform
platform="amazon1" test_platforms="centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi
# Amazon 2 platform
platform="amazon2" test_platforms="centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

