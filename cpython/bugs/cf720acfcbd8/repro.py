import io
from http.server import BaseHTTPRequestHandler

class H(BaseHTTPRequestHandler):
    def __init__(self, data):
        self.rfile = io.BytesIO(data)
        self.wfile = io.BytesIO()
        self.client_address = ('127.0.0.1', 0)
        self.request_version = 'HTTP/0.9'
    def log_message(self, *a):
        pass

for v in ['HTTP/-9_9_9.+9_9_9', 'HTTP/909876543210.0', 'HTTP/1.909876543210']:
    h = H(('GET / %s\r\n\r\n' % v).encode())
    h.raw_requestline = h.rfile.readline()
    h.parse_request()
    print(v, h.wfile.getvalue().split(b'\r\n')[0])
