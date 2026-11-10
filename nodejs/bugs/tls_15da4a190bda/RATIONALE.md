# Rationale

**Bug:** With TLS 1.3, when the server requests a client cert but the client sends none, a resumed session (PSK) makes the handshake verify result X509_V_OK. The server then set `socket.authorized = true` even though no certificate was presented, which doesn't match the original connection or TLS 1.2.

**Change (lib/internal/tls/wrap.js, `onServerSocketSecure`):** removed the `else if (!this._handle.hasPeerCertificate())` branch, which corresponds to the fix's added `else if (!getPeerX509Certificate())` hunk. The code in the release uses `hasPeerCertificate()` rather than `getPeerX509Certificate()`. Without the branch, a no-error verify result always falls through to `authorized = true`, and `rejectUnauthorized` no longer destroys the cert-less resumed socket.

**Failing test:** `parallel/test-tls-client-cert-resumption` fails (stable across 2 runs). The assertion on `socket.authorized` fails with `actual: true, expected: false` for the TLSv1.3 missing-cert resumed case.
