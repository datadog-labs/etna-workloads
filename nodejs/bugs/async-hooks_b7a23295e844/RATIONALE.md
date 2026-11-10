# Re-introduced bug: promise hook skips assigning async ids to already-created promises

## Bug
When an async hook without a `before` listener was enabled after a promise was created,
the promise had no async id. The fast-path hook did nothing for such a promise on the
before/after events instead of assigning an id. `executionAsyncId()` inside `.then()`
therefore returned a wrong id (the surrounding one, or 0).

## Why the plain reversal didn't apply
The native FastPromiseHook in src/async_wrap.cc no longer exists. Promise hooks are now
JS functions in lib/internal/async_hooks.js, installed via V8's context promise hooks.
So the change is re-expressed there.

## Changes (lib/internal/async_hooks.js)
- `promiseBeforeHook`: replaced `trackPromise(promise)` with an early return when the
  promise has no `async_id_symbol`. This matches the fix's kBefore hunk: the old code
  returned without pushing an async context when no ids were assigned, instead of
  falling through to the JS hook that assigns them.
- `promiseAfterHook`: same early return in place of `trackPromise(promise)`. This matches
  the kAfter hunk, where the old code returned when no id had been assigned.

## Failing test
`parallel/test-async-hooks-enable-before-promise-resolve` fails (stable across runs):
`AssertionError: The expression evaluated to a falsy value: assert.ok(id > 0)`.
