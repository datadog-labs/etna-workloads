Reproducer (repro.sql): TEXT column `a` (unique index) vs INTEGER column `b`;
query `WHERE a=b OR a='hello'` in a CROSS JOIN.
Clean shell returns the row `123|0123` (a=b needs affinity conversion, so the
OR-to-IN optimization must not be used). Buggy shell wrongly converts the OR
into an IN using the index without applying affinity, returning no rows.
