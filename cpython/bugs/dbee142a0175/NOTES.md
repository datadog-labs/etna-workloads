`repro.py` decorates a `__repr__` having an annotation with an undefined name (`default: undefined`) using `@recursive_repr()`, then fetches annotations with `Format.FORWARDREF`.

Clean: the wrapper copies `__annotate__`, so the annotation stays lazy and a ForwardRef for `undefined` is returned.
Buggy: the wrapper copies `__annotations__`, evaluating eagerly at decoration time, so a NameError is raised (caught and printed).
