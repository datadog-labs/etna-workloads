`repro.sql` stores '1.25' in a TEXT column and runs `SELECT * FROM t1 WHERE NOT x=sqlar_uncompress(1.25,4)`.
`sqlar_uncompress(1.25,4)` calls `sqlite3_value_bytes()` on the REAL argument, so it returns a value that is both TEXT and REAL.
This stands in for the test's `add_text_type()`, which only exists in the TCL harness.

In a text-affinity comparison the buggy build leaves the REAL flag on that value, so `x=` is not recognised as true.
- clean: prints nothing.
- buggy: prints the row `1.25`.
