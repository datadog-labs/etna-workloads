import io
from http.server import BaseHTTPRequestHandler

h = BaseHTTPRequestHandler.__new__(BaseHTTPRequestHandler)
h.rfile = io.BytesIO(b'')
h.raw_requestline = b'GET /index.html\r\n'
h.requestline = ''
h.client_address = ('127.0.0.1', 0)
print(h.parse_request())
print(h.request_version, h.close_connection, type(h.headers).__name__)
