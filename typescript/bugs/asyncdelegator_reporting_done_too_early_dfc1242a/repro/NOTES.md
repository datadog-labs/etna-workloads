Input: an async generator that delegates with `yield* inner()`, compiled with target es2015 so the `__asyncDelegator` helper is emitted.
Clean: the helper yields `{ value: __await(o[n](v)), done: false }` for every verb.
Injected: it yields `done: n === "return"`, so the emitted helper differs and `return` reports done too early.
