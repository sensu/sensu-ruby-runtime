#!/bin/bash

platforms=( alpine )
ruby_version=2.4.4

mkdir -p dist

for platform in "${platforms[@]}"
do
    docker build --build-arg "RUBY_VERSION=$ruby_version" -t sensu-ruby-${platform}:${ruby_version} -f Dockerfile.${platform} .

    docker run -v "$PWD/dist:/dist" sensu-ruby-${platform}:${ruby_version} cp /assets/sensu-ruby-runtime-${ruby_version}-${platform}-linux-x86_64.tar.gz /dist/
done
