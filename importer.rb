#! /usr/bin/env ruby

require 'net/http'
require 'uri'

uri = URI.parse "http://xkcd.com/"
http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Get.new uri.request_uri
request["Accept"] = "*/*"

response = http.request request

response["content-type"]

response.each_header do |key, value|
  p "#{key} => #{value}"
end

