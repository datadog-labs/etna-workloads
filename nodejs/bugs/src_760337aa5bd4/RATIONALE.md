# Re-introduced bug: live lock between Environments with blocked lock requests

**Bug.** `LockManager::ProcessQueue` (src/node_locks.cc) added every Environment owning any pending request to `other_envs_to_wake`, even when that request was blocked. Two Environments (e.g. main thread and a worker) with blocked requests for the same resource wake each other forever via `WakeEnvironment`/`SetImmediateThreadsafe`.

**Change (single hunk in `ProcessQueue`)** — reverses the fix's second/third hunks:
- Restored the unconditional `if (request->env() != env) other_envs_to_wake.insert(request->env());` at the top of the loop (fix removed it).
- Removed the `is_grantable` variable and the conditional wake (`is_grantable || if_available`) and restored the original `if (should_wait_for_earlier_requests || !IsGrantable(request))` check.
- Kept the `COUNT_GENERIC_USAGE("LockManager.WakeEnvironment")` counter and include (the instrumentation hunk): the plain reversal removing it breaks the build because the test relies on the counter; it is behaviour-neutral.

**Failing test.** `parallel/test-web-locks-no-livelock` -> `not ok` (stable over 2 runs): the wake counter increases when main queues a second blocked request, so the strictEqual assertion on `getGenericUsageCount` fails.
