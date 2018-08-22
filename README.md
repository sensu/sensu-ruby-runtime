# Sensu 2.0 Ruby Runtime Asset Prototype

This is an experimental/prototype attempt at building a [Sensu 2.0
Asset][sensu-assets] containing a portable Ruby runtime, based on the excellent
[ruby-install project by postmodern][ruby-install].

[sensu-assets]: https://docs.sensu.io/sensu-core/2.0/reference/assets/
[ruby-install]: https://github.com/postmodern/ruby-install

## Instructions

To test this prototype, please note the following instructions:

1. Use a Docker container to install `ruby-install`, build a Ruby, and generate
   a Sensu 2.0 Asset.

   ```
   $ docker build --build-arg "RUBY_VERSION=2.4.4" -t sensu-ruby:2.4.4 .
   ```

2. Extract your new sensu-ruby asset, and get the SHA-512 hash for your
   Sensu asset!

   ```
   $ mkdir assets
   $ docker run -v "$PWD/assets:/assets" sensu-ruby:2.4.4 cp /opt/rubies/ruby-2.4.4.tar.gz /assets/
   $ shasum -a 512 assets/ruby-2.4.4.tar.gz
   ```

3. Put that asset somewhere that your Sensu agent can fetch it.

   ...something something, sensu/sandbox, something...

3. Create an asset resource in Sensu 2.0.  

   First, create a configuration file called `sensu-ruby-2.4.4.json` with
   the following contents:

   ```
   {
       "type": "Asset",
       "spec": {
           "organization": "default",
           "name": "ruby-2.4.4",
           "url": "http://your-asset-server-here/assets/ruby-2.4.4.tar.gz",
           "sha512": "a5c359c7395ff1929391de638e5afbcb4d46e8fc5c930adaef76df7edd427e37b0e22d425e4b14f68282e10524420c692740bf1a319ab6f7cdb1e922d8f71731"
       }
   }
   ```

   Then create the asset via:

   ```
   $ sensuctl create -f sensu-ruby-2.4.4.json
   ```

   _NOTE: to run a simple test using this asset, create another asset called
   `helloworld-v0.1.tar.gz` with a simple ruby script at `bin/helloworld.rb`;
   e.g.:_

   ```ruby
   #!/usr/bin/env ruby

   require "date"

   puts "Hello world! The time is now #{Time.now()}"
   ```   

   _NOTE: this is a silly "hello world" example, but it shows that we have
   support for basic stlib gems!_

   Register this asset with Sensu, and then you're all ready to test!

4. Create a check resource in Sensu 2.0.  

   First, create a configuration file called `helloworld.json` with
   the following contents:

   ```
   {
       "type": "Check",
       "spec": {
           "organization": "default",
           "environment": "default",
           "name": "helloworld",
           "command": "helloworld.rb",
           "runtime_assets": ["ruby-2.4.4", "helloworld-v0.1"],
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

## What's next?

- Try building a Ruby runtime asset containing gems, and running a ruby script
  with third-party gem dependencies?
