# Rationale

File: src/interfaces/libpq/fe-secure-openssl.c, function SSL_CTX_keylog_cb (single hunk set, tracing to the fix.patch hunk of the same function).

- Open/write failures are reported again via libpq_append_conn_error() into the connection error buffer instead of printing a WARNING to stderr. On a successful connection that buffer is never shown, so keylog errors are silently lost.
- Restored the umask(077) / umask(old_umask) around open() (also removed by the fix hunk).

Failing oracle case:
- src/test/ssl|t/001_ssltests.pl|connect with server root cert and incorrect sslkeylogfile path: stderr matches
