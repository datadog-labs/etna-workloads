repro.py inspects the `__dict__`/`__weakref__` descriptors of two plain classes.
Clean: `__objclass__` is `object`, the descriptor is shared between classes, repr is `<attribute '__dict__'>`.
Buggy: each class gets its own descriptor with `__objclass__` set to that class, so the identity check is False and the repr mentions the class.
