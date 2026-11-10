# Bug
Native immediates (`SetImmediate()` callbacks) that are still queued when an Environment is torn down are never run
(or destroyed) during `Environment::CleanupHandles()`. Code that does cleanup in immediates (HTTP/2, N-API buffer
finalizers) then leaks/holds strong references past the start of Environment destruction.

# Change (src/env.cc only)
- Hunk 1 <-> fix hunk in `Environment::CleanupHandles()`: removed the call
  `RunAndClearNativeImmediates(true /* skip unrefed SetImmediate()s */);`, restoring the pre-fix behaviour of not
  draining refed native immediates during cleanup.
- The fix's other hunks (adding the `only_refed` parameter in env.cc/env.h) are left as-is: with no caller passing
  `true` the parameter is inert, so the old behaviour is restored with the minimal edit.

# Failing tests
`EnvironmentTest.SetImmediateCleanup` (cctest) no longer completes: the run hangs after `[ RUN ]` and was killed by
`timeout 120` (rc=124) on repeated runs; it never reaches the `EXPECT_EQ(called, 1)` check (expected
called==1, would be 0). All other tested cases (e.g. AtExitOrder) still pass.
