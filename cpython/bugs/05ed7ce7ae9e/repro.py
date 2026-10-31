import http.client

class S:
    def __init__(self): self.data = b''
    def sendall(self, d): self.data += d
    def makefile(self, *a, **k):
        import io
        return io.BytesIO(b'HTTP/1.0 200 OK\r\n\r\n')
    def close(self): pass

for host, hdrs in (('invalid host', {}), ('tunnel', {'Bad\r\nName': 'v'}),
                   ('tunnel', {'Name': 'a\r\nInjected: 1'})):
    conn = http.client.HTTPConnection('example.com')
    conn.set_tunnel(host, headers=hdrs)
    conn.sock = S()
    try:
        conn._tunnel()
        print('no error', conn.sock.data)
    except ValueError as e:
        print('ValueError', e)
