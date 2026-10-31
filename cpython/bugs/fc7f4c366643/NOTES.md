Iterates `t"{1}"` to exhaustion, then calls next() twice more. Clean: prints
Interpolation, StopIteration, StopIteration. Buggy: the exhausted iterator
passes NULL to PyUnicode_GET_LENGTH (assert failure/crash) instead of raising StopIteration.
