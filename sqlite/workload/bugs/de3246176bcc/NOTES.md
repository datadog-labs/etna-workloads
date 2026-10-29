repro.sql: a table with INTEGER PRIMARY KEY holding 9223372036854775807, queried with `a>=(9223372036854775807+1)`.
The right side is the real 9.2233720368547758e18, which is greater than every i64, so no row matches.
Clean prints nothing. Buggy prints `1`, because OP_SeekGE compares the clipped integer key to the real as doubles, and they compare equal.
