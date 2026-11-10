# Re-introduced bug (CVE-2020-8172): `session` emitted before certificate verification

Bug: the TLS client emitted `session` as soon as OpenSSL delivered the new session, i.e. before `secureConnect` and before the peer certificate/hostname was verified. `https.Agent` caches sessions on `session`, so a session from a server with an invalid certificate could be cached and reused by a request issued before the socket was destroyed, skipping verification.

The code now lives in `lib/internal/tls/wrap.js` (was `lib/_tls_wrap.js`). All hunks are in that file:
- Removed `kPendingSession`/`kIsVerified` symbols (fix hunk 1).
- `onnewsessionclient`: always `owner.emit('session', wrappedSession)` immediately (fix hunk 2).
- Removed initialisation of both fields in the TLSSocket constructor (hunk 3) and their reset in `_destroySSL` (hunk 4).
- `onConnectSecure`: removed the deferred emit of the pending session after `secureConnect` (hunk 5).

Failing tests (both, stable over 2 runs): `parallel/test-tls-secure-session` (session emitted before the connect callback, so `assert(!session)` fails) and `parallel/test-https-agent-session-injection` (session cached despite hostname mismatch).
