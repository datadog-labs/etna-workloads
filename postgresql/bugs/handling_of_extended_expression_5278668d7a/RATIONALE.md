# Rationale

## src/backend/parser/parse_utilcmd.c, generateClonedExtStatsStmt()
Traces to the fix.patch hunk in generateClonedExtStatsStmt that added `map_variable_attnos(expr, 1, 0, attmap, ...)`
for statistics expressions ("Adjust Vars to match new table's column numbering"). I removed that remapping, so cloned
expression statistics keep the parent's attribute numbers. When the LIKE-created table has different column numbering
(e.g. dropped columns in the parent), the expression Vars point at the wrong or nonexistent columns, which is the original bug.

## Failing oracle cases
- src/test/regress||create_table_like
