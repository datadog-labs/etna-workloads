Decorates a generator function with a `@contextmanager`-based context decorator, then
prints when the CM enters/exits relative to generator creation and iteration.
Clean: CM is entered lazily during iteration and exited when the generator finishes
(created, enter, body, exit). Buggy: the decorator wraps the call, so the CM enters and
exits at generator creation, before any iteration (enter, exit, created, body).
