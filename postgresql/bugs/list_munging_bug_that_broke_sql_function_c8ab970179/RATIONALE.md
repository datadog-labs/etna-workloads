# Rationale

Today's code differs from the original: SQL functions are executed per-statement, and the
validator (`fmgr_sql_validator`) passes a list of sublists of Query nodes to
`check_sql_fn_statements` / `check_sql_fn_retval`, which expect that shape.
The original bug was a list-shape mismatch (lappend vs list_concat) between the validator and those checkers.

## Hunk: src/backend/catalog/pg_proc.c, fmgr_sql_validator (two places)
Traces to the fix.patch pg_proc.c hunk (list_concat vs lappend of querytree_sublist).
Both loops that build `querytree_list` (stored-body and text-body paths) now use `list_concat`
instead of `lappend`. This flattens the list into bare Query nodes while
`check_sql_fn_statements`/`check_sql_fn_retval` expect a list of Query sublists
(`lfirst_node(List, ...)`, `llast_node(List, ...)`). That breaks the validation and result coercion
check at CREATE FUNCTION time.

## Failing oracle cases
- src/test/regress||rangefuncs
