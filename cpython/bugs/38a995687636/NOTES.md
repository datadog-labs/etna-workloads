Sets eager_task_factory and calls loop.create_task(coro(), name="test name"); the coroutine prints its own task name.
Clean: prints "test name" (name is passed to the factory). Buggy: create_task sets the name only after the factory returns, so the eager coroutine sees a default "Task-N" name.
