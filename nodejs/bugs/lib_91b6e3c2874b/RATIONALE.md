# Re-introduced bug: persisted composed signals never cleaned up

Bug: composed signals (`AbortSignal.any`) that have abort listeners are kept alive in
`gcPersistentSignals`. When their source signals are garbage collected, nothing removes the
composed signal's stale source refs or drops it from `gcPersistentSignals`, so settled composed
signals leak (issue #55328).

Hunk (lib/internal/abort_controller.js, `followCompositeSignal`): the fix added
`sourceSignalsCleanupRegistry.register(signal, {sourceSignalRef, composedSignalRef})` in the two
places in `AbortSignal.any` (now consolidated in `followCompositeSignal`, with an extra unregister
token). I removed that register call. The registry (and its definition hunk) remain but are never
populated, so the callback that deletes the source ref and evicts the signal from
`gcPersistentSignals` never runs: the pre-fix behaviour.

Failing test: parallel/test-abortsignal-drop-settled-signals ("not ok", stable over 2 runs);
the 'drops settled signals even when there are listeners' case sees un-GCed signals (length != 0).
