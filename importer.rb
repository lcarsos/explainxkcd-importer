#! /usr/bin/env ruby

require 'date'
require 'net/http'
require 'uri'
require 'json'

def parse_transcript(text)
  text.gsub! /(?<!\n)\n(?!\n)/, "\n\n"
  length = text.lines("\n").to_a.length - 3
  text = text.lines("\n").to_a[0..length].join
  text.chomp!
end

ARGV.each do |arg|
  number = arg

  uri = URI.parse "http://xkcd.com/#{number}/info.0.json"
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new uri.request_uri
  response = http.request request

  xkcdjson = JSON.parse response.body
  safe_name = xkcdjson["safe_title"].gsub(/[\/]/, '')
  safe_name = safe_name.downcase
  safe_name = safe_name.gsub(/\ /, '-')

  explain_url = "http://explainxkcd.com/#{xkcdjson["year"]}/#{"%02d" % xkcdjson["month"]}/#{"%02d" % xkcdjson["day"]}/#{safe_name}/"
  puts explain_url
  #explainURI = URI.parse explain_url
  #explainResponse = Net::HTTP.get_response explainURI
  #puts explainResponse.body

output = "#REDIRECT [[#{xkcdjson["num"]}: #{xkcdjson["title"]}]]

{{comic
| number    = #{xkcdjson["num"]}
| date      = #{Date::MONTHNAMES[xkcdjson["month"].to_i]} #{xkcdjson["day"]}, #{xkcdjson["year"]}
| title     = #{xkcdjson["title"]}
| image     = #{xkcdjson["img"].gsub(/^(.*[\/])/, '')}
| imagesize = 
| titletext = #{xkcdjson["alt"]}
}}

==Explanation==


==Transcript==
#{parse_transcript(xkcdjson["transcript"])}

{{comic discussion}}"

  File.open("#{xkcdjson["num"]}.txt", 'w') do |f|
    f.write output
    #f.close
  end
end
