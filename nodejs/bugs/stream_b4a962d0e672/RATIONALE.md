# Re-introduced bug: pipeline callback not called on already-ended source

**Bug:** `pipeline(src, dst, cb)` with a source that has already emitted/finished `end` (e.g. called from inside the readable's `'end'` handler) never ends the destination, because it waits for an `'end'` event that already fired. The callback is never called.

**Change (lib/internal/streams/pipeline.js, `pipe()`):** The fix added a check "if source already ended, `process.nextTick(endFn)`, else `src.once('end', endFn)`". In today's code that check is `isReadableFinished(src)`. I replaced the whole branch with the pre-fix `src.once('end', () => { ended = true; dst.end(); })`, and removed the now-unused `isReadableFinished` import (corresponds to the import hunk of the fix).

**Failing test:** `parallel/test-stream-pipeline` fails (stable across 2 runs): the new cases (pipeline started in the `'end'` handler) never get their callback called (`common.mustSucceed` not invoked). `parallel/test-webstreams-pipeline` still passes.
