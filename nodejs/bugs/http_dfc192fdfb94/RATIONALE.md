# Rationale

Bug: IncomingMessage.signal was aborted on the message's own 'close' event, which fires on normal completion (e.g. after the request body is read), not only on connection close. So `req.signal.aborted` became true after a normal request/response.

Changes (lib/_http_incoming.js only):
1. `signal` getter: restored the old logic (`if (this.destroyed) ac.abort(); else this.once('close', () => ac.abort())`) instead of the fix's `kAttachAbortSignal()` socket-close tracking and the `readableEnded/complete` check. Corresponds to the getter hunk of the fix.
2. `_destroy`: removed the `abortSignal(this)` call added by the fix (hunk in `_destroy`); the old code did not abort there.
The remaining helper code (kAttach/kDetach, detach calls in client/server) is left in place; it is now inert for the signal since no socket listener is attached.

Failing test: parallel/test-http-request-signal (not ok, stable over 2 runs) — Test 2/6 `req.signal.onabort = common.mustNotCall()` / signal.aborted assertions fail because the signal aborts on normal 'close'.
