import http.client, io

class Raw(io.BytesIO):
    def read(self, n=-1):
        print("read", n)
        return super().read(n)

class Sock:
    def __init__(self, data): self.f = Raw(data)
    def makefile(self, *a, **k): return self.f

head = b"HTTP/1.1 200 OK\r\nContent-Length: 1000000000000\r\n\r\nabc"
r = http.client.HTTPResponse(Sock(head))
r.begin()
try:
    r.read()
except http.client.IncompleteRead as e:
    print("IncompleteRead", e.partial)
