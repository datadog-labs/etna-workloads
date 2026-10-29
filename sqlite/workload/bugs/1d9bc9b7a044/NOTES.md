Creates a table with index on (c,d,e) and runs EXPLAIN QUERY PLAN on row-value range constraints.
Clean prints `(c=? AND (d,e)>(?,?))` and `(c=? AND (d,e)>(?,?) AND (d,e)<(?,?))`; the buggy shell prints only the single-column forms (e.g. `c=? AND d>?`).
