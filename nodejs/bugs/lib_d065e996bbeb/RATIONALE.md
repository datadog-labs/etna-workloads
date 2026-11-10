# Re-introduced bug: d065e996 (AbortSignal.any() following)

## Bug
The fix reworked how `AbortSignal.any()` composites register with their sources
(dependant signals, finalization registries) and unregistered fired timeout
signals. The release has since moved on (eager `followCompositeSignal` call in
`any()`, per-result-signal unregister token). I re-introduced the fix's token
scheme in the cleanup registries: the `sourceSignalsCleanupRegistry` unregister
token is the *source* WeakRef, which is shared by nested composites. When an
inner composite is collected, its dependants-cleanup callback unregisters the
cleanup entry that the still-live outer composite needs, so the outer composite
is never pruned from its sources and stale state is retained.

## Hunks (all in lib/internal/abort_controller.js)
1. `dependantSignalsCleanupRegistry` callback: now takes
   `{sourceSignalRef, dependantSignalRef, sourceSignalsCleanupToken}` and calls
   `sourceSignalsCleanupRegistry.unregister(sourceSignalsCleanupToken)`
   (the fix's callback hunk; release used `dependantSignalRef` as token).
2. `followCompositeSignal`: the registration passes
   `sourceSignalsCleanupToken: sourceSignalWeakRef`, and
   `sourceSignalsCleanupRegistry.register(..., sourceSignalWeakRef)` uses the
   source WeakRef as token (fix's `followCompositeSignal` hunk; removed the
   later comment/`resultSignalWeakRef` token).
3. Removed `clearTimeoutRegistry.unregister(signal)` in the timeout callback
   (fix's `setWeakAbortSignalTimeout` hunk), so fired timeout signals stay
   registered with the finalization registry.

## Result
`parallel/test-abortsignal-drop-settled-signals` fails ("not ok", stable across
runs): the nested-composite test ("drops an observed composite of a composite
once its sources are collected") no longer reaches the expected state because the
shared token cancels the outer composite's cleanup.
