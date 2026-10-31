repro.py spawns a child Python that runs an asyncio loop (with a task named "worker task") in a non-main thread. It then calls `RemoteUnwinder(pid).get_all_awaited_by()` on the child and checks whether the task is reported for that thread's id.

- clean: prints `worker task found: True`
- buggy: prints `worker task found: False`. The injection makes the unwinder start from `threads_main` instead of `threads_head`, so threads other than the main one are missed.
