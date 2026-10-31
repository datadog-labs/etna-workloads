Reproducer: for n in 0..19, creates an instance with a materialized `__dict__`, injects a
memory error into the n-th allocation (`_testcapi.set_nomemory`) while the instance is
deleted, and prints whether the dict was cleared when the dealloc raised MemoryError.

Clean: prints `[(False, {})]` (dict cleared), exit 0.
Buggy: the clear-the-dict fallback is removed, so the dict is left in a bad state and the
interpreter segfaults (exit -11).
