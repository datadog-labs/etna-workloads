Forks a child process (multiprocessing, fork context) from inside a ThreadPoolExecutor worker thread and prints the child's exit code.
Clean: prints 0. Buggy: `_threads_queues` isn't cleared after fork, so the child's exit handler tries to join the parent's worker thread (itself) and the child exits non-zero, with an error on stderr.
