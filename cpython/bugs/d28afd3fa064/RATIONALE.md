# Rationale

Fix hunk reversed: in `functools_wraps()` (Objects/funcobject.c) the fix removed
`COPY_ATTR(__annotations__)`, so classmethod/staticmethod no longer eagerly copy
`__annotations__` at construction (they are wrapped lazily by the getset
descriptors instead). I re-added that line. Pre-fix behaviour is restored:
`__annotations__` is put in the wrapper's `__dict__` at creation (forcing
evaluation of the annotations under PEP 649). The lazy getset code from the fix
is still present but is now bypassed for the initial value.

Oracle cases failing (3 failures in test_descr):
- `test_classmethod_staticmethod_annotations`: `assertNotIn('__annotations__', method.__dict__)` fails.
- `test_classmethods`: `cm.__dict__` contains an unexpected `'__annotations__': {}`.
- one more test checking the same dict contents (staticmethod analogue).
