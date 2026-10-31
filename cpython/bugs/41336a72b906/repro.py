import http.client, io

class S(io.BytesIO):
    def makefile(self, *a, **k):
        return self

body = b"line one\nline two\n"
raw = b"HTTP/1.1 200 OK\r\nContent-Length: %d\r\n\r\n" % len(body) + body

r = http.client.HTTPResponse(S(raw))
r.begin()
print(repr(r.read1()), r.isclosed())

r = http.client.HTTPResponse(S(raw))
r.begin()
print(repr(r.readline()), r.isclosed())
print(repr(r.readline()), r.isclosed())
