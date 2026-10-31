# Rationale

The fix's code is still present in v3.15.2 in the same form, so the hunks were reversed directly.

- `Lib/_pyrepl/console.py` `runsource`, hunk 1: the AST parse goes back from `self.compile.compiler(..., ast.PyCF_ONLY_AST, incomplete_input=False)` to `ast.parse(source)`. The `Compile` instance no longer sees the source, so the first parse ignores the remembered future flags.
- `Lib/_pyrepl/console.py`, hunk 2: the per-statement compile gets `dont_inherit=True` back, so the flags of the surrounding code are not inherited.
- `Lib/codeop.py`, `Compile.__call__`: this reverts to the old signature `(source, filename, symbol, **kwargs)` with `flags = self.flags`. The `PyCF_ONLY_AST` constant and the early AST return are removed.

Oracle failure: `TestSimpleInteract.test_future_barry_as_flufl` fails with `'' != 'True\n'`. After `from __future__ import barry_as_FLUFL`, the next `runsource` call hits a syntax error on `<>`, so nothing is printed.
