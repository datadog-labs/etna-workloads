Reproducer for the `CASE WHEN <nullable cond> THEN col END` bug (the case_column_or_null path, with no ELSE).

`repro.sql` builds the `foo` table from case.slt and runs three CASE queries whose WHEN condition can evaluate to NULL.

The buggy build does not treat NULL conditions as false. It inverts the bitmask without first turning NULLs into false, so rows with a NULL condition keep `b` instead of becoming NULL.
- r2 (`NULLIF(NVL(a,0) >= 0, TRUE)`): the condition is NULL on every row. Clean returns all NULL. Buggy returns b.
- r3 (`NULLIF(a >= 0, FALSE)`): row `a=NULL, b=7` returns NULL on clean and 7 on buggy.
- r1 has no NULL conditions and is identical on both builds.
