Cancels the current task and swallows the CancelledError (task.cancelling() stays 1), then uses `asyncio.timeout(0.0)` in the `finally`.
Clean: TimeoutError is raised (timeout compares uncancel() to the count saved on entry). Buggy: the saved count is gone and `uncancel() == 0` fails, so CancelledError leaks out instead.
