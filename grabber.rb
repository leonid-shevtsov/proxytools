require 'rubygems'
require 'curb'
require 'scrapi'

module Grabber

  @proxies = File.read('anonymous_proxies.txt').split

  @current_proxy = 0

  def self.get_with_proxy(url)
    
    retries = 20

    begin
      retries -= 1
      @current_proxy = (@current_proxy+1) % @proxies.length
      curl = Curl::Easy.perform(url) do |curl|
        curl.proxy_url = @proxies[@current_proxy]
        curl.timeout = 20
        curl.follow_location = true
        curl.max_redirects = 5
        curl.headers['User-Agent'] = 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)'
        curl.headers['Referer'] = 'http://www.zavodi.ua'
      end
    rescue Exception
      retry unless retries == 0
    end
    curl.nil? ? '' : curl.response_code==200 ? curl.body_str : ''
  end
end
