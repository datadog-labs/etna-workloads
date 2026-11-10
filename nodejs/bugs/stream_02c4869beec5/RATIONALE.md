# Re-introduced bug: Duplex._construct race (nodejs/node#34448)

**Bug.** When a Duplex has an async `_construct`, the `constructed` flag must be cleared on both the readable and the writable state until construction finishes. Otherwise `_destroy` can run (and 'close' can be emitted) before `_construct` has called back. The test creates a `Duplex({readable:false, construct})`, calls `end('foo')`, and sees 'close' before construction completed.

**Today's code differs from the fix's base.** Duplex now calls `destroyImpl.construct` once, so the old "second call returns early on listenerCount>1" path is dead. A pure reversal (moving `once`/early-return before the state clearing) therefore has no effect. I re-expressed the defect in the same function, `lib/internal/streams/destroy.js`:

1. **Reorder hunk.** `stream.once(kConstruct, cb)` and the Duplex early return now come before the `r`/`w` state lookup and clearing. This matches the fix's hunk 1 in reverse. It is behaviourally inert today.
2. **Clearing hunk.** `if (w)` became `if (w && !r)`. The writable state's `constructed` bit is no longer cleared for a Duplex. This is the original symptom, "constructed not set to false for both writable and readable state". Before the fix, the Duplex's second call returned before reaching the `w` clearing.

**Failing test.** `parallel/test-stream-construct` fails in both runs. The failure is at test-stream-construct.js:268: `AssertionError: Expected values to be strictly equal: false !== true` (the 'close' handler sees `constructed === false`).
