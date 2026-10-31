# Rationale

Fix hunk (Modules/_sqlite/cursor.c, bind_parameters): `if (name != NULL)` -> `if (name != NULL && name[0] != '?')`, so `?NNN` placeholders aren't treated as named parameters.

In v3.15.2 the sequence-binding branch of `bind_parameters` (Modules/_sqlite/cursor.c) still has the filter, but the former DeprecationWarning is now a `ProgrammingError`. I removed the `&& name[0] != '?'` condition, which restores the pre-fix check. Indexed nameless placeholders such as `?1` are again reported as named parameters. Here that means a ProgrammingError rather than the original DeprecationWarning.

Oracle failures: `CursorTests.test_execute_indexed_nameless_params`, in both subtests (`select ?1, ?2` and `select ?2, ?1`). Each raises ProgrammingError, "Binding 1 ('?1') is a named parameter...".
