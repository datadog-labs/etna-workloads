Registers an atexit callback, then calls `_testcapi.set_nomemory(0)` in a child
interpreter. In finalization, copying the atexit callbacks fails with MemoryError.
The clean build clears the callbacks (atexit_cleanup) and exits with status 1;
the buggy build omits that cleanup and loops forever, so the child times out.
The parent prints a deterministic summary (return code check / "hang during finalization").
