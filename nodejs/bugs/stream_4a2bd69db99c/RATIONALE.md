# Re-introduced bug: stream 'error' state not tracked / error emitted more than once

Bug: `errorEmitted` was not reliably set when an error was emitted, and `destroy()` on an
already-destroyed stream could emit a further 'error'. So a stream could emit 'error' multiple times,
and `_writableState.errorEmitted` could stay false after an error.

Change (lib/internal/streams/destroy.js only):
1. `emitErrorNT` no longer sets `kErrorEmitted` on the states. Corresponds to the fix's
   "ensure errorEmitted is always set" (`needError` setting the flag, removal of the
   scattered/missing assignments). Without it, the flag is never set, so the guard never suppresses anything.
2. `destroy()` on an already-destroyed stream again emits the error (`cb(err)` / `nextTick(emitErrorNT)`),
   matching the pre-fix branch that the fix replaced with `needError`.

Failing test: parallel/test-stream2-writable — "Expected values to be strictly equal"
(`w._writableState.errorEmitted` is false in the 'error' handler; stack at emitErrorNT).
Other oracle tests still pass (code has moved on; those paths are guarded by errorOrDestroy's destroyed check).
