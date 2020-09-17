#!/bin/sh
echo "Test Script:"
echo "  Asset Platform:  ${platform}"
echo "  Target Platform: ${test_platform}"
echo "  Asset Tarball:   ${asset_filename}"
if [ -z "$asset_filename" ]; then
  echo "Asset is empty"
  exit 1
fi
mkdir -p /build
cd /build
tar xzf /dist/$asset_filename
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/ruby /scripts/test_ssl_url.rb
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/ruby /scripts/test_sys-filesystem.rb
