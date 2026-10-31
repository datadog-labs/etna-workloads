repro.py calls `__init__` a second time on an already-initialized asyncio Future and Task (C implementations).
Clean: both raise `RuntimeError: ... object is already initialized`.
Buggy: re-initialization silently succeeds ("no error"), and a "Task was destroyed but it is pending!" warning appears.
