# Re-introduced bug: internal workers wait for the inspector

**Bug.** Internal workers (e.g. the ESM loader hooks thread) inherit the parent's debug options. With `--inspect-brk` or `--inspect-wait` they therefore wait for a frontend or break on their first line. The main thread is blocked on that worker while bootstrapping, so it hangs (nodejs/node#53681).

**Change (src/node_worker.cc, `Worker::New`).** I removed the block that calls `per_isolate_opts->per_env->get_debug_options()->DisableWaitOrBreakFirstLine()` when `is_internal` is true. This corresponds to the fix's hunk in `Worker::New` that adds the same block. The release has since moved that code and added a `vfs_load` line above it, which I left alone. The other hunks in the fix (the `IsolateData::CreateIsolateData` refactor, `Clone()`, and the `DisableWaitOrBreakFirstLine` helper) are only refactoring and plumbing, so I left them in place.

**Failing tests.** `parallel/test-esm-loader-hooks-inspect-brk` and `parallel/test-esm-loader-hooks-inspect-wait` both report "not ok". The loader worker waits for the inspector, so the tests do not complete. I ran them twice with the same result. I did not capture the exact failure message.
