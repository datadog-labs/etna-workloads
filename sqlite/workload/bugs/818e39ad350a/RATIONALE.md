# Rationale

Fix (ticket #3774): `OP_Count` in vdbe.c gained a guard so that count(*) on
sqlite_master of an empty database (no root page, so no usable cursor)
returns 0 instead of calling sqlite3BtreeCount on it.

In 3.54.1 the cursor is never NULL (OP_Count asserts `pCrsr`); the same
empty-database case is instead handled in `sqlite3BtreeCount` (src/btree.c):
`moveToRoot()` returns SQLITE_EMPTY and the function sets `*pnEntry = 0` and
returns SQLITE_OK. I removed that `if( rc==SQLITE_EMPTY ){...}` block. This is
the modern equivalent of the removed `else{ nEntry = 0; }` branch: the empty
case is no longer special-cased, so SQLITE_EMPTY propagates to OP_Count and
aborts the statement.

Oracle failures (test/count.test): count-0.1 (the ticket's test,
`SELECT count(*) FROM sqlite_master` on an empty db), plus count-1.1.1 and
count-1.2.1 (count on empty tables/indexes).
