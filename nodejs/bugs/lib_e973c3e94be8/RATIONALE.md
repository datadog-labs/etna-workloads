# Re-introduced bug: AbortSignal.any / aborted validate signals with duck typing

**Bug.** `AbortSignal.any()` and `events.aborted()` did not brand-check signals through a WebIDL
interface converter. They used `validateAbortSignal`/`validateAbortSignalArray`, which only check
that the value is an object whose `aborted` property is a boolean. Plain objects such as
`{ aborted: true }` were accepted as AbortSignals (and errors came from the validators, not the
interface converter).

All hunks are in `lib/internal/abort_controller.js`:
- Imports: dropped `createInterfaceConverter` and the now-unused `converters`, and re-imported
  `validateAbortSignal` and `validateAbortSignalArray`. This corresponds to the fix's import hunks, reversed.
- `static any()`: it builds the array with `createSequenceConverter` (an identity element converter,
  because `converters.any` no longer exists in this release) and then calls `validateAbortSignalArray`.
  This reverses the fix's `any()` hunk.
- Removed the `converters.AbortSignal` and `converters['sequence<AbortSignal>']` definitions. This
  reverses the fix's hunk that added them. The `static {}` block holding the brand check is gone, because that is how this release defines the converter.
- `aborted()`: restored the `signal === undefined` check followed by `validateAbortSignal`. This reverses the fix's `aborted()` hunk.

**Failing test.** `parallel/test-abortsignal-any` fails. For example, `AbortSignal.any([{ aborted: true }])`
no longer throws, and the error messages differ ("The "signals[1]" argument must be an instance of
AbortSignal. Received undefined" instead of "signals[1] is not of type AbortSignal.").
The failure was the same on two runs.
