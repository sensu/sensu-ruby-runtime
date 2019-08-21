require "net/https"
require "uri"
puts "Checking https response with https verify disabled"
url = URI.parse("https://www.sensu.io/")
req = Net::HTTP.new(url.host, url.port)
req.use_ssl = true
req.verify_mode = OpenSSL::SSL::VERIFY_NONE
res = req.request_head(url.path)
puts "Https response code: #{res.code}"
exit 0 if res.code == "200"
exit 0 if res.code == "301"
exit 1
