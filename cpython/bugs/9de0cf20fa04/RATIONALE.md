# Rationale

Hunk reversed: `Lib/http/client.py`, `HTTPConnection._tunnel` (fix hunk @@ -941,23 +941,26).
The fix wrapped the CONNECT response handling in `try: ... finally: response.close()`.
In v3.15.2 the body differs (it uses `_read_headers` and stores `_raw_proxy_headers`), so I
removed the `try/finally` and the `response.close()` while keeping the rest unchanged.
When the proxy returns a non-200 status, the response is no longer closed, so the
socket file stays open (the ResourceWarning/leak from GH-103472).

Failing oracle case: `test_httplib` `test_tunnel_leak` (`sock.file_closed` is False after
the tunnel failure).
