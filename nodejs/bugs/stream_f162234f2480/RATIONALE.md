# Broadcast.from() byte inputs not normalized

**Bug:** `Broadcast.from(input)` validated and iterated `input` directly instead of normalizing it through `from()`. Strings and ArrayBuffer views (Uint8Array, DataView) are not iterable byte inputs in that sense, so `Broadcast.from('abc')` threw `ERR_INVALID_ARG_TYPE` (strings are sync-iterable only as characters/rejected), and typed arrays were treated as generic iterables of numbers rather than bytes.

**Change (lib/internal/streams/iter/broadcast.js):**
- Removed `const source = from(input);` and validate `input` with `isAsyncIterable/isSyncIterable` (fix hunk 2: validation).
- In `pump`, iterate `input` instead of `source` (fix hunk 3/4: the async and sync loops).
- Removed the now-unused `from` import (fix hunk 1).

**Failing test:** `parallel/test-stream-iter-broadcast-from` — `TypeError [ERR_INVALID_ARG_TYPE]: The "input" argument must be an instance of Broadcastable, AsyncIterable, or Iterable. Received type string ('abc')`. (test-stream-iter-validation still passes; the removed `Broadcast.from('bad')` assertion is not exercised.)
