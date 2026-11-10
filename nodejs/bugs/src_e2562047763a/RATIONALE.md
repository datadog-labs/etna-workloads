# Re-introduced bug: SIGSEGV handler not reset before crashing

**Bug.** In `TrapWebAssemblyOrContinue` (src/node.cc), when V8 doesn't handle the fault as a WASM trap and no previous SIGSEGV handler was registered, Node re-raised the signal without first restoring the default disposition. The handler is re-entered immediately, so a hard crash (real segfault) spins in an infinite loop instead of terminating the process.

**Hunk 1 (src/node.cc)** corresponds to the fix's node.cc hunk. I removed the `sigaction(signo, SIG_DFL)` reset block (memset/sa_handler=SIG_DFL/CHECK_EQ) before `ResetStdio(); raise(signo);`. The code is otherwise identical to the pre-fix state.

The fix's node_process_methods.cc hunk (`causeSegfault`) and the test are test-support only. The release already has `causeSegfault`, so nothing to change under lib/ or src/ there.

**Failing test:** `abort/test-signal-handler` — TAP `not ok`, `severity: fail`, `exitcode: -15`, `timeout` (child loops forever, killed after ~120s). Stable across two runs.
