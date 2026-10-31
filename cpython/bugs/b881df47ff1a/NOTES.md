Reproducer: enter a fake task for a fake running loop, fork, and in the child set the same
running loop and call asyncio.current_task(). Clean prints b'NO TASK' (PyOS_AfterFork_Child resets
asyncio state); buggy prints b'SHARED TASK' because the child inherits the parent's current task.
