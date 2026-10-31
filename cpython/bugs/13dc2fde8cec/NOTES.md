Calls BaseHTTPRequestHandler.parse_request on an HTTP/0.9 request line (`GET /index.html`) with an empty rfile.
Clean: headers is a plain `{}` and no header parsing happens (a real socket would not block waiting for headers).
Buggy: the header parser runs, so `headers` is an `HTTPMessage` (and with a live socket the server would hang waiting for a blank line).
