# Rationale

**Bug:** `fromAsyncGen` in `lib/internal/streams/duplexify.js` (issue #40497). The internal generator awaited the shared `promise`, yielded the chunk, and only afterwards created the next deferred promise/resolve pair. While the consumer processed the yielded chunk (e.g. a generator that yields several outputs per input), `write()` could be called and resolve the already-resolved old deferred. The next chunk was lost and the pipeline hung (callback never called).

**Changes** (all in `lib/internal/streams/duplexify.js`):
1. Generator loop: removed the `_promise = promise; promise = null;` capture and went back to `await promise` (fix hunk 1, first part).
2. Generator loop: moved `({ promise, resolve } = PromiseWithResolvers())` to after `yield chunk` rather than before it (fix hunk 1, second part). This restores the window where `resolve` is stale.
3. `write()` and `final()`: removed the `_resolve = resolve; resolve = null;` pattern and called `resolve(...)` directly (fix hunks 2 and 3).

**Failing test:** `parallel/test-stream-duplex-from` fails (stable across 2 runs): "Mismatched <anonymous> function calls. Expected exactly 1, actual 0." This is the pipeline callback of the issue #40497 case.
