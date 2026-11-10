# Re-introduced bug: zlib memory leak on invalid input

**Bug.** When a zlib write fails (e.g. inflating invalid data), the stream's strong
reference (`Ref()`/`Unref()` in `CompressionStream`) was toggled from the error
handler (`EmitError`) based on `write_in_progress_`. In the async path
`AfterThreadPoolWork` clears `write_in_progress_` before `CheckError()`, so
`EmitError` never unrefs, and the early `return` skips `Unref()`. The object stays
strongly held and is never GC'd.

**Hunks (all in src/node_zlib.cc), reversing the fix:**
1. `Write<async>` sync path: `Unref()` moved back inside the `if (CheckError())` block (fix hunk 1 moved it out). A sync error leaves the ref held.
2. `AfterThreadPoolWork`: removed the `OnScopeLeave` that unrefs on every exit; restored the `Unref()` after `MakeCallback` on the success path only (fix hunks 2 and 3).
3. `EmitError`: restored `if (write_in_progress_) Unref();` (fix hunk 4).

**Failing test.** `parallel/test-zlib-invalid-input-memory` reports `not ok`
(severity: crashed, exitcode -6, stable across runs): the leaked ZlibStream stays
strongly referenced, and the debug build aborts at exit with
`Found bad BaseObject during clean exit: ZlibStream`
(from `Realm::VerifyNoStrongBaseObjects`).
