# Rationale

**Bug:** `Suite.createBuild` passed the suite's `{ctx, args}` incorrectly to `runInAsyncScope`: `runInAsyncScope(fn, ctx, args)` makes `ctx` the `this` value and passes the whole `args` array as the first argument. So a `describe` callback gets an array as its first parameter instead of the suite context, and `describe(name, ({ signal }) => ...)` sees `signal === undefined`.

**Change (lib/internal/test_runner/test.js, `Suite.createBuild`):** I replaced the `runArgs = [suiteFn, ctx]; ArrayPrototypePushApply(runArgs, args); await ReflectApply(this.runInAsyncScope, this, runArgs)` construction with `await this.runInAsyncScope(suiteFn, ctx, args)`. This corresponds to the fix's single implementation hunk, adapted to today's code, which wraps the function in `suiteFn` for diagnostics channels. That wrapping is kept. This restores the pre-fix call shape.

**Failing test:** `parallel/test-runner-misc` fails. The child run's `test.describe(..., ({ signal }) => ...)` callback no longer receives a signal, so `# pass 2` is not matched. The test fails on each of the runs I did.
