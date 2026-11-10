# Re-introduced bug: mock setInterval timers stop processing other due timers

**Bug:** in `MockTimers.tick()`, after an interval timer fires and is re-inserted into the queue, the loop returns early. Other timers that are already due within the same tick (e.g. a `setTimeout` at 1001 when ticking 1001 with a `setInterval` at 1000) are never run (upstream issue #50382).

**Hunk:** `lib/internal/test_runner/mock/mock_timers.js`, in `tick()`: add back `return;` after `this.#executionQueue.insert(timer)` inside `if (timer.interval !== undefined)`. This corresponds to the fix's removal of `return;` in the `timer.interval` block (re-expressed for today's `tick()`). The other fix hunks (timer object return, clearTimer by position) are already in the release and were left alone.

**Failing test:** `parallel/test-runner-mock-timers` (subtest "should not prevent due timers to be processed": f2 callCount 0 instead of 1).
