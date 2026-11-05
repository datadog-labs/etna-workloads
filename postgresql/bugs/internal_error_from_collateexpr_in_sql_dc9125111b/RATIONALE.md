# Rationale

Hunks (both trace to fix_impl.patch):

1. `src/backend/nodes/nodeFuncs.c`, `exprSetCollation()`, `case T_JsonBehavior`: restores the recursive
   `exprSetCollation(behavior->expr, collation)` in place of the Assert (fix hunk 1). With a
   `CollateExpr` inside a DEFAULT, exprSetCollation hits an unhandled node type and raises an internal error.
2. `src/backend/parser/parse_expr.c`, `transformJsonBehavior()`: removes the check that rejects a DEFAULT
   expression whose collation differs from `jsexpr->collation` (fix hunk adding the
   COLLATION_MISMATCH error and `targetcoll`/`exprcoll`). Without it, `DEFAULT 'A' COLLATE "C"` reaches
   `assign_collations_walker` -> `exprSetCollation` with the CollateExpr. The `jsexpr` parameter and
   `jsexpr->collation` assignments are left in place (harmless).

Failing oracle case: `src/test/regress||collate.icu.utf8`
