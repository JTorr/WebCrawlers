require 'rubygems'
require 'restclient'
require 'crack'
WURL = 'http://en.wikipedia.org/w/api.php?action=opensearch&namespace=0&suggest=&search='

def filter_descriptions(descriptions)
  new_descriptions = []
  descriptions.each do |d|
    if d =~ /refer/ || d =~ /redirect/ || d == ""
      d = nil
    end
    new_descriptions << d
  end
  new_descriptions
end

ARGV.each do |term|
  resp = RestClient.get("#{WURL}#{term}", 'User-Agent' => 'Ruby')
  arr = Crack::JSON.parse(resp)
  results = arr[1]
  newlines = []
  results.each_index {|i| newlines << "\n" }
  descriptions = filter_descriptions(arr[2])
  links = arr[3]
  puts results.zip(links).zip(descriptions).zip(newlines).flatten.compact 
  sleep 0.5
end
