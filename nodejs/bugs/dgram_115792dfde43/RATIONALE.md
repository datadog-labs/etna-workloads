# Re-introduced bug: dgram listeners pile up on repeated bind errors

**Bug:** `socket.bind(..., cb)` registered `cb` with `once('listening')`. If the bind failed, the listener stayed attached. Retrying `bind()` after each error added another `'listening'` listener, which eventually triggered `MaxListenersExceededWarning` and leaked listeners.

**Hunk (lib/dgram.js, `Socket.prototype.bind`):** This corresponds to the fix's only implementation hunk. The fix added `removeListeners`/`onListening` helpers. They are attached on error (today via `EventEmitter.errorMonitor`) and on `'listening'`, and they remove both listeners. I replaced that block with the original `if (typeof cb === 'function') this.once('listening', cb);`. A failed bind therefore no longer removes the pending listener.

**Failing test:** `parallel/test-dgram-bind-error-repeat` fails with "not ok" on both runs. The failure is `MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 listening listeners added to [Socket]`, which trips `process.on('warning', common.mustNotCall())`.
