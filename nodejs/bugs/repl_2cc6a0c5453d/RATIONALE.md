# Re-introduced bug: REPL passes reversed frames to Error.prepareStackTrace

**Bug.** In `lib/repl.js`, the REPL's `overrideStackTrace` callback reversed the `stackFrames` array
in place before searching for the null-function-name frame. The user's `Error.prepareStackTrace(err, frames)`
therefore received frames in reversed order (the second argument should be in V8's normal order).

**Hunks** (all in `lib/repl.js`; the release has since moved on, e.g. the fallback is `ErrorPrepareStackTrace`
and `MainContextError` is already present, so only the frame-handling hunks apply):
1. Primordials import: `ArrayPrototypeFindLastIndex` -> `ArrayPrototypeFindIndex`, plus `ArrayPrototypeReverse`
   and `ArrayPrototypeSplice` re-added, unused `ArrayPrototypeSlice` removed. Corresponds to the import hunk of the fix.
2. `idx = ArrayPrototypeFindIndex(ArrayPrototypeReverse(stackFrames), ...)`: corresponds to the fix's
   `FindLastIndex(stackFrames, ...)` hunk; the in-place reverse reorders the array handed to the user.
3. `frames = ArrayPrototypeSplice(stackFrames, idx + 1)`: corresponds to the fix's `Slice(stackFrames, 0, idx)`;
   the old code kept the (reversed) remainder.

**Failing test.** `parallel/test-repl-pretty-custom-stack` ("not ok", stable over repeated runs):
`Uncaught Error: Whoops!--->\n...` actual output has frames in reversed order versus the expected output.
