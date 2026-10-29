# Rationale

Fix hunks reversed (all in `src/pragma.c`, PRAGMA foreign_key_check):

- Removed the `int *aiCols` declaration and the `sqlite3DbFree(db, aiCols)` (fix hunks 1 and 4).
- The code-generation call to `sqlite3FkLocateIndex` now passes `0` instead of `&aiCols` (fix hunk 2), so the child-to-parent column mapping is not computed.
- The child key columns are read with `pFK->aCol[j].iFrom` only, ignoring the mapping (fix hunk 3). In 3.54.1 this was `aiCols ? aiCols[j] : pFK->aCol[j].iFrom`. The original pre-fix text had `aCol[j].iFrom` too, which is the same behaviour.

Effect: when the child's FK column order differs from the parent index's column order, the key record is built in the wrong order, so valid rows are reported as violations and some violations are missed.

Oracle cases failing: fkey5-8.2, 8.3, 8.6, 8.7 (the `REFERENCES p5(c,b)` / `p6(c,b)` cases).
