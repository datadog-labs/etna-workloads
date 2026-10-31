Runs a child interpreter with `-Xperf` that creates 50 code objects, forks, and in the fork child creates more code objects and runs gc.collect().
Clean: child exits 0, parent prints "signaled: False exit: 0".
Buggy: the old code watcher survives the fork (injection removed the watcher reset), so the child aborts with
`Assertion 'extra_code_index != -1' failed` in py_trampoline_evaluator; the parent sees the child killed by a signal.
