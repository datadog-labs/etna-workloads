# Rationale

**Bug:** With `allowHalfOpen: false`, when the readable side ends the socket calls `end()` and then (in the same
tick) `destroy()`, closing the handle before the shutdown request has been issued/completed (potential data race).

**Change (lib/net.js, `onReadableStreamEnd`)** – corresponds to the fix's lib/net.js hunk, reversed: restores the
pre-fix code that calls `this.end()` when writable and then unconditionally falls through to
`if (!destroyed && !writable && !writableLength) this.destroy()`, so the socket is destroyed right after `end()`
without waiting for shutdown. (Today's code only sets `this.write = writeAfterFIN`; the fix's `else if` form is not
present, so the old form was re-expressed directly.)
The fix's stream_base_commons.js `readStop` hunk was not reverted: it is absent in the release (code was rewritten),
and it isn't needed to reproduce the defect.

**Failing test:** parallel/test-net-allow-half-open (fails stably, 2/2 runs): the socket is destroyed straight
after 'end' (`assert(!socket.destroyed)` / 'finish' handler failing). async-hooks/test-graph.tls-write still passes.
