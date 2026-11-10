# Re-introduced bug: net "write after FIN" error emitted synchronously

**Bug:** When a socket has been ended by the other party (allowHalfOpen false), `socket.write()` goes through `writeAfterFIN`. The error (EPIPE, "This socket has been ended by the other party") was emitted synchronously inside `write()`, rather than in the next tick. Code that calls `write()` and only afterwards updates its state sees the 'error' handler run re-entrantly.

**Hunk (lib/net.js, writeAfterFIN):** The fix replaced the synchronous `this.emit('error', er)` with `process.nextTick(emitErrorNT, this, er)`. Today's code uses `this.destroy(er)`, which emits the error asynchronously. I replaced it with `this.emit('error', er); this.destroy();`. This brings back the synchronous emit, and `destroy()` is kept so the socket is still torn down.

**Failing test:** parallel/test-net-write-after-end-nt fails. The `assert(!hasError, 'The error should be emitted in the next tick.')` check fires because the error handler already ran inside `write()`. The test was run twice and failed both times. I did not capture the full assertion text.
