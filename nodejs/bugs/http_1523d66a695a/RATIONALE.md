# Re-introduced bug (nodejs/node 1523d66a695a)

**Bug:** Between `ClientRequest.onSocket` and `onSocketNT` the socket has no `'error'` handler. Errors emitted on the socket in that window (e.g. from a blocklist check or custom lookup, since `net` now calls `self.destroy(err)` and the error is emitted on the next tick) are unhandled and crash the process even if the user attached `req.on('error')`.

All changes are in `lib/_http_client.js`. `lib/net.js` and the `socket._hadError` line in `socketErrorListener` already match the fixed state, so the corresponding fix hunks need no change.

## Hunks
1. `onSocket`: removed the synchronous `socket._httpMessage = this; socket.on('error', socketErrorListener)` and restored the old TODO comment. This is the fix's `onSocket` hunk reversed.
2. `tickOnSocket`: restored `socket.on('error', socketErrorListener);`. This is the fix's removal of that line, reversed. The listener is attached only in `onSocketNT`, one tick later.
3. `onSocketNT._destroy`: removed the `!socket?._hadError` guard and restored the original comment. This is the fix's guard hunk reversed. It is harmless without the early listener.

## Failing test
`parallel/test-http-request-lookup-error-catchable` fails on every run (two runs checked) with:
`Error [ERR_IP_BLOCKED]: IP(127.0.0.1) is blocked by net.BlockList` thrown from `emitErrorNT` (uncaught).
