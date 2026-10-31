# Rationale

Fix: gh-112716 replaced `PyDict_GetItemRef` with `PyMapping_GetOptionalItem` when looking up builtins, so a non-dict `__builtins__` no longer raises SystemError.

Changes in `tree/Python/ceval.c`:
- `_PyEval_GetBuiltin()`: back to `PyDict_GetItemRef(PyEval_GetBuiltins(), ...)`. This reverses the first fix hunk.
- `_PyEval_ImportName()`: the `__import__` lookup in builtins is back to `PyDict_GetItemRef`. This reverses the second fix hunk, which was in `import_name`. That code has since moved into `_PyEval_ImportName`.

With a non-dict `__builtins__` (e.g. a mappingproxy), both lookups raise `SystemError: bad argument to internal function`.

Failing oracle cases:
- `test_exec_builtins_mapping_import`: `import foo.bar` raises SystemError instead of ImportError or calling the custom `__import__`.
- `test_eval_builtins_mapping_reduce`: `list_iterator.__reduce__()` raises SystemError instead of AttributeError or returning the `iter` entry.
