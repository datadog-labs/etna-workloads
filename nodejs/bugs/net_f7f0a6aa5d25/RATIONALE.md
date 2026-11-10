# Re-introduced bug: spurious "write after end" (EPIPE) on half-open sockets

**Bug.** When the peer sends FIN and `allowHalfOpen` is true... more precisely, `onReadableStreamEnd` replaces `socket.write` with `writeAfterFIN`. Before the fix, `writeAfterFIN` unconditionally destroyed the socket with EPIPE ("This socket has been ended by the other party") even if the local side had not ended its writable side. So writing in an `'end'` handler errored although the socket was still writable.

## Change (lib/net.js, `writeAfterFIN`)
- Corresponds to fix hunk 2 (the `if (!this.writableEnded) return Duplex.prototype.write...` guard added to `writeAfterFIN`). I removed that guard, restoring the old unconditional error path.
- Fix hunk 3 (removing `this.writable = true` from `Socket.prototype.connect`) has no counterpart: that line no longer exists in the current code, so nothing to restore. Fix hunk 1 (ReflectApply primordial import) was only needed by the guard.

## Failing tests
- `parallel/test-net-writable`: not ok — socket is destroyed with `code: 'EPIPE'` ("This socket has been ended by the other party") when writing in the `'end'` handler. Stable across 2 runs.
- `parallel/test-socket-write-after-fin-error` still passes.
