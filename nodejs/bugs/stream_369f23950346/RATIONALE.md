# Rationale

**Bug:** Calling `Writable.destroy()` twice in the same tick, while buffered writes or pending end callbacks exist, hit an internal assertion (`assert(!state.destroyed)`) and threw `ERR_INTERNAL_ASSERTION`, instead of ignoring the second call.

**Hunks** (all in `lib/internal/streams/writable.js`):
1. Re-add `const assert = require('internal/assert');` (reverses the fix's removal of that import).
2. In `Writable.prototype.destroy`, the fix turned the condition into `!destroyed && (buffered || kOnFinished)`. Today's code uses bitfields: `(state[kState] & (kBuffered|kOnFinished)) !== 0 && (state[kState] & kDestroyed) === 0`. I restored the old form: the condition checks only the buffered/onFinished bits, and the body starts with `assert((state[kState] & kDestroyed) === 0)`. A second destroy() then trips the assertion.

**Failing test:** `parallel/test-stream-writable-destroy` fails with `Error [ERR_INTERNAL_ASSERTION]: This is caused by either a bug in Node.js ...`. This comes from the "Destroy twice" case. The failure was identical on two runs.
