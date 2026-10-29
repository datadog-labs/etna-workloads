# Rationale

Fix (ticket bba7b69f9849b5bf) had three hunks; all still existed in 3.54.1 and are reverted:

1. `src/build.c` `sqlite3RefillIndex()`: the `if( !pIndex->bAscKeyBug )` guard around `OP_SeekEnd` is removed, so REINDEX always uses the seek-end optimization (the pre-fix code).
2. `src/build.c` `convertToWithoutRowidTable()`: removed the code that sets `bAscKeyBug` when a PK column is DESC.
3. `src/sqliteInt.h`: removed the `bAscKeyBug` bitfield from `struct Index`.

Equivalent to the pre-fix code: REINDEX on a WITHOUT ROWID table with a DESC primary key and a UNIQUE index appends rows to the index with OP_SeekEnd even though the index's PK suffix is in a different order.

Oracle failure: `without_rowid1-12.1` (REINDEX then integrity_check) returns "row N missing from index sqlite_autoindex_t0_2" instead of `ok`.
