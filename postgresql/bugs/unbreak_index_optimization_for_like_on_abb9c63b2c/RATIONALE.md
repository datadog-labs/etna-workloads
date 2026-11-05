# Rationale

Hunk: src/backend/utils/adt/like_support.c, `match_pattern_prefix()`.
Traces to the fix_impl.patch hunk that changed
`if (!get_collation_isdeterministic(expr_coll))` to
`if (expr_coll && !get_collation_isdeterministic(expr_coll))`.

The current code no longer has that early check (nondeterminism is tested later
through the `NONDETERMINISTIC()` macro, which already guards with OidIsValid).
To bring the bug back I added, before the fixed-prefix extraction, an unguarded
`if (!get_collation_isdeterministic(expr_coll)) return NIL;`.
For bytea, expr_coll is InvalidOid, so this raises
"cache lookup failed for collation 0" for `bytea_col LIKE '%1%'` on an indexed
column, i.e. the original failure.

Failing oracle case: src/test/regress||strings
