# Re-introduced bug: tlsSocket.servername set too late

**Bug.** On a TLS server, `socket.servername` was only populated in `_finishInit()` (after a successful handshake). If the handshake failed, e.g. the SNICallback returned an error, the `tlsClientError` handler saw `socket.servername === null`, even though the client had sent an SNI name.

**Hunks.**
1. `src/crypto/crypto_tls.cc`, `TLSWrap::SelectSNIContextCallback`. This corresponds to the fix's `src/tls_wrap.cc` hunk, which set `owner.servername` early. I removed the `Set(env, p->GetOwner(), env->servername_string(), ...)` call and kept only the `has_value()` check. The property is no longer set when the SNI extension is processed.
2. `lib/internal/tls/wrap.js`, `TLSSocket.prototype._finishInit`. This corresponds to the fix's `lib/_tls_wrap.js` hunk. I restored the unconditional `this.servername = this._handle.getServername();` and dropped the `=== null` guard and its comment.

**Failing test.** `parallel/test-tls-sni-servername` reports `not ok`. In `tlsClientError`, `socket.servername` is `null` instead of the expected `c.another.com` or `c.wrong.com`, so the `assert.strictEqual(socket.servername, options.servername)` check fails. I ran the test twice and it failed both times. I did not capture the exact assertion text.
