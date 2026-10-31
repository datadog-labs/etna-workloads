Reproducer for gh-109047 (concurrent.futures manager thread and PythonFinalizationError).

repro.py mocks `threading._start_joinable_thread` so the second thread creation raises
RuntimeError. This simulates thread creation failing during interpreter finalization. The first
thread is the executor manager thread. The second would be the queue feeder thread. It then
maps a function over a ProcessPoolExecutor.

- Clean: the manager thread catches the error and calls terminate_broken(). The map raises
  BrokenProcessPool, so the script prints `BrokenProcessPool` and exits 0.
- Buggy: the exception escapes the manager thread, which dies with a traceback on stderr. The
  futures are never resolved, so the script hangs. Under `timeout` it exits 124.
