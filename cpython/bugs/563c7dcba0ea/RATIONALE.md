# Rationale

Fix (gh-104404) replaced a direct `SET_SCOPE(scopes, k, scope)` for cell vars of an
inlined comprehension with a deferred `promote_to_cell` set consumed by `analyze_cells`.
In v3.15.2 that set is called `inlined_cells`.

Change, in `Python/symtable.c` `inline_comprehension`:
- Reverses the `PySet_Add(promote_to_cell, k)` hunk: `scope == CELL` no longer adds the name
  to `inlined_cells` (only `DEF_COMP_CELL` still does, as it is a later separate feature),
  and instead, as pre-fix, the scope is set directly with `SET_SCOPE(scopes, k, scope)`
  when the name already exists in the enclosing function-like scope.
- The `analyze_cells` / `analyze_block` plumbing is left in place since it still serves `DEF_COMP_CELL`.

Result: the scope assigned directly is not the deferred promotion, so nested comprehensions
with lambdas get inconsistent cell/free classification.
check.sh: 29 of 65 oracle cases in test_listcomps fail, including `test_nested_4`
(the fix's new test), with an incomplete run (crash/assert).
