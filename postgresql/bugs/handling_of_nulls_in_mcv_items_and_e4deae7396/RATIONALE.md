# Rationale

File: src/backend/statistics/mcv.c, function mcv_get_match_bitmap(), OpExpr branch (Var op Const loop over MCV items).

Traces to the single fix_impl.patch hunk. The current code has the combined check
`if (item->isnull[idx] || cst->constisnull) { matches[i] = RESULT_MERGE(...false); continue; }`.
I reverted it to the pre-fix logic: only `if (!is_or && item->isnull[idx]) matches[i] = false;`, with no `continue`
and no Const-NULL check. For OR-lists, NULL MCV items and NULL constants now reach the (strict) operator call
with a NULL datum. That gives wrong match results (and is unsafe), which is the bug the fix removed.

Failing oracle case: src/test/regress||stats_ext
