# Rationale

**Bug:** `readable.resume()` calls `.read(0)`; when that returned null, `needReadable` was set unconditionally. A later `.read()` then calls `_read()` even if the buffer already exceeds highWaterMark, so backpressure is ignored and memory use grows.

**Change** (lib/internal/streams/readable.js, `Readable.prototype.read`): the fix replaced `state.needReadable = true` with `state.needReadable = state.length <= state.highWaterMark`. In today's bitmap-state code the line was `state[kState] |= state.length <= state.highWaterMark ? kNeedReadable : 0;`. I changed it to `state[kState] |= kNeedReadable;`, which restores the unconditional set.

**Failing test:** parallel/test-stream-readable-resume-hwm. It fails because `_read` (`common.mustNotCall()`) gets called. I ran it twice and it failed both times.
