import urllib.request
from http.cookiejar import CookieJar, DefaultCookiePolicy

c = CookieJar(DefaultCookiePolicy())
req = urllib.request.Request("http://bar.com/")
c.extract_cookies(type("R", (), {"info": lambda s: __import__("email").message_from_string("Set-Cookie: spam=eggs; Path=/foo\n\n")})(), req)
req = urllib.request.Request("http://bar.com/foobad/foo")
c.add_cookie_header(req)
print(repr(req.get_header("Cookie")))
cookie = c._cookies['bar.com']['/foo']['spam']
print(DefaultCookiePolicy(strict_ns_set_path=True).set_ok_path(cookie, req))
