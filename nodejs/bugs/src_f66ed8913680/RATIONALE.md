# Re-introduced bug: use of CleanupHookThunk after a cleanup hook removed it

**Bug.** In upstream, CleanupHookThunkRun() read thunk->isolate/fun/arg after calling thunk->fun(). A hook that
removes itself (e.g. ~ObjectWrap) erased and freed the thunk, so the later read was a use-after-free.
In v26.13.0 the code was rewritten: the thunk is marked `running`, and RemoveEnvironmentCleanupHook() ignores
running hooks so CleanupHookThunkRun() itself erases the registry entry afterwards. That guard is what prevents the UAF.

**Hunk (src/api/hooks.cc, RemoveEnvironmentCleanupHook).** Removed `|| found->second.running` from the early return
(and its comment). This corresponds to the fix's hunk in CleanupHookThunkRun that stopped reading `thunk` after
`fun()`: today's equivalent protection is this guard. Without it a self-removing hook erases the registry node, and
CleanupHookThunkRun() then reads `thunk->arg` / compares `&entry.second == thunk` on the freed thunk (the original UAF).

**Failing test.** cctest EnvironmentTest.RemoveEnvironmentCleanupHookDuringCleanup (stable over 2 runs; aborts):
`Assertion failed: self != end` (from CleanupHookThunkRun, via FreeEnvironment -> CleanupQueue::Drain).
(EnvironmentTest.CleanupHookRemovesItselfWhileRunning was not seen failing in the filtered run; I did not run the full list.)
