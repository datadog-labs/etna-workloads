# Rationale

Fix: OR-clauses with 17+ terms broke because the RowSet batch number was kept in a `u8`
and masked with `& 0xf` in OP_RowSetTest, so batch 16 aliased batch 0.

Changes (each reverses a fix hunk):
- `src/rowset.c` struct RowSet: `u16 rsFlags`/`int iBatch` -> `u8`/`u8` (rowset.c struct hunk).
- `src/rowset.c` `sqlite3RowSetTest(..., int iBatch, ...)` -> `u8 iBatch` (rowset.c function hunk).
- `src/sqliteInt.h` prototype `int iBatch` -> `u8 iBatch` (sqliteInt.h hunk).
- `src/vdbe.c` OP_RowSetTest: pass `(u8)(iSet>=0 ? iSet & 0xf : 0xff)` instead of `iSet` (vdbe.c hunk).
  (The pointer expression is `(RowSet*)pIn1->z` in 3.54.1 but otherwise the old code.)

Oracle: whereD-5.1 fails (the 18-term OR query returns the wrong rows, since the
batch-16 test collides with batch 0 and a rowid is wrongly treated as already seen).
