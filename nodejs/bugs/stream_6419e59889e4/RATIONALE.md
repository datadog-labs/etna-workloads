# Rationale

**Bug:** `stream.pipeline()` destroys streams that have already finished, instead of only destroying un-finished ones. Streams that already emitted 'end'/'finish'/'close' (e.g. `autoDestroy: false` streams, or a socket in an echo pipeline) get `destroy()` called when the pipeline completes, which breaks legacy-stream assumptions.

**Change (lib/internal/streams/pipeline.js, `destroyer()`):** removed the `if (finished) return;` guard in the returned `destroy` function. This corresponds to the fix hunk that added `if (finished) return;` to the destroyer's returned callback (the fix made the `finished` tracking via 'close' and eos gate destruction; the old code destroyed unconditionally, from PR 31940). The current code is structured differently (`{ destroy, cleanup }`), so the guard is dropped in place. Now finished streams are destroyed too.

**Failing test:** `parallel/test-stream-pipeline` (`not ok`, stable over repeated runs). Running the file directly fails with `Error [ERR_STREAM_DESTROYED]: Cannot call pipe after a stream was destroyed` (thrown from `emitErrorNT` in internal/streams/destroy), because pipeline now destroys already-finished streams. I did not isolate which sub-block fails first, so the `src.destroyed` assertion is the expected related failure, not one I observed.
