from http.cookiejar import CookieJar
import urllib.request

c = CookieJar()
req = urllib.request.Request("http://localhost")
class R:
    def info(self):
        import email
        m = email.message_from_string("Set-Cookie: foo=bar; domain=localhost;\r\n\r\n")
        return m
c.extract_cookies(R(), req)
print(len(c), sorted(c._cookies))
