# Sensu Go Ruby Runtime Assets
[![Build Status](https://travis-ci.org/sensu/sensu-ruby-runtime.svg?branch=master)](https://travis-ci.org/sensu/sensu-ruby-runtime)

This project provides [Sensu Go Assets][sensu-assets] containing portable Ruby
runtimes (for various platforms), based on the excellent [ruby-install project
by postmodern][ruby-install]. In practice, this Ruby runtime asset should allow
Ruby-based scripts (e.g. [Sensu Community plugins][sensu-plugins]) to be
packaged as separate assets containing Ruby scripts and any corresponding gem
dependencies. In this way, a single shared Ruby runtime may be delivered to
systems running the new Sensu Go Agent via the new Sensu's new Asset framework
(i.e. avoiding solutions that would require a Ruby runtime to be redundantly
packaged with every ruby-based plugin).

This same project may be used to build Sensu Assets for Ruby-based plugins via
[`bundler`][bundler] or other similar tools. We'll share more information on
building Ruby-based assets with third-party gem depdencies using Bundler soon;
in the interim, please review the instructions below for more information on
how to get started with this project.

[sensu-assets]: https://docs.sensu.io/sensu-go/5.1/reference/assets/
[ruby-install]: https://github.com/postmodern/ruby-install
[sensu-plugins]: https://github.com/sensu-plugins/
[bundler]: https://bundler.io

## Platform Coverage:
 Currently this repository only supports a subset of Linux distribution by making use of Docker containers to build and test.
 If you would like extend the coverage, please take a look at the Github Action integration and associated build scripts. We're happy to take pull requests that extending the platform coverage. Here's the current platform matrix that we are testing for as of the 0.1 release:

| Asset Platform | Tested Operating Systems Docker Images |
|:---------------|:-------------------------|
|  alpine  (based on alpine:3.8)   | Alpine(3, 3.8, latest)                                      |
|  centos7  (based on centos:7)     | Centos(7,8), Debian(8, 9, 10), Ubuntu(14.04, 16.04, 18.04, 20.04)     |
|  centos8 (based on centos:8)     | Centos(8), Debian(10), Ubuntu(20.04)  |
|  debian  (based on debian:9)     | Debian(8, 9, 10), Ubuntu(14.04, 16.04, 18.04, 20.04), Centos(7,8)    |
|  amnz1   (based on amazonlinux:1)     | Debian(8, 9, 10), Ubuntu(14.04, 16.04, 18.04, 20.04), Centos(7,8)    |
|  amnz2   (based on amazonlinux:2)     | Debian(10), Ubuntu(18.04, 20.04), Centos(8)    |

## OpenSSL Cert Dir
Please note that when using the ruby runtime asset built on a target OS that is different from the build platform, you may need to explicitly set the SSL_CERT_DIR environment variable to match the target OS filesystem.  Example: CentOS configures it libssl libraries to look for certs by default in `/etc/pki/tls/certs` and Debian/Ubuntu use `/usr/lib/ssl/certs`. The CentOS runtime asset when used on a Debian system would require the use of SSL_CERT_DIR override in the check command to correctly set the cert path to `/usr/lib/ssl/certs`


## Instructions

Please note the following instructions:

1. Use a Docker container to install `ruby-install`, build a Ruby, and generate
   a local_build Sensu Go Asset.

   ```
   $ docker build --build-arg "RUBY_VERSION=2.7.6" -t sensu-ruby-runtime:2.7.6-alpine -f Dockerfile.alpine .
   $ docker build --build-arg "RUBY_VERSION=2.7.6" -t sensu-ruby-runtime:2.7.6-debian -f Dockerfile.debian .
   ```

2. Extract your new sensu-ruby asset, and get the SHA-512 hash for your
   Sensu asset!

   ```
   $ mkdir assets
   $ docker run -v "$PWD/assets:/assets" sensu-ruby-runtime:2.7.6-debian cp /assets/sensu-ruby-runtime_2.7.6_debian_linux_amd64.tar.gz /assets/
   $ shasum -a 512 assets/sensu-ruby-runtime_2.7.6_debian_linux_amd64.tar.gz
   ```

3. Put that asset somewhere that your Sensu agent can fetch it. Perhaps add it to the Bonsai asset index!



3. Create an asset resource in Sensu Go.

   First, create a configuration file called `sensu-ruby-runtime-2.7.6-debian.json` with
   the following contents:

   ```
   {
     "type": "Asset",
     "api_version": "core/v2",
     "metadata": {
       "name": "sensu-ruby-runtime-2.7.6-debian",
       "namespace": "default",
       "labels": {},
       "annotations": {}
     },
     "spec": {
       "url": "http://your-asset-server-here/assets/sensu-ruby-runtime-2.7.6-debian.tar.gz",
       "sha512": "4f926bf4328fbad2b9cac873d117f771914f4b837c9c85584c38ccf55a3ef3c2e8d154812246e5dda4a87450576b2c58ad9ab40c9e2edc31b288d066b195b21b",
       "filters": [
         "entity.system.os == 'linux'",
         "entity.system.arch == 'amd64'",
         "entity.system.platform == 'debian'"
       ]
     }
   }
   ```

   Then create the asset via:

   ```
   $ sensuctl create -f sensu-ruby-runtime-2.7.6-debian.json
   ```

4. Create a second asset containing a Ruby script.

   To run a simple test using the Ruby runtime asset, create another asset
   called `helloworld-v0.1.tar.gz` with a simple ruby script at
   `bin/helloworld.rb`; e.g.:

   ```ruby
   #!/usr/bin/env ruby

   require "date"

   puts "Hello world! The time is now #{Time.now()}"
   ```

   _NOTE: this is a simple "hello world" example, but it shows that we have
   support for basic stlib gems!_

   Compress this file into a g-zipped tarball and register this asset with
   Sensu, and then you're all ready to run some tests!

5. Create a check resource in Sensu 2.0.

   First, create a configuration file called `helloworld.json` with
   the following contents:

   ```
   {
     "type": "CheckConfig",
     "api_version": "core/v2",
     "metadata": {
       "name": "helloworld",
       "namespace": "default",
       "labels": {},
       "annotations": {}
     },
     "spec": {
       "command": "helloworld.rb",
       "runtime_assets": ["sensu-ruby-runtime-2.7.6-debian", "helloworld-v0.1"],
       "publish": true,
       "interval": 10,
       "subscriptions": ["docker"]
     }
   }
   ```

   Then create the asset via:

   ```
   $ sensuctl create -f helloworld.json
   ```

   At this point, the `sensu-backend` should begin publishing your check
   request. Any `sensu-agent` member of the "docker" subscription should
   receive the request, fetch the Ruby runtime and helloworld assets,
   unpack them, and successfully execute the `helloworld.rb` command by
   resolving the Ruby shebang (`#!/usr/bin/env ruby`) to the Ruby runtime
   on the Sensu agent `$PATH`.:wq
   
