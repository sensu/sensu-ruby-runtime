require "yaml"
puts "Checking if yaml works"
dir=File.expand_path(File.dirname(__FILE__))
yfile=dir+"/resources/test.yml"
puts " Using file: #{yfile}"

begin
  summary = YAML.load_file(yfile)
rescue StandardError => e
  puts "#{e}"
  exit 1
end
exit 0
