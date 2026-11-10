# Re-introduced bug: nextTicks/microtasks not run after each timer and immediate

**Bug.** Before upstream fix e7af9830 (PR #22842), the nextTick queue and microtask queue only ran after a whole list of
timers (one list per duration) or a whole batch of immediates finished, not after each individual Timeout or Immediate.
Callbacks like `process.nextTick(() => clearTimeout(t2))` therefore could not stop later timers/immediates in the same
list or batch, which differs from browser behaviour.

**Changes (lib/internal/timers.js only).**
1. `listOnTimeout`: removed the `ranAtLeastOneTimer` / `runNextTicks()` block before each timer after the first.
   This matches the fix hunk in `listOnTimeout` that added it. The per-list `runNextTicks()` in `processTimers` is kept,
   since it existed before the fix.
2. `processImmediate`: removed the `ranAtLeastOneImmediate` / `runNextTicks()` block that runs between immediates.
   This matches the fix hunk in `processImmediate` that added it. The old code ran no ticks between immediates in a batch.
   The rest of the release's refactored code is left untouched, because the other fix hunks (try/finally restructuring,
   the `_tickCallback` split) no longer map onto today's code.

**Failing test.** `parallel/test-timers-next-tick` fails on every run. The `t2`/`t3` timers or the `i2`/`i3` immediates
(`common.mustNotCall()`) now run, because the nextTick that clears them does not run until after the list or batch.
`test-timers-immediate-queue` and `test-repl-underscore` still pass.
