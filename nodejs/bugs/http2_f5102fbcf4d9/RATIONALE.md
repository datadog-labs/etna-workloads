# Re-introduced bug: http2 compat `sendDate` ignored

**Bug:** `Http2ServerResponse.sendDate = false` and `removeHeader('Date')` had no effect on the wire; the `Date` header was always sent.

**Hunks (lib/internal/http2/compat.js only):**
- `removeHeader`: removed the `if (name === 'date') { sendDate = false; return; }` branch (fix hunk 1). Now `removeHeader('Date')` just deletes from kHeaders and `sendDate` stays true.
- `[kBeginSend]`: removed `sendDate: state.sendDate` from the options passed to `stream.respond()` (fix hunk 3). Today's core.js (`prepareResponseHeaders*`) already honours `options.sendDate`, so the core.js hunks of the fix are already in place; the bug is re-created by not passing the flag, as before the fix.

**Failing tests:** `parallel/test-http2-compat-serverresponse-headers-send-date` (assertion that `'date' in headers` is false fails) and `parallel/test-http2-compat-serverresponse-headers` (`removeHeader('Date')` should make `sendDate` false). Both "not ok" in two runs.
