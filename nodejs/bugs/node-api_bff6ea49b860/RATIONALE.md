# Re-introduced bug: napi_threadsafe_function use-after-free (fix bff6ea49)

**Bug.** After a tsfn is finalized (via `napi_tsfn_abort` release or environment shutdown), other threads can still hold a valid handle to it. The tsfn must therefore stay alive until `thread_count` drops to 0. With the bug, `Finalize()` deletes the object unconditionally, so threads that are still calling `napi_call_threadsafe_function` use freed memory (a data race plus a use-after-free).

**Change (src/node_api.cc, one hunk).** `MaybeDelete()` is now `void MaybeDelete() { delete this; }`.
- It corresponds to the fix hunk that changed `EmptyQueueAndDelete()` into `EmptyQueueAndMaybeDelete()`. That hunk added the `thread_count > 0` check, which calls `ReleaseResources()` and returns instead of deleting.
- The release has since split that function into `EmptyQueue()` and `MaybeDelete()`. Removing the check in `MaybeDelete()` restores the old unconditional `delete this`.
- The deferred-delete paths in `Push()` and `Release()` become unreachable. They only run when `state == kClosed`, and `ReleaseResources()` is no longer called before deletion.

**Test.** `node-api/test_threadsafe_function_shutdown/test` fails on both runs with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal`. The child process crashes at shutdown instead of exiting with code 0.
