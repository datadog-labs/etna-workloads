Creates a WITHOUT ROWID table with 100 rows, runs `DELETE FROM t1` (truncate optimization), and prints changes().
Clean shell prints 100; buggy shell prints 0, because OP_Clear for the primary-key index no longer gets a P3 to count rows.
