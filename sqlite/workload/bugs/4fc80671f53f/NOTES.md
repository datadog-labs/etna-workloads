Reproducer: `repro.sql` (UTF-16le database, `group_concat(y,x)` as a window function with a
`ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING` frame, where one value is a BLOB).

The inverse function of group_concat() called sqlite3_value_bytes() without first calling
sqlite3_value_text(), so a BLOB under UTF-16 gave the wrong length to remove.

- clean: prints `1`, the blob as text, `1` (exit 0).
- buggy: assertion failure `groupConcatStep: Assertion '0' failed` (abort, exit -6).
