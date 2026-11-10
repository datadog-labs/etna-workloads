# Re-introduced bug: NodeEventTarget.removeAllListeners() returns undefined

**Bug.** `NodeEventTarget.prototype.removeAllListeners()` did not return `this`, so it could not be chained and differed from the EventEmitter API (nodejs/node#35762).

**Hunk.** `lib/internal/event_target.js`, in `removeAllListeners`: I removed the trailing `return this;` after the `if/else` that deletes or clears `this[kEvents]`. This corresponds to the fix's single implementation hunk, which added that line. The release has since moved the method (it is now near line 1062 and has an early `return this` when `kEvents` is undefined). I left that early return alone because the fix did not touch it. The method now returns `undefined` whenever listeners exist.

**Failing test.** `parallel/test-nodeeventtarget` fails with an `AssertionError` from `strictEqual(eventTarget.removeAllListeners('foo'), eventTarget)`: `actual: undefined, expected: NodeEventTarget [EventTarget] {...}`. It failed on both runs.
