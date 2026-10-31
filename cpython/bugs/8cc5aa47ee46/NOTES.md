Reproducer for gh-87135 (daemon threads must hang, not exit, when taking the GIL during finalization).
A daemon thread blocks in `_testcapi.finalize_thread_hang(lock.acquire)`; during finalization (via a patched
`sys.stderr.flush`) the lock is released so the thread tries to re-take the GIL.
Clean: thread hangs, `os._exit(0)` runs, exit status 0, no output.
Buggy: thread calls pthread_exit, the pthread cleanup handler fires and Py_FatalError aborts the process.
