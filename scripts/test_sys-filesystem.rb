
# Display information about a particular filesystem.
begin
  require 'sys/filesystem'
  include Sys
  p Filesystem.stat('/')
  exit 0
rescue
  exit 1
end
