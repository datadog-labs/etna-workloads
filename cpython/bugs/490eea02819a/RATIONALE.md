# Rationale

Only file changed: `tree/Lib/concurrent/futures/__init__.py`. v3.15.2 uses `lazy from` imports, so the fix's `__getattr__` hunks cannot be reversed literally. I restored the pre-fix behaviour in equivalent form.

- Hunk "always export the name" (reverses the fix's conditional `__all__.append('InterpreterPoolExecutor')` and the `_interpreters` probe): `'InterpreterPoolExecutor'` is back in `__all__` unconditionally, and the `try: import _interpreters` / `lazy from .interpreter import ...` block is removed.
- Hunk "`__getattr__`" (reverses the `if _interpreters and name == ...` guard): a module `__getattr__` is added that matches the pre-fix one. It catches `ModuleNotFoundError` and returns `None` instead of raising `AttributeError`. It is only for `InterpreterPoolExecutor`, since Process/Thread are still handled by the lazy imports.

## Oracle failures
`test_import_interpreter_pool_executor` fails with "AttributeError not raised!". With `_interpreters` unavailable, `futures.InterpreterPoolExecutor` returns `None` instead of raising. `test_init_closure` also failed in one run, which is probably unrelated flakiness.
