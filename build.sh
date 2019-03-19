#!/bin/bash

platforms=( alpine debian centos )
ruby_version=2.4.4
asset_version=${TRAVIS_TAG:-0.0.1}

mkdir -p dist

for platform in "${platforms[@]}"
do
    docker build --build-arg "RUBY_VERSION=$ruby_version" --build-arg "ASSET_VERSION=$asset_version" -t sensu-ruby-runtime:${ruby_version}-${platform} -f Dockerfile.${platform} .

    docker run -v "$PWD/dist:/dist" sensu-ruby-runtime:${ruby_version}-${platform} cp /assets/sensu-ruby-runtime_${asset_version}_${platform}_linux_amd64.tar.gz /dist/
done
