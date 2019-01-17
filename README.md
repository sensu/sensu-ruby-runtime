# Sensu Go Ruby Runtime Assets

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

## Instructions

Please note the following instructions:

1. Use a Docker container to install `ruby-install`, build a Ruby, and generate
   a Sensu Go Asset.

   ```
   $ docker build --build-arg "RUBY_VERSION=2.4.4" -t sensu-ruby-alpine:2.4.4 -f Dockerfile.alpine .
   $ docker build --build-arg "RUBY_VERSION=2.4.4" -t sensu-ruby-debian:2.4.4 -f Dockerfile.debian .
   ```

2. Extract your new sensu-ruby asset, and get the SHA-512 hash for your
   Sensu asset!

   ```
   $ mkdir assets
   $ docker run -v "$PWD/assets:/assets" sensu-ruby:2.4.4-debian cp /assets/ruby-2.4.4.tar.gz /assets/
   $ shasum -a 512 assets/ruby-2.4.4.tar.gz
   ```

3. Put that asset somewhere that your Sensu agent can fetch it.

   ...something something, sensu/sandbox, something...

3. Create an asset resource in Sensu Go.

   First, create a configuration file called `sensu-ruby-debian-2.4.4.json` with
   the following contents:

   ```
   {
     "type": "Asset",
     "api_version": "core/v2",
     "metadata": {
       "name": "sensu-ruby-2.4.4-debian",
       "namespace": "default",
       "labels": {},
       "annotations": {}
     },
     "spec": {
       "url": "http://your-asset-server-here/assets/sensu-ruby-2.4.4-debian.tar.gz",
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
   $ sensuctl create -f sensu-ruby-2.4.4-debian.json
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
       "runtime_assets": ["sensu-ruby-2.4.4-debian", "helloworld-v0.1"],
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
   on the Sensu agent `$PATH`.
