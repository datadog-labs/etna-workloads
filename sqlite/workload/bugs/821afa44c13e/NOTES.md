repro.sql checks RTRIM collation with a control character (char(20)) after the
trailing spaces, then repeats the collate1-8.2 table lookup.

Clean: `' ' > char(20) COLLATE rtrim` returns 0, and the WITHOUT ROWID lookup returns ` |1`.
Buggy: the first query returns 1, and the lookup returns no row. The buggy RTRIM
treats the control character as trailing padding.
