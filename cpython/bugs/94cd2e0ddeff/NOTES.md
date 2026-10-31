Creates an asyncio.Task subclass with a `__del__`, disables `_log_destroy_pending`, drops the task and runs gc.
Clean: prints "ok", exit 0. Buggy: the task is unregistered in finalization (before `__del__`/resurrection handling) rather than after, so the interpreter segfaults (exit -11).
