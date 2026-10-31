import urllib.parse
p = urllib.parse.urlsplit("\x01 http://www.python.org/doc/?q=1#f")
print(repr(p))
print(repr(urllib.parse.urlsplit(b"\x00 http://www.python.org/")))
