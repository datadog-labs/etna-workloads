repro.py calls `_io._TextIOBase.read.__get__(io.StringIO())` (a METH_METHOD descriptor, `__get__` with no second argument).
Clean: prints `builtin_method`, exit 0. Buggy: `method_get` calls PyType_Check(NULL), so it segfaults (exit 139).
Note: ./check.sh failed in my sandbox (bwrap missing .claude/launch.json), so I ran both interpreters by hand.
