# Rationale

Fix gh-123339 reversed in two places:

1. `Objects/typeobject.c` `type_set_module`: removed the `PyDict_Pop(dict, __firstlineno__)` call
   (fix hunk in typeobject.c). Setting `__module__` again leaves a stale `__firstlineno__` in the type dict.
2. `Lib/inspect.py` `findsource`: removed the `lnum >= len(lines)` out-of-bounds check for classes
   (fix hunk in inspect.py), restoring the old `return lines, firstlineno - 1`.

Not reverted: the collections.abc / decimal module replacement (already differs in v3.15.2).

Failing oracle cases (test_inspect): test_getsource_stdlib_tomllib, an abc getsource test
(OSError not raised: stale __firstlineno__ gives source of the wrong class), and
the out-of-bounds class lineno test; test_builtin.test_type_firstlineno also guards the C change.
