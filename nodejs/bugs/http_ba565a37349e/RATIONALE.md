# Re-introduced bug: HTTP parser errors lose the library-provided reason

**Bug.** Errors from the HTTP parser had the bare message `Parse Error`. The llhttp `reason` (e.g. "Header overflow") was available only as `err.reason` and was not included in `err.message`.

**Hunk.** `lib/_http_common.js`, `prepareError()`. This corresponds to the fix hunk that added `if (typeof err.reason === 'string') err.message = \`Parse Error: ${err.reason}\``. I removed that conditional. `prepareError` still sets `rawPacket`, and the client and server call sites are unchanged. In today's tree `prepareError` already exists and is shared by both call sites, so one hunk covers the client and server hunks of the fix. A literal reversal of the fix does not apply because the code has moved on.

**Failing tests** (all five oracle cases fail, in two consecutive runs):
- test-http-client-error-rawbytes: actual 'Parse Error', expected "Parse Error: Transfer-Encoding can't be present with Content-Length"
- test-http-client-parse-error: message 'Parse Error' vs expected 'Parse Error: Expected HTTP/, RTSP/ or ICE/'
- test-http-header-overflow: 'Parse Error' vs 'Parse Error: Header overflow'
- test-http-server-client-error: 'Parse Error' vs 'Parse Error: Invalid method encountered'
- test-http-server-destroy-socket-on-client-error: 'Parse Error' vs 'Parse Error: Invalid method encountered'
