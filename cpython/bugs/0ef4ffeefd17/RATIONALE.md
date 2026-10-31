# gh-130163 reintroduced in `print()`

In v3.15.2 `PySys_GetAttr()` already returns a strong reference, so the old
`_PySys_GetAttr` name no longer exists. The old bug was `builtin_print_impl`
using a borrowed `sys.stdout`. I restored that in `Python/bltinmodule.c`.

Fix hunk reversed: the `builtin_print_impl` hunks in `Python/bltinmodule.c`.
- The strong reference from `PySys_GetAttr(&_Py_ID(stdout))` is dropped
  right after the None check, so `file` is borrowed again.
- The `else { Py_INCREF(file); }` branch is removed.
- The `Py_DECREF(file)` calls on the error and normal exit paths are removed.

This matches the pre-fix code: `file` is borrowed from `sys.stdout`, and
nothing keeps it alive while `str(arg)` runs arbitrary Python code.

Oracle: `test_print.TestPrint.test_gh130163` crashes the interpreter.
`X.__str__` replaces `sys.stdout` and runs gc, which frees the old stdout
while `print` still uses it. Every test in `test_print.py` is then reported
as failing, because the run aborts.

I did not revert `input()` or `sys.displayhook`. `check.sh` shows no failures
in `test_builtin.py` or `test_sys.py`.
