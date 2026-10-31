Reproducer for gh-87135: a daemon thread holds a Lock forever; a self-referencing
object's `__del__` runs during the GC after daemon threads are stopped at
finalization and calls `lock.acquire()`.

- clean: raises PythonFinalizationError, prints "got the correct exception!", exit 0.
- buggy: the acquire hangs forever (timeout), since the finalization check in Python/lock.c is removed.
