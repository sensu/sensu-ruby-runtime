#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts



# Debian platform
platform="debian" test_platforms="debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04 ubuntu:20.04 centos:7 centos:8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

platform="debian9" test_platforms="debian:8 debian:9 debian:10 ubuntu:14.04 ubuntu:16.04 ubuntu:18.04 ubuntu:20.04 centos:7 centos:8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi


platform="debian10" test_platforms="debian:10 ubuntu:18.04 ubuntu:20.04 centos:8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi
