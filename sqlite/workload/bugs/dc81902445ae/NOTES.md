repro.sql: virtual column `a INT AS (x)` is indexed; `b BLOB AS (x)` has the same expression but a different affinity.
`SELECT typeof(b) FROM t1 INDEXED BY x2` should give the same types as a full scan (the '1' row is `text`).
Buggy shell reuses the index value for `b`, which was coerced by INT affinity, so the '1' row reports `integer` instead of `text`. The clean shell reports `text`.
