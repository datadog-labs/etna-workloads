# Re-introduced bug: http2 graceful session close

**Bug:** `session.close()` could destroy the session while data (e.g. the GOAWAY frame / an empty-payload response end) was still pending in nghttp2, so clients did not reliably receive GOAWAY. The session was only gated on open/pending streams, not on pending outgoing data.

**Changes (all in lib/internal/http2/core.js; the native helpers remain but are unused from JS):**
1. `setupHandle`: removed `handle.ongracefulclosecomplete = this[kMaybeDestroy].bind(this, null)` (fix hunk 1), so native never triggers the deferred destroy after the final write.
2. `close()`: removed the `handle.setGracefulClose()` call (fix hunk 2), so native never marks graceful-close mode.
3. `[kMaybeDestroy]`: removed the `hasPendingData` check (fix hunk 3), so the session is destroyed as soon as no streams remain.
4. `socketOnClose`: restored `session[kMaybeDestroy](err)` in place of `closeSession(session, NGHTTP2_NO_ERROR, err)` (fix hunk 4).

**Failing test:** parallel/test-http2-session-graceful-close fails ("not ok") on repeated runs (client no longer gets the expected goaway/close sequence). test-http2-client-rststream-before-connect still passes.
