Reproducer: sets a profile hook, then runs a function that calls `next()` on a generator and drops it unfinished. The profile events are printed.

Clean: the generator's close on dealloc runs the unwind, so the profiler sees a second `call f` / `return f None` pair before `return g`.
Buggy: genobject.c skips that unwind even when tools are active, so the second call/return pair for `f` is missing.
