repro.py: a function whose `__wrapped__` points to itself, passed to `annotationlib.get_annotations(f, eval_str=True)`.
Clean: cycle detected, prints `{'x': <class 'int'>}`, exit 0.
Buggy: the injection removes the cycle check in the `__wrapped__`/`partial.func` unwrap loop, so it loops forever (timeout).
