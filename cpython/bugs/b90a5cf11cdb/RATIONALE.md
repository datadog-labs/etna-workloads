# Rationale

## Change: `Lib/pdb.py`, `_ScriptTarget.__init__`

The fix guarded the `sys.path[0]` replacement with `if not sys.flags.safe_path:`.
In v3.15.2 the same guard sits in `_ScriptTarget.__init__` (the code moved from
`ScriptTarget.check`). I removed the guard, so `sys.path[0]` is always replaced
with the script's directory, even under `-P` / `PYTHONSAFEPATH`. This is the
pre-fix behaviour.

The Doc/NEWS hunks and the test hunks are not implementation code, so I did not touch them.

## Oracle result

`test.test_pdb.PdbTestCase.test_safe_path` fails. With `PYTHONSAFEPATH=1`, the
debugged script prints `sys.path[0] is <cwd>`, which the test asserts must not
appear. The other 87 oracle cases pass.
