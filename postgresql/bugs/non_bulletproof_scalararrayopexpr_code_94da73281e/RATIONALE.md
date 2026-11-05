# Rationale

Both hunks trace to fix.patch and reintroduce the bug: a ScalarArrayOpExpr with the Const on the left (`Const op ANY (Var)`) is accepted as compatible with extended stats.

1. src/backend/statistics/extended_stats.c, statext_is_compatible_clause_internal (ScalarArrayOpExpr branch): traces to the extended_stats.c hunk. Removed the `expronleft` check, so the "Var on left" requirement is no longer enforced. (The `cst->constisnull` check from the original fix is not present in today's code, since mcv.c handles NULL arrays elsewhere.)
2. src/backend/statistics/mcv.c, mcv_get_match_bitmap (ScalarArrayOpExpr branch): traces to the mcv.c hunk. Replaced the `elog(ERROR)` on `!expronleft` with `Assert(expronleft)`. In non-assert builds this lets the scalar Const be treated as an array.

Failing oracle case: src/test/regress||stats_ext
