# Rationale

**Bug.** When a `TLSSocket` wraps an existing raw `net.Socket` and the raw socket is destroyed, the raw socket's `_handle` is already `null`. `TLSWrap.close()` then used `this._parent.close(done)` on the dead parent, so `done` never ran. The `TLSSocket` never finished closing and `'close'` was not emitted.

**Change (lib/internal/tls/wrap.js, `TLSWrap.prototype.close`; the file was `lib/_tls_wrap.js` at the time of the fix).** It corresponds to the single implementation hunk of the fix, reverted by hand because the code has moved. I removed the `if (this._parentWrap._handle === null) { done(); return; }` branch. I also restored the old single-condition form: `if (this._parentWrap && this._parentWrap._handle === this._parent) { once('close', done); return destroy(); }`. A destroyed parent socket now falls through to `this._parent.close(done)`, which never calls back.

**Failing test.** `parallel/test-tls-socket-close` reports `not ok` on both runs. The test waits for `'close'` on both the client and the server TLS sockets, and that never arrives. I did not capture the exact failure message. A third run with output capture exceeded the 120s tool timeout, so it was most likely a hang or timeout rather than an assertion failure.
