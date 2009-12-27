Proxy tools
===========

Dependencies: curb


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
    Accept-Language: ru,en-US;q=0.8,en;q=0.6
    Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.3
