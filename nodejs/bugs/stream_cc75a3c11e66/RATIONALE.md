# Re-introduced bug: ReadableStream reader releaseLock() with pending reads

**Bug.** Before upstream fix cc75a3c (PR #44292), `ReadableStreamDefaultReader.releaseLock()` and
`ReadableStreamBYOBReader.releaseLock()` threw `ERR_INVALID_STATE` ("Cannot release with pending read requests")
if reads were pending, instead of releasing the lock and rejecting the pending reads as the WHATWG spec requires.

**Hunks** (all in `lib/internal/webstreams/readablestream.js`):
1. `ReadableStreamDefaultReader.releaseLock()`: replaced the call to `readableStreamDefaultReaderRelease(this)` with
   the old check (throw if `readRequests.length`) followed by `readableStreamReaderGenericRelease(this)`. This reverses the
   fix's first hunk. The fix's helper functions still exist, but are no longer used here.
2. `ReadableStreamBYOBReader.releaseLock()`: same for `readIntoRequests` / `readableStreamBYOBReaderRelease`. This reverses the fix's second hunk.
The fix's helper-function hunks are not removed, because today's code has them in a different form and they are still
used elsewhere (the shared helpers are harmless when unreferenced by releaseLock).

**Failing test.** `parallel/test-whatwg-readablestream` (second TAP entry, "not ok 2") fails on a stable basis:
`TypeError [ERR_INVALID_STATE]: Invalid state: Cannot release with pending read requests`
thrown from `releaseLock()` where the test expects the lock to be released and pending reads to reject.
