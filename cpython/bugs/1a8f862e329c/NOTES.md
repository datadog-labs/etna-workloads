Reproducer: `HTTPConnection.set_tunnel('destination.com')` with a fake socket, then `request('HEAD', '/')`; prints the bytes sent.
Clean: `CONNECT destination.com:80 HTTP/1.1` plus a `Host: destination.com:80` header.
Buggy: `CONNECT ... HTTP/1.0` and no Host header (set_tunnel no longer adds it, and CONNECT hardcodes HTTP/1.0).
