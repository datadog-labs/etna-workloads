# Re-introduced bug: AsyncLocalStorage lost in unhandledRejection handling

**Bug.** Before the fix, `unhandledRejection`/`uncaughtException` handlers triggered from `processPromiseRejections` did not run in the rejected promise's async context, so `AsyncLocalStorage.getStore()` returned `undefined` (or the wrong store) inside them.

**Changes (lib/internal/process/promises.js), corresponding to the fix's hunks in `processPromiseRejections`:**
1. Removed the `pushAsyncContext(promiseAsyncId, trigger, promise)` before the mode handler. The fix added this push, so removing it restores the old behaviour.
2. Removed the second `pushAsyncContext` in `strictUnhandledRejectionsMode`. The fix added the same re-push after `triggerUncaughtException`.
3. Removed the `AsyncContextFrame.exchange(contextFrame)` / `set(prior)` pair. This is today's equivalent of the fix's promise-context push for the AsyncContextFrame implementation of ALS. Without it, handlers run in whatever context the microtask drain happens to have.
4. Removed the matching `popAsyncContext` (and the `needPop` bookkeeping and now-unused imports) so the stack stays balanced; this corresponds to the fix's try/finally pop.

**Failing test:** `async-hooks/test-async-local-storage-errors` fails with
`AssertionError: unknown error AssertionError: Expected values to be strictly equal: + actual - expected + undefined - { awaitToken: true }`.
It is raised from the uncaughtExceptionMonitor for err4, where the store is `undefined` instead of `awaitToken`.
