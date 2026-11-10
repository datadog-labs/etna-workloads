# Re-introduced bug: fromWeb writev unhandled rejection (nodejs/node#62199, fix 57e59ea070e3)

## Bug
`Writable.fromWeb()` and `Duplex.fromWeb()` batch corked writes into `_writev()`.
Before the fix, the `_writev()` completion handler (`done`) assumed it always got
the array that `SafePromiseAll()` resolves with, and ran `error.filter((e) => e)`
on it with no check. If the stream is destroyed in the same microtask as
`uncork()`, the underlying `WritableStream` is aborted and the batch fails with
a single non-array value instead. `.filter` then throws a `TypeError`. The throw
happens inside a promise reaction and outside the `try`/`catch` that guards
`callback`, so it becomes an unhandled rejection and crashes the process.

## How the code looks in v26.13.0
The adapters no longer use `writer.ready` and `SafePromiseAll`. Both adapters'
`write`/`writev` now go through a shared request object made by
`createWriteTracker()` (with `dispatchWrite`/`dispatchWritev`). Its `settle()`
method does the job the old `done()` did: it takes the result (success, or the
first error), and on failure it calls `callback` in a microtask
(`PromisePrototypeThen(kResolvedPromise, ...)`) using the same pattern:
`try { callback(error) } catch { nextTick(destroy) }`. So the `done` logic of
the old `writev` now lives in `settle()`, and the hunks are re-expressed there.

## Hunks
1. **`settle()` failure microtask: `if (writev) error = error.filter((e) => e);`
   before the `try`, and `callback(writev && error.length === 0 ? undefined : error)`.**
   This matches the fix hunks that removed `error = error.filter((e) => e);` and
   changed `callback(error.length === 0 ? undefined : error)` to `callback(error)`
   in `done()` of both `newStreamWritableFromWritableStream` and
   `newStreamDuplexFromReadableWritablePair`. As in the old code, the `.filter`
   call sits outside the `try` inside a promise reaction. So when a writev batch
   fails with a non-array value, the `TypeError` turns into an unhandled
   rejection.
2. **The `writev` flag (`writev: false` in the tracker; `settle()` reads it and
   resets it; `writeTracker.writev = true` in both adapters' `writev()`).**
   This is the support needed so that hunk 1 only affects writev batches. In
   the old code only the `writev` `done()` had the array assumption; `write()`
   had its own `done` that did not filter. The two `writev()` changes sit where
   the two adapter `writev` hunks of the fix were.
3. The fix's `() => done()` change on the resolve path has no separate
   counterpart. Before the fix, the success path worked: `SafePromiseAll`
   resolved with an array of `undefined`, which filtered down to an empty array,
   so `callback(undefined)` was called. Today's success path calls `callback`
   synchronously with `undefined` and never runs the filter, so it already
   behaves like the old code. The third oracle block (normal cork/uncork
   success) still works.

## Failing test
`parallel/test-webstreams-duplex-fromweb-writev-unhandled-rejection` fails with
`not ok`. It failed the same way on both runs:

```
node:internal/webstreams/adapters:212
            error = error.filter((e) => e);
                          ^
TypeError: Cannot read properties of null (reading 'filter')
```

Here the failure value is `null`, the stored error from `destroy()` with no
error. With an `AbortError` the message would be "error.filter is not a
function". Either way it is the same crash as the original bug: a `TypeError`
from `.filter` on a non-array.
