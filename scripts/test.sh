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
bad_result=0
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/ruby /scripts/test_ssl_url.rb
ssl_result=$?
if [ $ssl_result -ne 0 ]; then
        bad_result=1
	echo "error running ssl test"
fi	
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/ruby /scripts/test_yaml.rb
yml_result=$?
if [ $yml_result -ne 0 ]; then
        echo "error running yaml test"
        bad_result=1
fi

if [ $bad_result -ne 0 ]; then
	exit 1
fi

exit 0
