# Rationale

**Bug:** A Worker blocked in `inspector.waitForDebugger()` could not be terminated. `worker.terminate()` and `process.exit()` set the environment to stopping, but nothing woke the inspector's `WaitForFrontendEvent` condition-variable wait, so the worker thread hung forever.

**Change (src/env.cc, `Environment::ExitEnv`):** removed the `#if HAVE_INSPECTOR ... inspector_agent_->StopIfWaitingForConnect(); #endif` block. This corresponds to the fix's src/env.cc hunk. The other hunks of the fix (the `StopIfWaitingForConnect` / `StopIfWaitingForFrontendEvent` / `StopWaitingForFrontendEvent` helpers and the flag) only add the machinery for this call. In the current release they live at different line numbers, so the plain reverse patch does not apply. They are left in place but are now never called, so the wait is never interrupted. This is the pre-fix behaviour and the build still passes.

**Failing test:** `parallel/test-inspector-exit-worker-in-wait-for-connection` gives `not ok` on two consecutive runs. The worker never exits, so the `worker.on('exit', common.mustCall())` check times out.
