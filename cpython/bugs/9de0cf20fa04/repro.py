import io
import http.client

class FakeFile(io.BytesIO):
    pass

files = []

class FakeSocket:
    def __init__(self, data):
        self.data = data
    def sendall(self, d):
        pass
    def makefile(self, mode, bufsize=None):
        f = FakeFile(self.data)
        files.append(f)
        return f
    def setsockopt(self, *a):
        pass
    def close(self):
        pass

conn = http.client.HTTPConnection('proxy.com')
conn._create_connection = lambda *a, **k: FakeSocket(b'HTTP/1.1 404 NOT FOUND\r\n\r\n')
conn.set_tunnel('destination.com')
exc = None
try:
    conn.request('HEAD', '/', '')
except OSError as e:
    exc = e
print(repr(exc))
print([f.closed for f in files])
