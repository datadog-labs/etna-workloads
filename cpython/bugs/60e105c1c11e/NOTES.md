Reproducer: a non-daemon thread starts a second thread while the main thread
is already waiting for non-daemon threads at shutdown.
Clean: second thread starts and prints "OK", exit 0.
Buggy: thread creation is refused because `interp->finalizing` is already set
("can't create new thread at interpreter shutdown"), so the output differs.
