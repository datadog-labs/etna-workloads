import http.client as client

class Sock:
    def sendall(self, data): pass
    def makefile(self, *a, **k): return None
    def close(self): pass

for method in ('GET\r', 'POST\nHOST:abc', '\nPUT'):
    conn = client.HTTPConnection('example.com')
    conn.sock = Sock()
    try:
        conn.request(method=method, url="/")
        print(repr(method), 'accepted')
    except ValueError as e:
        print(repr(method), 'ValueError', e)
    except Exception as e:
        print(repr(method), type(e).__name__)
