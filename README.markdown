Proxy tools
===========

This is a collection of scripts to work with proxies in Ruby. All are pre-alpha, that is, written for my personal use. 

I'm not sure where this will go from here.

For all I know, proxytester.rb takes a newline-separated list of proxies (address:port) and checks all of them for availability and if they are
completely private, e.g. do not pass your IP to the requested server in any form:

  ruby proxytester.rb <proxy_list.txt

I'm using a page hosted on my server to check that; it simply returns a signature, the perceived remote IP and any request headers. Simple and 
reproducible:

  ProxyTester by Leonid Shevtsov
  IP: 95.134.224.28
  Host: leonid.shevtsov.me
  Connection: keep-alive
  User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.0.249.43 Safari/532.5
  Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
  Accept-Encoding: gzip,deflate,sdch
  Cookie: __utmz=142188719.1260440299.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utma=142188719.1964243406.1260440299.1260440299.1260440299.1; subscribe_checkbox_30144616b3ceeeee39526285cb324958=unchecked; wordpress_logged_in_30144616b3ceeeee39526285cb324958=leonid%7C1262869600%7C87b334c8c0c4e6424beaadf7e64fc564; wp-settings-2=m0%3Do%26m1%3Do%26m2%3Dc%26m3%3Dc%26m4%3Do%26m5%3Do%26m6%3Do%26m7%3Do%26m8%3Do%26m9%3Do%26hidetb%3D0%26editor%3Dhtml%26uploader%3D1%26imgsize%3Dmedium; wp-settings-time-2=1261671744; phpMyID_Server=emnmutt312q60n6a93nmkn8rn7
  Accept-Language: ru,en-US;q=0.8,en;q=0.6
  Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.3
