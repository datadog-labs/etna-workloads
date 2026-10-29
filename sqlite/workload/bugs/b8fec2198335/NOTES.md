Reproducer: a table with a virtual generated column (`comp`) before `b`, then an UPSERT
`DO UPDATE SET b=excluded.b`. The buggy build indexes the `excluded` register by column
number instead of storage position, so `b` gets the wrong value (NULL instead of 5).
Clean shell prints `k|0|0|5|`; buggy prints a different row for `b`.
