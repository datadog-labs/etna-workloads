Uses a @contextmanager generator that yields twice, with a `finally` that prints.
On exit, contextlib raises "generator didn't stop". Fixed code closes the generator
first (finally runs, gi_suspended False); the buggy build leaves it suspended
(prints gi_suspended True, finalizer runs later at interpreter exit).
