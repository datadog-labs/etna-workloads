# Rationale

## Change
`Python/symtable.c`, `symtable_visit_annotation`: the call to
`symtable_enter_existing_block(st, parent_ste->ste_annotation_block, ...)` in the
`else` branch (re-entering an already-created annotation block) now passes
`add_to_children` = `true` instead of `false`.

This reverses the fix's last hunk. v3.15.2 already has the `add_to_children`
parameter, so only that argument needed reverting. Pre-fix, the function always
appended the re-entered annotation block to `prev->ste_children`, so the same
block was listed as a child multiple times. That corrupts the child ordering the
compiler relies on when inlining comprehensions, which is the gh-132479 crash.

## Oracle failures
- `RegressionTests.test_complex_comprehension_inlining_exec`: fails with
  `SystemError: compiler_lookup_arg(name='name_0') ... failed in __annotate__`.
- `RegressionTests.test_complex_comprehension_inlining`: also fails.
