Reproducer (repro.sql): builds an fts5 table with one row and calls snippet() with an out-of-int-range nToken (-2147483648, -2147483649, 2147483648, 2147483649).

Clean shell clamps nToken to 0..64: negative values give `[x...`, large values give the full 11-token snippet.
Buggy shell truncates the 64-bit value to int: -2147483648 and -2147483649 return the full snippet instead of `[x...`, and 2147483649 returns `[x...` instead of the full snippet.
