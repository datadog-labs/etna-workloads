repro.sql runs join2-9.4/9.5: a view column `CAST(t0.c0 AS INTEGER)` on the right side of a LEFT JOIN, compared with `'0'` in the ON clause.
Clean shell prints `0|0` for both queries. Buggy shell loses the column's affinity (the IF_NULL_ROW wrapper is not skipped), so the comparison is wrong and it prints `0|` (NULL right side).
