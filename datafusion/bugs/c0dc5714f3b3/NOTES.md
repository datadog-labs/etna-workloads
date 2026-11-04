repro.sql: anchored regex (`~*`, `!~*`, with a literal and with an alternation) on a VARCHAR (Utf8View) column.
Buggy build rewrites these to `=` / `!=` / `IN` with a Utf8 literal, so each query fails with
`Invalid comparison operation: Utf8View == Utf8`. The clean build returns correct case-insensitive results.
(The injection also makes `~*` case-sensitive.)
