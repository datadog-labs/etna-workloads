repro.sql: t1 holds the real -9223372036854775808.0 and t2 has an INTEGER PRIMARY KEY row of -9223372036854775808. Fake sqlite_stat1 rows make t2 the inner loop, so the join `b = a` is done by rowid lookup, and OP_MustBeInt converts the real to an integer.

Clean: the last two queries both return 1. Buggy: the second query (`AND b <> 5`) returns 0, because the buggy OP_MustBeInt can't convert -9223372036854775808.0 to an integer, so the row is missed.
