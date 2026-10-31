import http.client as client

class FakeSocket:
    def __init__(self, *a, **k):
        self.data = b''
    def sendall(self, d):
        self.data += d
    def makefile(self, mode, bufsize=None):
        import io
        return io.BytesIO(b'HTTP/1.1 200 OK\r\n\r\n')
    def setsockopt(self, *a):
        pass
    def close(self):
        pass

conn = client.HTTPConnection('proxy.com', 8080)
conn._create_connection = lambda *a, **k: FakeSocket()
conn.set_tunnel('destination.com')
conn.request('HEAD', '/', '')
print(conn.sock.data)
