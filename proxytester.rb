require 'rubygems'
require 'curb'

proxies = []

$stdin.each do |f|
  f.each_line do |proxy|
    proxies << proxy.strip
  end
end

#returns the IP and all of the request vars
TESTING_SIGNATURE = 'ProxyTester'
TESTING_URL = 'http://leonid.shevtsov.me/stuff/request_vars.php'
TIMEOUT = 10
USER_AGENTS = [
  "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
  "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)"
]

# get real ip address
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
      puts "Anonymous"
      good_proxies << proxy
    end
  rescue Curl::Err::TimeoutError
    puts "[timeout]"
  rescue Curl::Err::ConnectionFailedError
    puts "[down]"
  rescue Curl::Err::PartialFileError, Curl::Err::GotNothingError, Curl::Err::RecvError
    puts "[no signature]"
  rescue Curl::Err::CurlError => e
    puts "[error #{e.inspect}]"
  end
end
