# Re-introduced bug: no callback scope for native immediates

`Environment::RunAndClearNativeImmediates` runs native (SetImmediate) callbacks without an
`InternalCallbackScope`. Microtasks and nextTicks queued by those callbacks (e.g. via the
inspector) are therefore not drained after the tasks run.

## Hunk
- `src/env.cc`, `RunAndClearNativeImmediates`: removed the `HandleScope` + `InternalCallbackScope cb_scope(...)`
  (in today's code, with the `can_call_into_js()` guarded `obj`). This corresponds to the fix's single src hunk, which
  added those lines. The early `HasNativeImmediates()` return is a later addition and is kept.
  Without the scope, no tick/microtask drain happens on close.

## Failing tests
- `cctest EnvironmentTest.SetImmediateMicrotasks`: `Expected equality: called Which is: 0, expected 1`
  (test_environment.cc:995).
- `cctest EnvironmentTest.RunAndClearNativeImmediatesSkipsEmptyScope` also fails.
- `async-hooks/test-late-hook-enable` still passes here (the checked-in version is the pre-fix test).
