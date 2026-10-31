Reproducer: registers an atexit callback, then calls `atexit.unregister(Evil())` where `Evil.__eq__` calls `atexit._clear()` during the comparison.

Clean: prints `done`, exit 0. Buggy: the injection removes the temporary reference to the callback tuple, so `_clear()` frees it while it is still in use. The buggy interpreter segfaults (exit -11).
