from http import cookies
c = cookies.SimpleCookie()
c.load('key=value; expires=Saturday, 01-Jan-83 00:00:00 GMT')
print(repr(c['key']['expires']))
print(c.output())
