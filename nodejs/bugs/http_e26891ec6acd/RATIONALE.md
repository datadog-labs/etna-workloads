# Re-introduced bug: http writableFinished / 'finish' after write errors (fix e26891ec)

**Bug.** `OutgoingMessage` computed `writableFinished` from `finished && outputSize === 0 && socket.writableLength === 0`. It emitted `'finish'` whenever the final write callback ran, unless `socket._hadError` was set. A failed flush could therefore emit `'finish'` and report `writableFinished === true`. `end(cb)` callbacks were hooked on `'finish'`, so they never received `null` or the flush error. A second `end(cb)` before `'finish'` got `ERR_STREAM_ALREADY_FINISHED` instead of the flush outcome.

All changes are in `lib/_http_outgoing.js`.

**Hunks.**
1. Removed the `kWritableFinished`, `kEndCallbacks` and `kFlushError` symbols and their constructor initialisation. This matches the fix's symbol and constructor hunks.
2. The `writableFinished` getter is computed again from `finished`, `outputSize` and `socket.writableLength`. This reverses the getter hunk.
3. `onFinish` is restored to `if (outmsg?.socket?._hadError) return; outmsg.emit('finish');`. The helpers `flushEndCallbacks`, `getEndCallbackError` and `queueEndCallback` are removed. This reverses the `onFinish` hunk and the helper additions.
4. In `end()`, the `this.finished` branch again uses `on('finish')`, or `ERR_STREAM_ALREADY_FINISHED` if already finished. The common path again uses `this.once('finish', callback)`. This reverses the `end()` hunks. In today's code the single-final-chunk path also called `queueEndCallback` and cleared `callback`. I removed that call so the callback goes through `once('finish')`, as before the fix.

**Failing tests with the change** (all three oracle cases fail, in two consecutive runs):
- `parallel/test-http-outgoing-writableFinished` fails. The failed-write cases get `'finish'` or an `end()` callback result that does not match what the test expects.
- `parallel/test-http-outgoing-end-multiple` fails. The second `end(cb)` receives `ERR_STREAM_ALREADY_FINISHED` instead of `null`.
- `parallel/test-stream-pipeline` fails. The pipeline succeeds instead of reporting `ERR_STREAM_PREMATURE_CLOSE`.

I did not capture the exact assertion messages. The results above are the "not ok" lines from the TAP output.
