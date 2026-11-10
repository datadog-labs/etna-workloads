# Readable.from does not close the iterator

**Bug:** `Readable.from(iterable)` never calls `iterator.return()` when the stream is destroyed before the iterator is exhausted (for example `break` in `for await`, or `stream.destroy()`). The generator's `finally` blocks therefore never run, and resources held by the iterator leak.

**Change (lib/internal/streams/from.js):** I removed the `readable._destroy` override and the `close()` helper. I also removed the `originalDestroy`, `PromisePrototypeThen` and `aggregateTwoErrors` code that only they used.

This corresponds to the fix's hunk that added `readable._destroy` and `close()`. In the fix, `_destroy` calls `iterator.return()` when the iterator has not finished. The release's version also calls `iterator.throw()` on error, which came from later changes. Removing all of it restores the pre-fix behaviour, where destroy never touches the iterator.

**Not reversed:** I did not re-create the fix's `needToClose` flag or its `readable.destroyed` check inside `next()`. Both only exist to support the `_destroy` close, so without it they would do nothing.

**Result:** `parallel/test-readable-from-iterator-closing` fails on both runs. The failure message is `Mismatched noop function calls. Expected exactly 1, actual 0.`, raised from `asyncSupport` (the `finallyMustCall` check).
