# Rationale
- File: src/bin/psql/crosstabview.c, function printCrosstab (duplicate-data error message).
- Traces to the fix.patch hunk that replaced `piv_rows[row_number].name` / `piv_columns[col_number].name` with `rp->name` / `cp->name`.
- row_number/col_number are ranks (sorted order), not array indexes, so indexing piv_rows/piv_columns by them names the wrong row/column in the error message. The fix uses the bsearch-found entries directly.

Failing oracle case: src/test/regress||psql_crosstab
