#! /usr/bin/env ruby

require 'date'
require 'net/http'
require 'uri'
require 'json'

number = 614

uri = URI.parse "http://xkcd.com/#{number}/info.0.json"
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new uri.request_uri
response = http.request request

xkcdjson = JSON.parse response.body
#puts body["transcript"]

output = "{{comic
| number    = #{xkcdjson["num"]}
| date      = #{Date::MONTHNAMES[xkcdjson["month"].to_i]} #{xkcdjson["day"]}, #{xkcdjson["year"]}
| title     = #{xkcdjson["title"]}
| image     = 
| imagesize = 
| titletext = #{xkcdjson["alt"]}
}}

==Explanation==


==Transcript==
#{xkcdjson["transcript"]}

{{comicdiscussion}}"

File.open("#{xkcdjson["num"]}.txt", 'w') { |f| f.write output }
