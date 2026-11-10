# Rationale

**Bug:** `pipeline` uses `eos`, which invoked its callback on 'finish'/'end' even when the stream
would still emit 'close' (autoDestroy + emitClose, not yet closed). The pipeline callback could therefore
run before streams were fully destroyed / had emitted 'close'.

**Change:** `lib/internal/streams/end-of-stream.js`, in `onfinish` and `onend`, removed the
`if (willEmitClose && ...) return;` early returns. These correspond to the two hunks of the fix that added
those lines to `onfinish` and `onend` (the `willEmitClose` computation itself was
refactored upstream into `_willEmitClose` and is left alone, since it still serves the immediate-result paths).
Without them, eos calls the callback on finish/end rather than waiting for 'close'.

**Failing test:** `parallel/test-stream-pipeline` ("not ok"), because the pipeline callback runs
before `src` emits 'close' (`closed` is false rather than true in the added tests).
