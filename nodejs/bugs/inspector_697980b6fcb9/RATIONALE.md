# Re-introduced bug: connectToMainThread() abort without parent inspector

## Bug
`inspector.Session#connectToMainThread()` in a Worker aborts the process on
`CHECK_NOT_NULL(parent_handle_)` in `Agent::ConnectToMainThread()` when the parent
Environment was created with `kNoCreateInspector` (so no parent inspector handle exists).
The fix throws `ERR_INSPECTOR_NOT_AVAILABLE` instead.

## Change (src/inspector_agent.cc, one logical hunk)
Corresponds to the fix's `src/inspector_agent.cc` hunk: removed the
`if (!parent_handle_) { THROW_ERR_INSPECTOR_NOT_AVAILABLE(...); return {}; }` guard and
restored `CHECK_NOT_NULL(parent_handle_);` right before `CHECK_NOT_NULL(client_)`.
(Placement differs from the original diff because today's code has an additional
`--process-timeout` check between the guard and the CHECKs.) This restores the pre-fix
abort.

The fix's `src/node_errors.h` hunk (declaring `ERR_INSPECTOR_NOT_AVAILABLE`) is NOT reverted:
the macro is now also used elsewhere in the release (`ThrowUninitializedInspectorError`,
`inspector_js_api.cc`, the process-timeout check), so removing it would break the build.

## Failing tests
`cctest:EnvironmentTest.WorkerConnectToMainThreadWithoutInspector` — the process aborts with
`Assertion failed: (parent_handle_) != nullptr` (stable across 2 runs).
