Creates a task using the eager task factory, awaits it, and prints `task.get_coro()`.
Clean: prints `None`. Buggy: `get_coro` does `Py_NewRef(NULL)` for a finished eager task (task_coro cleared), which crashes (assert/segfault).
