# Re-introduced bug: finished() with 'close' before 'finish'

Bug: eos()/finished() treats a Writable that has had end() called (`_writableState.ended`) as properly finished when 'close' arrives, even if 'finish' never fired (e.g. `w.end('asd'); w.destroy()` while a write is pending). It should report ERR_STREAM_PREMATURE_CLOSE.

Change (lib/internal/streams/end-of-stream.js, `getEosOnCloseError`): corresponds to the fix hunk that replaced `!stream._writableState.ended` with `!isWritableFinished(stream)` in the onclose handler. Today's code calls `isWritableFinished(stream, false)` (which also checks `finished`, errored state and ended+length===0); I restored the old check `!stream._writableState || !stream._writableState.ended`, so ended-but-unfinished streams yield no error. The fix's other hunks (writableEnded -> writableFinished rename, helper) are already structurally present in the release and are left untouched.

Failing test: parallel/test-stream-finished (not ok, exitcode 1; the new case with `w.end('asd'); w.destroy()` gets no ERR_STREAM_PREMATURE_CLOSE). Stable across two runs.
