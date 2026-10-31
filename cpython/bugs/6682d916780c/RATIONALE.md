# Rationale

Fix: `Class.get_methods` skips generator expressions, which the symtable
reported as TYPE_FUNCTION blocks named `genexpr` (indistinguishable by name from
a user function or local called `genexpr`).

In v3.15.2 the Python hunks (the `.0` check in `Lib/symtable.py`) are absent
but the bug is masked by a second path: `Python/symtable.c` now names genexpr
blocks `<genexpr>` (`anon_genexpr`), which can never collide with an
identifier. I reverted that other path: `symtable_visit_genexp` in
`Python/symtable.c` again names the block `genexpr` (the pre-rename name).
Codegen looks up scopes by AST node, not name, so compilation is unaffected;
only symtable-visible names change.

`Lib/symtable.py` is left as-is (it already lacks the fix's checks).

Failing oracle cases:
- `test_class_get_methods`: `genexpr = 1` plus a generator expression in a class
  body makes `get_methods()` return `('genexpr',)` instead of `()`.
- `test_genexpr`, `test_nested_genexpr`: expect block name `<genexpr>`, now
  `genexpr` (collateral of the name revert).
