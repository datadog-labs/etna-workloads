# Rationale

**Bug:** `Readable.from()` created its stream with the default objectMode highWaterMark (16), so it eagerly pulled up to 16 items from the iterator. Errors were hit early and buffered items were discarded when the iterator threw, unlike generator semantics.

**Change (lib/internal/streams/from.js):** removed `highWaterMark: 1` (and its TODO comment) from the `new Readable({...})` options. This corresponds to the fix's single implementation hunk, which added them. Without it, reading is eager again.

**Failing test:** `parallel/test-readable-from` ("not ok"), via the `endWithError` case: items 1 and 2 are discarded when the rejection is encountered early, so `expected.length` is not 0 at the assertion. Ran twice with the same result. I did not capture the exact assertion message.
