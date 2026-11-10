# Rationale

Bug: `AbortSignal.any()` validated its argument directly with `validateAbortSignalArray`, which requires a real Array. WebIDL `sequence<AbortSignal>` inputs (any iterable, e.g. a generator-based object) were rejected with ERR_INVALID_ARG_TYPE instead of being converted to an array first (nodejs/node#54674).

Change (lib/internal/abort_controller.js, one hunk in `AbortSignal.any`, plus importing `validateAbortSignalArray`):
- Corresponds to the fix's hunk replacing `validateAbortSignalArray(signals,'signals')` with `createSequenceConverter(converters.any)(signals)` + validating the converted array. The release's code already uses `converters['sequence<AbortSignal>']`; I reverted it to the pre-fix form: validate the raw `signals` argument and iterate it directly (renaming `signalsArray` back to `signals`). Non-array iterables are now rejected, and error messages revert to the validator's form.
- The webidl.js / crypto/webidl.js hunks (moving createSequenceConverter) are refactors that the current tree already has differently; not reverted.

Failing: parallel/test-abortsignal-any — `not ok`; message: 'The "signals[1]" argument must be an instance of AbortSignal. Received undefined' vs expected 'signals[1] is not of type AbortSignal.' (and iterable inputs are rejected as non-arrays).
