# Rationale

Fix: gh-104357 — in `inline_comprehension`, a cell var of an inlined
comprehension whose name is already bound in the enclosing function must be
promoted to a cell there, otherwise the outer scope's cellvars are wrong.

In v3.15.2 this is done by recording the name in `inlined_cells` (later
turned into CELL by `analyze_cells`) for every comp CELL / DEF_COMP_CELL
symbol. This is the equivalent of the fix's added
`if (scope == CELL && ste->ste_type == FunctionBlock) SET_SCOPE(...)` branch
for the `existing` case.

Change (Python/symtable.c, `inline_comprehension`): the `inlined_cells` add is
now done only when the name does not already exist in the enclosing scope
(`!existing`), i.e. the pre-fix behaviour where the already-bound case never
promotes the outer binding to a cell. The lookup of `existing` was moved
above it; nothing else changed.

Oracle: nearly all of test_listcomps fails/aborts (assert/crash in the
compiler, because the outer scope's cellvars are inconsistent with the inlined
comprehension's cell), including `test_inner_cell_shadows_outer_no_store`
and `test_inner_cell_shadows_outer`.
