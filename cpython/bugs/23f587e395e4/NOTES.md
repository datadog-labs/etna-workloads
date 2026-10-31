Reproducer: creates a socketpair transport via `loop.create_connection(sock=...)`, closes it, lets the loop run
so the socket is released, then calls `write_eof()`.

Clean: `write_eof()` returns silently after close, so the script prints `ok`.
Buggy: the `_closing` check is gone, so `write_eof()` tries `self._sock.shutdown(...)` on the released
socket (`_sock` is None) and raises AttributeError, so the script prints `AttributeError`.
