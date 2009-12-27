require 'rubygems'
require 'scrapi'
require 'curb'

#returns the IP and all of the request vars
TESTING_SIGNATURE = 'ProxyTester'
TESTING_URL = 'http://leonid.shevtsov.me/stuff/request_vars.php'
TIMEOUT = 10
USER_AGENTS = [
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
  "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)"
]

#Parse proxy4free.com
def proxies_from_proxy4free_com
  scraper = Scraper.define do
    array :items
    process "tr+tr.text", :items => Scraper.define { 
      process "td:nth-of-type(1)", :ip => :text
      process "td:nth-of-type(2)", :port => :text
      result :ip, :port
    }
    result :items
  end

  proxies = []

  1.upto 5 do |i|
    uri = URI.parse("http://proxy4free.com/page#{i}.html")
    result = scraper.scrape uri

    proxies += result.collect{|item| "#{item.ip}:#{item.port}"} unless result.nil?
  end

  proxies
end

#Parse digitalcybersoft
def proxies_from_digitalcybersoft_com
  scraper = Scraper.define do
    array :items
    process "tr.proxbo", :items => Scraper.define { 
      process "td:nth-of-type(1)", :address => :text
      result :address
    }
    result :items
  end

  uri = URI.parse("http://www.digitalcybersoft.com/ProxyList/fresh-proxy-list.shtml?HTML")
  result = scraper.scrape uri
  
  result || nil
end


#Parse samair.ru
def proxies_from_samair_ru
  scraper = Scraper.define do
    array :items
    process "table.tablelist tr", :items => Scraper.define { 
      process "td:nth-of-type(1)", :address => :text
      result :address
    }
    result :items
  end
  
  proxies = []

  1.upto 20 do |i|
    uri = URI.parse("http://www.samair.ru/proxy/ip-address-#{i.to_s.rjust 2, '0'}.htm")
    result = scraper.scrape uri

    proxies += result unless result.nil?
  end

  proxies.select{|addr| addr =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,4}/ }
end

proxies = proxies_from_proxy4free_com + proxies_from_digitalcybersoft_com + proxies_from_samair_ru
proxies.uniq!

puts "#{proxies.length} proxies grabbed. Testing..."

#first get real ip address
curl = Curl::Easy.perform(TESTING_URL)
my_ip = curl.body_str.match(/IP: ([^\n]+)\n/)[1]

good_proxies = []
normal_proxies = []

proxies.each do |proxy|
  print proxy.ljust(24)

  begin
    curl = Curl::Easy.perform(TESTING_URL) do |curl|
      curl.timeout = TIMEOUT
      curl.proxy_url = proxy
    end

    if !(curl.response_code == 200)
      puts "[no 200 response]"
    elsif !(curl.body_str.include? TESTING_SIGNATURE)
      puts "[no signature]"
    elsif curl.body_str.include? my_ip
      puts "Not anonymous"
      normal_proxies << proxy
    else
      puts "OK"
      good_proxies << proxy
    end
  rescue Curl::Err::TimeoutError
    puts "[timeout]"
  rescue Curl::Err::CurlError
    puts "[error]"
  end
end

def write_proxies_to_file(proxies, filename)
  File.open(filename, 'w') do |f|
    f.write proxies.join("\n")
  end
end

write_proxies_to_file good_proxies, 'anonymous_proxies.txt'
write_proxies_to_file normal_proxies, 'proxies.txt'
