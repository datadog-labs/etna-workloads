repro.sql: a NOCASE column with a NOCASE index, `PRAGMA case_sensitive_like=on`, then `x LIKE 'abc%'`.
Clean returns only `abc`, `abcd`. Buggy returns `ABC` and `ABCD` too.
The injection drops the COLLATE on the LIKE-derived range terms (x>='abc' AND x<'abd'). They then use the column's NOCASE collation, so the index range scan is case-insensitive even though LIKE is case-sensitive.
Corresponds to like-5.5.
