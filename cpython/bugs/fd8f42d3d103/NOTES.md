Starts a thread, sets warnings to "error", then calls os.fork().
Clean: the DeprecationWarning ("multi-threaded, use of fork()...") propagates as an exception from os.fork -> prints "raised DeprecationWarning".
Buggy: the warning error is cleared, fork proceeds -> prints "fork succeeded, no exception".
