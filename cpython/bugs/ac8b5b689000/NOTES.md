Thread 1 imports `flaky_mod`, which blocks and then raises on its first execution. Thread 2 starts importing the same module while it is still in sys.modules and initializing, so it waits on the module lock. Thread 1 then fails and the module is removed from sys.modules.

- Clean: thread 2 retries the import and gets a working module (`X == 1`). The module body ran twice.
- Buggy: thread 2 returns the stale, partially initialized module that is no longer in sys.modules. The module body ran once.

The reproducer uses a 0.5s sleep to let thread 2 reach the lock wait.
