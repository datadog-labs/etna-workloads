# Rationale

v3.15.2 already contains the fix; the C side (`Python/_warnings.c`) calls
`_py_warnings._match_filename` when no module is given. So the single shared
implementation, `_match_filename` in `Lib/_py_warnings.py`, is reverted.

Change: after stripping `.py`, `_match_filename` now returns only the
full-filename match (`pattern.match(filename)`). The removed code (the
`.pyw`/`__init__` stripping and the loop that tries module names built from
each parent directory) is what the fix added, replacing the old
"filename minus .py" module (old `normalize_module` / `module[:-3]`).
This restores the pre-fix semantics for both the C and Python implementations.
The `<unknown>` and `<...>` cases are kept, since the old code also produced them.

Oracle failures: `test_warnings` `test_filter_module` (Py and C variants) --
a filter `module='package.module'` no longer matches filename
`/path/to/package/module`, so the warning is raised as an error. The
`test_filter_syntax_warnings_by_module` tests (compile/import/cmd_line_script)
also guard this.
