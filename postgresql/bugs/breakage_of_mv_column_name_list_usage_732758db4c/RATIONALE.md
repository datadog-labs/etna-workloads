# Rationale

## src/backend/rewrite/rewriteDefine.c, DefineQueryRewrite()
Traces to the fix_impl.patch hunk that passes
`event_relation->rd_rel->relkind != RELKIND_MATVIEW` as the new
`requireColumnNameMatch` argument of checkRuleResultList() for the ON SELECT rule.
The fix skips the column-name check for materialized views, so a column name list
(CREATE MATERIALIZED VIEW mv(a,b) AS ...) can differ from the query's names.
I changed that argument back to unconditional `true`, which matches the pre-fix
behavior (`isSelect && strcmp(...)`, always true for SELECT rules). Creating a
matview with a column name list now fails with "SELECT rule's target entry N has
different column name".

The other hunks (signature, Assert, RETURNING caller) are pure plumbing and
need no change.

## Failing oracle cases
- src/test/regress||matview
