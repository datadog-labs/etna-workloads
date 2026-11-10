# Rationale

**Bug:** `eos`/`finished()` trusts `willEmitClose` (computed up front from stream state) even when a non-standard/legacy stream (e.g. fd-slicer) sets `destroyed = true` itself and never emits 'close'. `finished()` then waits for 'close' forever and the callback is never called.

**Hunks** (both in `lib/internal/streams/end-of-stream.js`; `willEmitClose` is already `let` today):
1. `onfinish`: removed `if (stream.destroyed) willEmitClose = false;` (fix hunk 2, added in `onfinish`). Without it, a destroyed stream still defers to 'close'.
2. `onend`: removed the same check (fix hunk 3, in `onend`).

**Failing test:** `parallel/test-stream-finished` fails (`not ok 1`) on the new case: Readable with `destroyed = true` then `push(null)`; the `common.mustCall()` finished callback is never invoked. Stable across 2 runs.
