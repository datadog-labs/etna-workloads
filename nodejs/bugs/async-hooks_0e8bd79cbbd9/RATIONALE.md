# Re-introduced bug (nodejs/node 0e8bd79cbbd9)

**Bug:** Environment tracks vm contexts as weak handles in `contexts_`. When a context is GC'd, its handle becomes empty. Code that iterates the list without checking for empty handles calls `SetPromiseHooks` on a collected context, which segfaults (issue 39019).

**Hunks** (the code now lives in `src/env.cc`, not `env-inl.h`):
1. `Environment::ResetPromiseHooks` (the fix's `SetJSPromiseHooks` hunk): removed the `if (it->IsEmpty()) { erase; continue; }` guard. Disabling a hook after a context was collected now dereferences an empty handle.
2. `Environment::UntrackContext` (the fix's `RemoveContext` hunk): removed the `PurgeTrackedEmptyContexts()` call, which is today's form of the empty-check, so the loop can see empty handles again.

**Result:** `parallel/test-async-hooks-vm-gc` fails (`not ok 1`, crash) in two consecutive runs. It passes on the clean release.
