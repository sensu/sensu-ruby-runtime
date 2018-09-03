FROM alpine:latest

ARG RUBY_VERSION

RUN \
  apk add -U --no-cache linux-headers build-base wget sudo bash bash-doc bash-completion && \
  wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz && \
  tar -xzvf ruby-install-0.7.0.tar.gz && \
  cd ruby-install-0.7.0/ && \
  sudo make install && \
  ruby-install ruby ${RUBY_VERSION} -- --enable-load-relative && \
  echo "This ruby depends on the following linked libraries: " && \
  ldd /opt/rubies/ruby-${RUBY_VERSION}/bin/ruby && \
  mkdir -p ruby-${RUBY_VERSION}/lib && \
  cp /lib/ld-musl-x86_64.so.1 ruby-${RUBY_VERSION}/lib/ && \
  cp /lib/ld-musl-x86_64.so.1 ruby-${RUBY_VERSION}/lib/libc.musl-x86_64.so.1 && \
  tar -czf ruby-${RUBY_VERSION}.tar.gz -C ruby-${RUBY_VERSION}/ . && \
  sha512sum ruby-${RUBY_VERSION}.tar.gz
