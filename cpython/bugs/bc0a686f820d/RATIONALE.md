# Rationale

## Python/symtable.c, `symtable_extend_namedexpr_scope`
Reverses the single implementation hunk of the fix: the comprehension-rebind
check had been tightened to `(target_in_scope & DEF_COMP_ITER) && (target_in_scope & DEF_LOCAL)`.
I restored the pre-fix condition `if (target_in_scope & DEF_COMP_ITER)`, dropping the
`DEF_LOCAL` test. Names that only appear inside a target expression
(e.g. `b` in `b.prop`, or `d` in `c[d]`) are marked DEF_COMP_ITER but not
DEF_LOCAL, so they are wrongly rejected again. The surrounding code moved
(`symtable_lookup_entry` replaces `_PyST_GetSymbol`), but the condition is the same.

## Oracle result
`test_named_expression_valid_rebinding_iteration_variable` fails (18 subtests): e.g.
`(h := 1) for a, (*b, c[d+e::f(g)], h.i) in j` raises
`SyntaxError: assignment expression cannot rebind comprehension iteration variable 'h'`
instead of running and raising NameError.
