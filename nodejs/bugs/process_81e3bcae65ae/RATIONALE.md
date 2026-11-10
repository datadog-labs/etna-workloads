# Re-introduced bug: promise catching resets the "has rejection to warn" flag (nodejs/node#30953)

Bug: `handledRejection()` unconditionally cleared the `kHasRejectionToWarn` tick flag. Catching one promise (`Promise.reject('2').catch(()=>{})`) therefore cleared the flag even though another earlier promise (`Promise.reject('1')`) was still unhandled, so the unhandled rejection of '1' was never processed/reported.

Hunk (lib/internal/process/promises.js, `handledRejection`): the fix guarded `setHasRejectionToWarn(false)` with `maybeUnhandledPromises.size === 0 && asyncHandledRejections.length === 0`. In today's code the trailing unconditional call no longer exists; the pending-rejection branch returns early. I added an unconditional `setHasRejectionToWarn(false)` in that branch (after deleting the promise from `pendingUnhandledRejections`), restoring the unguarded clearing, even though other pending rejections remain.

Failing test: parallel/test-promises-unhandled-rejections ("Catching a promise should not take effect on previous promises" scenario in the upstream test; locally the existing tests fail) -> `not ok 1`, "Error: Async test timeout exceeded" (stable over two runs).
