Calls TaskGroup.create_task() on a TaskGroup that was never entered. It raises RuntimeError in both builds.
The fixed code closes the coroutine first, so `c.cr_frame is None` prints True on clean.
The buggy build leaves the coroutine unclosed and prints False.
