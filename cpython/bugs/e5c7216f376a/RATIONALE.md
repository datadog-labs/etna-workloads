# gh-121790 reintroduced in Lib/asyncio/__main__.py

Only file changed: `tree/Lib/asyncio/__main__.py`. The `_pyrepl/*` and `site.py` hunks of the fix are
not reversible in v3.15.2 (the code has been restructured, and the dict-copy in `_setup` is not reachable
with a non-dict namespace from the asyncio path).

Hunk reversed: the `asyncio/__main__.py` hunk that replaced the inline
`try: ... os.isatty(...) / ENOTTY / check() ... except: console.interact()` probe with a
`CAN_USE_PYREPL` branch. In `REPLThread.run` I restored the pre-fix probe: if stdin is not a tty,
set `return_code = errno.ENOTTY` and raise `OSError(ENOTTY, "tty required", "stdin")`, then fall back to
`console.interact()`; otherwise import `check` and `run_multiline_interactive_console` and run `check()`.
The old `else: console.interact(...)` branch is folded into the `except`. `CAN_USE_PYREPL` is still computed
in the `__main__` block, so the later code is unchanged.

Effect (same as the original bug): `python -m asyncio` without a tty falls back to the basic console but
exits with status 25 (ENOTTY) instead of 0, so the startup script / piped-input cases are reported as failures.

Oracle cases failing (7 of 18, `AssertionError: 25 != 0`), including
`test_asyncio_repl_reaches_python_startup_script`, `test_asyncio_repl_respects_isolated_mode`,
`TestAsyncioREPL.test_toplevel_contextvars_sync`, and other `TestAsyncioREPL` cases that run `-m asyncio` on a pipe.
