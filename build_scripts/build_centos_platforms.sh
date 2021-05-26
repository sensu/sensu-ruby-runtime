#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts

# CentOS 8 platform
platform="centos8" test_platforms="centos:8 debian:10 ubuntu:20.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# CentOS 7 platform
platform="centos7" test_platforms="centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04 ubuntu:20.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# CentOS 6 platform
# Note: EOL Nov 30, 2020
platform="centos6" test_platforms="centos:6 centos:7 centos:8 debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

## CentOS platform
#platform="centos" test_platforms="centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04 ubuntu:20.04" ./build_and_test_platform.sh
#retval=$?
#if [[ retval -ne 0 ]]; then
#  exit $retval
#fi




