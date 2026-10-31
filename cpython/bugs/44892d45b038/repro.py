import urllib.request
from http.cookiejar import LWPCookieJar, MozillaCookieJar, Cookie

for cls in (LWPCookieJar, MozillaCookieJar):
    c = cls("cookies.txt")
    c.set_cookie(Cookie(0, "pll_lang", "en", None, False, "www.acme.com", True, False,
                        "/", True, False, 2000000000, False, None, None, {}))
    c.save()
    c.clear()
    c.save()
    c.load()
    print(cls.__name__, len(c))
