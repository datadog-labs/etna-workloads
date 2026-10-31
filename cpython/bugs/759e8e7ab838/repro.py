import urllib.request
from urllib.request import Request
from io import StringIO

h = urllib.request.HTTPRedirectHandler()
req = Request("http://example.com/a.html", method="HEAD")
new_req = h.redirect_request(req, StringIO(), 302, "Found", {}, "http://example.com/b.html")
print(new_req.get_method())
