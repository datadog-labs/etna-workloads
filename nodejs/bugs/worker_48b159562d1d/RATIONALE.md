# Re-introduced bug: crash on worker.unref() during exit (nodejs/node#33394)

**Bug:** If `worker.unref()` (or `ref()`) is called from a 'message' handler that runs after the Worker thread has stopped, `Worker::Unref` decrements the env's async refs a second time. The exit immediate (`SetImmediateThreadsafe` lambda in `Worker::StartThread`) already did `add_refs(-1)` while `has_ref_` stayed true. This trips `Assertion failed: (task_queues_async_refs_) >= (0)`.

**Change (src/node_worker.cc, one file, two hunks):** The fix added `&& !w->thread_joined_` to the conditions in `Worker::Ref` and `Worker::Unref`. In this release that guard is `w->tid_.has_value()` (tid_ is reset once the thread is joined). I removed it from both:
- `Worker::Ref`: `if (!w->has_ref_ && w->tid_.has_value())` -> `if (!w->has_ref_)`
- `Worker::Unref`: `if (w->has_ref_ && w->tid_.has_value())` -> `if (w->has_ref_)`

This matches the pre-fix code, which checked only `has_ref_`.

**Failing test:** `parallel/test-worker-unref-from-message-during-exit` fails on both runs, with `Assertion failed: (task_queues_async_refs_) >= (0)`.
