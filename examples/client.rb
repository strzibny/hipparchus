#!/usr/bin/env ruby
# Hipparchus minimal Ruby example for geocoding 'Opava'
#
# Parse a succesfull response from Hipparchus in format of:
#
#   { "location": { "lat": 49.9407, "lng": 17.8948 } }
#
# or:
#
#   { "error": "Some error message" }

require 'net/http'
require 'json'

location = 'Opava'
uri = URI.parse("http://0.0.0.0:3999/#{location}")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)

if response.code == '200'
  reply = JSON.parse(response.body)

  if reply['location']
    puts reply['location']['lat'] # => 49.9407
    puts reply['location']['lng'] # => 17.8948
  else
    puts reply['error']
  end
else
  puts 'Error...'
end
