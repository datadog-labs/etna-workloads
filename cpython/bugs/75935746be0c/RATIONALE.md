# Rationale

Fix hunk (Lib/dataclasses.py, `_process_class`): the generated `__eq__` gained an
identity shortcut (`if self is other: return True`) so that a dataclass whose field
refers back to itself compares equal to itself instead of recursing.

In v3.15.2 the same code lives in `_process_class` as a `func_builder.add_fn('__eq__', ...)`
call. I removed the two body lines `if self is other:` / `return True`, which restores
the pre-fix body (`if other.__class__ is self.__class__: return <field comparisons>`).

Oracle failure: `test_dataclasses.TestEq.test_recursive_eq` fails with
`RecursionError: maximum recursion depth exceeded` in the generated `__eq__`
(`c == c` where `c.recursive = c`). The other 284 tests pass.
