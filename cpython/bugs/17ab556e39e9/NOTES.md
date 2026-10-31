`repro.py` builds a functional `typing.NamedTuple` from a non-sequence iterable (`zip(...)`) and prints an instance.
Clean: `Point(x=1, y=2)`. Buggy: `TypeError: Point.__new__() takes 1 positional argument but 3 were given`, because the zip is consumed by the type-check dict comprehension and the field names list ends up empty.
