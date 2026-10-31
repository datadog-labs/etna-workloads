Server accepts a connection; the client sends data then closes with SO_LINGER 0 (RST);
then the server calls SSLContext.wrap_socket(server_side=True).
Clean: SSLError "Closed before TLS handshake with data in recv buffer."
Buggy: no error (pre-handshake data check removed from SSLSocket._create).
