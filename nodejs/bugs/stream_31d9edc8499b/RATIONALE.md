# Re-introduced bug: stream Transform with highWaterMark 0 backpressure

**Bug.** A Transform created with a readable highWaterMark of 0 buffered on both the writable and readable
sides. Its `_write` callback was also invoked immediately when `rState.highWaterMark === 0` or
`rState.length === 0`, so backpressure was not applied correctly. For example, `write()` could return true,
and `drain` was emitted at the wrong time.

**Hunks (both in lib/internal/streams/transform.js).**
1. Removed the constructor block that, when the readable HWM is 0, forced `highWaterMark: null` and
   `writableHighWaterMark: options.writableHighWaterMark || 0`. This corresponds to the fix's constructor
   hunk. The now-unused `getHighWaterMark` import is also removed, as in the fix.
2. Restored `rState.highWaterMark === 0 || rState.length === 0` in the `_write` callback condition. This
   corresponds to the fix's `_write` hunk, which removed those two terms.

**Failing tests** (stable across 2 runs): `parallel/test-stream-transform-hwm0` and
`parallel/test-stream-passthrough-drain` print "not ok". I did not capture the assertion messages. The
split-highwatermark test still passes, because its removed cases aren't needed to detect this change.
