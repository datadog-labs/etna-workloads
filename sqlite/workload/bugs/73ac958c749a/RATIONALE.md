# Rationale

The fix's two hunks in src/wherecode.c still applied cleanly in reverse on 3.54.1, so both were reverted:

- `filterPullDown()`: removed the `OP_MustBeInt regRowid, addrNxt` emitted before the `OP_Filter` on an (ipk = ?) term. Reverses fix hunk 1.
- `sqlite3WhereCodeOneLoopStart()`, WHERE_IPK|WHERE_COLUMN_EQ branch: removed the `OP_MustBeInt iRowidReg, addrNxt` before `OP_Filter`. Reverses fix hunk 2.

Without the coercion, the bloom filter is probed with an unconverted TEXT value such as '123', whose hash differs from that of the integer rowid. Matching rows are wrongly filtered out.

## Oracle
`./check.sh`: bloom1-1.5 fails (the 3-table join where t2.c=t1.b and t3.e=t1.b with t1.b TEXT returns no rows instead of `result`). The other cases pass.
