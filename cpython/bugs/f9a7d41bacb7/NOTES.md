repro.py calls `traceback.walk_stack(None)` from inside a function and prints the co_name of the innermost frame returned.

Clean: prints `inner`. Buggy: `walk_stack` skips 3 extra frames when `f is None` (and is now a generator, so the frame is taken lazily), so it prints a different frame, or raises if the stack is too shallow.
