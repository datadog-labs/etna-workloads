A daemon thread spins forever; a self-referencing object's `__del__` (run by GC during finalization, after daemon threads are frozen) calls `thr.join(timeout=1)`.
Clean: join raises PythonFinalizationError ("got the correct exception!").
Buggy: the Py_IsFinalizing() check is gone, so join waits out the timeout and returns silently ("join returned, alive = True").
