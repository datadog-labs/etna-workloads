import http.client as c

class Sock:
    def __init__(self):
        self.data = b''
    def sendall(self, d):
        self.data += d
    def makefile(self, *a, **k):
        import io
        return io.BytesIO(b'HTTP/1.1 200 OK\r\n\r\n')
    def setsockopt(self, *a):
        pass
    def close(self):
        pass

h = c.HTTPConnection('proxy.example')
s = Sock()
h._create_connection = lambda *a, **k: s
h.set_tunnel('[1:2:3::4]:1234')
h.request('PUT', '/', '')
print(s.data)
