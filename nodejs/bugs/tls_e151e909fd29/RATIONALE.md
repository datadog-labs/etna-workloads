# Rationale

**Bug:** `Server.prototype.setTicketKeys` did not validate its argument. Non-buffer values and buffers not exactly 48 bytes were passed straight to the native `context.setTicketKeys`, instead of throwing `ERR_INVALID_ARG_TYPE` / "Session ticket keys must be a 48-byte buffer" (nodejs/node#38305).

**Change:** `lib/internal/tls/wrap.js` (today's location of the old `lib/_tls_wrap.js`). I removed the `validateBuffer(keys);` and `assert(keys.byteLength === 48, ...)` lines from `Server.prototype.setTicketKeys`. This matches the single implementation hunk of the fix, reversed. The imports are still used elsewhere in the file.

**Failing test:** `parallel/test-tls-ticket-invalid-arg` reports "not ok" on both runs. `assert.throws` fails because `setTicketKeys(null)` etc. no longer throws `ERR_INVALID_ARG_TYPE`. I did not capture the exact assertion message.
