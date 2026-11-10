# Re-introduced bug: clearImmediate with arbitrary objects throws

Bug: `clearImmediate({})` (any non-Immediate object) is not ignored; it proceeds into the
immediate-clearing logic and `ImmediateList.remove` dereferences `undefined`, throwing a TypeError.

## Hunks
1. `lib/internal/timers.js` `ImmediateList.prototype.remove`: `if (item._idleNext)` / `if (item._idlePrev)`
   changed back to `!== null` (reverses fix hunk 1). For a plain object the props are `undefined`,
   so `undefined._idlePrev = ...` throws.
2. `lib/timers.js` `clearImmediate`: the guard `!immediate?._onImmediate || immediate._destroyed` (today's
   equivalent of the fix's `immediate[async_id_symbol] !== undefined` check, which keeps arbitrary objects
   from reaching the destroy/cleanup path) is reverted to the pre-fix `!immediate || immediate._destroyed`,
   so arbitrary objects are processed.

## Failing test
parallel/test-timers-clear-object-does-not-throw-error: `TypeError: Cannot set properties of undefined (setting '_idlePrev')`.
(test-repl-clear-immediate-crash still passes; stable across 2 runs.)
