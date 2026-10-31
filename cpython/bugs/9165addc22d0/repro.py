import http.client
try:
    c = http.client.HTTPConnection("localhost\r\nX-injected: header\r\n", 8080)
    print("accepted", repr(c.host))
except http.client.InvalidURL as e:
    print("InvalidURL:", e)
