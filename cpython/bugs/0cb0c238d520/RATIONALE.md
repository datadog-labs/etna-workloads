# Rationale

Fix hunk reversed (Lib/ssl.py, `SSLSocket._create`): the fix added, in the
`ENOTCONN` branch, a non-blocking `recv(1)` probe that raises `SSLError`
("Closed before TLS handshake with data in recv buffer.") when data is pending
on an unconnected socket. In v3.15.2 this block is wrapped in a try/finally
(and the timeout handling was already moved to `sock_timeout`/`settimeout`
after the check), so I removed the whole probe block. The unconnected socket
is then treated as before the fix: buffered pre-handshake data escapes to the
caller as if it had arrived over TLS. The `sock_timeout` ordering is
unchanged; it is equivalent to the old `settimeout(sock.gettimeout())`.

Failing oracle cases (test.test_ssl.TestPreHandshakeClose):
- test_preauth_data_to_tls_server: server reads b'DELETE /data HTTP/1.0\r\n\r\n' as TLS data.
- test_preauth_data_to_tls_client: client receives the plaintext 307 redirect instead of an SSLError.
