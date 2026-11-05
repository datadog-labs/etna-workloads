# Rationale

Changed: src/backend/statistics/extended_stats.c, `statext_is_compatible_clause()`.
Traces to the fix.patch hunk "@@ -1612,34 +1646,48 @@" in the same function (the per-column permissions check).

The fix converted `*attnums` to offset-style attnums, then merged in `pull_varattnos((Node *) *exprs, ...)`.
The reversal restores the old logic:
- Pre-fix: `if (*exprs != NIL) { pull_varattnos((Node *) exprs, ...); add_members(*attnums) } else clause_attnums = *attnums;`
- `exprs` is a `List **`, so the cast passes the wrong pointer to `pull_varattnos`. The Vars inside the expressions are not examined. Garbage may be read instead.
- Un-offset `*attnums` are mixed with offset-style attnums, so the wrong columns are permission-checked.

Failing oracle case: src/test/regress||stats_ext
