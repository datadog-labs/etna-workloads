Reproducer for the searched-CASE boolean optimization bug (fix: #14349).

repro.sql builds a table with nullable boolean columns and runs searched CASE
expressions with boolean THEN values and at most two WHEN branches.

Differences with the bug present (df-buggy vs df-clean):
- `CASE WHEN x THEN true WHEN y THEN true ELSE false END` with x=y=NULL returns NULL instead of false.
- `CASE WHEN x THEN true WHEN y THEN false END` returns false instead of NULL when no branch matches and no ELSE is given.
- The same wrong false appears for `CASE WHEN x IS NULL ... WHEN y IS NULL ...` with no ELSE.
