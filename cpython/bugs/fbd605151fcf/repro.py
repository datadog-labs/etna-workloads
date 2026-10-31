import urllib.parse
print(repr(urllib.parse.urlsplit('http://[FE80::822a:a8ff:fe49:470c%tESt]:1234').hostname))
print(repr(urllib.parse.urlsplit(b'http://[FE80::822a:a8ff:fe49:470c%tESt]:1234').hostname))
