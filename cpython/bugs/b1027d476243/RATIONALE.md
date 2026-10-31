# Rationale

Fix hunk reversed: `_StringifierDict.transmogrify` (Lib/annotationlib.py) no longer
attaches the closure's cell dict to the transmogrified ForwardRefs
(`if cell_dict is not None and obj.__cell__ is None: obj.__cell__ = cell_dict`).
In v3.15.2 the rest of the fix (dict-valued `__cell__` handling in `evaluate`,
`__hash__`, `_build_closure` returning `cell_dict`) is still present, but
ForwardRefs created from annotate-function closures never receive the cells,
so a ForwardRef to a nonlocal not yet defined at annotation time cannot be
evaluated later (the pre-fix bug, gh-138151).

Oracle cases failing: test_nonlocal_in_annotation_scope (evaluate() cannot see
the later-defined nonlocal) and the cell-related ForwardRef tests that expect
`__cell__` to be a dict (e.g. the one asserting `two_f_ga1.__cell__` is a dict;
it sees None). Result: 1 failure, 2 errors in test_annotationlib.
