Reproducer: an object with no `__annotations__` but an `__annotate__` property, passed to
`annotationlib.get_annotations` with VALUE/FORWARDREF/STRING.
Clean: `{'x': int}`, `{'x': int}`, `{'x': 'int'}`.
Buggy: `_get_dunder_annotations` returns `{}` instead of `None` when annotations are missing, so
`__annotate__` is never consulted and VALUE and FORWARDREF give `{}`.
