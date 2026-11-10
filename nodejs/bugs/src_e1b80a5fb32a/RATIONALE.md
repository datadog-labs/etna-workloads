# Re-introduced bug: Worker with --inspect-brk cannot be terminated

Bug: a Worker started with execArgv `--inspect-brk` blocked inside CreateEnvironment (in
Environment::InitializeInspector -> WaitForInspectorFrontendByOptions) waiting for a frontend,
so worker.terminate() / process.exit() could not stop it (it hung; issue #53648).

Changes (src/node_worker.cc only; the other fix hunks add helpers that stay harmlessly in place):
1. Removed `environment_flags_ |= EnvironmentFlags::kNoWaitForInspectorFrontend` before
   CreateEnvironment (fix hunk in Worker::Run). Without it the worker waits for the frontend
   during environment creation, as before the fix, before `is_stopped()` can be observed.
2. Removed the explicit `env_->WaitForInspectorFrontendByOptions()` call after CreateEnvironment
   (the matching fix hunk), which was the deferred, stop-aware wait.

Failing test: parallel/test-inspector-exit-worker-in-wait-for-connection2 ("not ok", fails
stably in 2 runs; worker never terminates / test times out).
