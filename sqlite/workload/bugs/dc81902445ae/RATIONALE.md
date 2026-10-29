# Rationale

Fix hunk reversed: `src/expr.c` `sqlite3IndexedExprLookup()` — the affinity-mismatch
check (and the `exprAff` local) the fix added. In 3.54.1 the check is still present
(shifted to ~line 4885); I removed it. Without it, an expression index on a generated
column is used to replace any matching expression, even when the index column's
affinity (e.g. INT) differs from the expression's affinity (e.g. BLOB column `b AS (x)`).
So `SELECT b FROM t1 INDEXED BY x2` reads the affinity-converted value from the index.

The other hunks (build.c `affExpr`, `IndexedExpr.aff`, where.c recording `aff`) were
left in place: they only supply data, and without the check in expr.c the data is unused,
so the pre-fix behaviour is restored.

## Failing oracle cases
gencol1-23.1.* (19 cases: typeof(b) via the index differs from the table) and
gencol1-23.4 (covering-index used for column b when it must read the table).
