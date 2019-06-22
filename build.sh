#!/bin/bash

platforms=( alpine alpine3.8 debian debian9 centos centos7 centos6 )
ruby_version=2.4.4
asset_version=${TRAVIS_TAG:-local-build}

mkdir -p dist
mkdir -p assets

for platform in "${platforms[@]}"
do
    echo "Building Docker Image: sensu-ruby-runtime:${ruby_version}-${platform}"
    docker build --build-arg "RUBY_VERSION=$ruby_version" --build-arg "ASSET_VERSION=$asset_version" -t sensu-ruby-runtime-${ruby_version}-${platform}:${asset_version} -f Dockerfile.${platform} .
    echo "Making Asset: /assets/sensu-ruby-runtime_${asset_version}_ruby-${ruby_version}_${platform}_linux_amd64.tar.gz"
    docker run -v "$PWD/dist:/dist" sensu-ruby-runtime-${ruby_version}-${platform}:${asset_version} cp /assets/sensu-ruby-runtime_${asset_version}_ruby-${ruby_version}_${platform}_linux_amd64.tar.gz /dist/
done
