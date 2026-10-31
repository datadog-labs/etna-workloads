repro.py: a Protocol subclass whose `__init__` calls `super().__init__()` and is then instantiated.
Clean prints "ok"; buggy prints "RecursionError" (typing's `_no_init_or_replace_init` re-enters itself
because the "custom __init__ already in use" early return is missing).
