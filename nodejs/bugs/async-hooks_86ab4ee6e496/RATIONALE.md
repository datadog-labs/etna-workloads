# Re-introduced bug: ALS context lost after nested run()/exit() calls

**Bug.** After a nested `asyncLocalStorage.run()` (or `exit()`, which is implemented via `run`) returned, the
store was reset to `undefined` instead of being restored to the enclosing (outer) store. Code that continued in the
outer `run()` callback therefore lost its context. The old `exit()` also lacked the "already disabled" guard, so
calling it on a disabled instance re-enabled the storage.

The fix's `lib/async_hooks.js` no longer holds this code. Today there are two implementations, so the
change is applied to both.

## Hunks
1. `lib/internal/async_local_storage/async_context_frame.js` (the default implementation, `run()`): the `finally`
   block now calls `this.enterWith(undefined)` instead of `this.enterWith(prior)`. This corresponds to the fix's
   `run()` / `runSyncAndReturn()` hunks, which saved `outerStore` and restored it after the call. The old code
   called `_exit()`, which set the store to `undefined`. `exit()` goes through `run(undefined, ...)`, so it is affected too.
2. `lib/internal/async_local_storage/async_hooks.js` (the `--no-async-context-frame` implementation, `run()`):
   dropped `oldStore` and set the store to `undefined` in `finally`. This is the same restore hunk, for the hooks-based class.
3. Same file, `exit()`: removed the `if (!this.enabled) return callback(...)` guard. This corresponds to the fix's
   `exitSyncAndReturn()` / `exit()` guard hunks. `exit()` on a disabled instance now ends with `_enable()`.

## Failing tests
`async-hooks/test-async-local-storage-nested` fails on every run (default build):

    AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
    undefined !== {}      (actual: undefined, expected: {})

The failing assertion is the outer store check after the inner `run()`. `test-async-local-storage-enable-disable`
only fails under `--no-async-context-frame`, because the missing guard is in the hooks implementation.
