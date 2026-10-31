repro.py: an asyncio TLS server whose handler waits until the client's ClientHello is buffered in the StreamReader, then calls `writer.start_tls()`, followed by a ping/pong exchange.

Clean: the buffered ClientHello is handed to the SSLProtocol, the handshake completes, and both sides print what they received.
Buggy: the buffered data is lost, so the handshake never finishes. The script times out after 3s and prints `TimeoutError`.
