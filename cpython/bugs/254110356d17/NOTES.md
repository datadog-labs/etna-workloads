Defines a class with `__annotate__`, reads `__annotations__` (caches it), deletes `__annotations__`, then reads again.
Clean: second read gives `{}`, `__annotate__` not called, `A.__annotate__` is None.
Buggy: `__annotate__` is not cleared on delete when the annotations were cached, so it is re-called (`{'a': int}`, called=True).
