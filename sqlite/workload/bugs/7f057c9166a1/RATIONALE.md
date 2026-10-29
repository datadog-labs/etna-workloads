# Rationale

Bug (ticket #1301): rows with a NULL in a unique index's columns must be
distinct. The fix made `sqlite3RefillIndex` (CREATE UNIQUE INDEX / REINDEX)
skip the uniqueness check for keys containing NULLs (via the
MakeRecord/MakeIdxRec jump-if-null P2 and OP_IsUnique). Before the fix, the
refill path treated NULLs as equal, so CREATE UNIQUE INDEX over data with
duplicate NULL-containing keys failed.

The fix's opcode hunks (OP_MakeIdxRec, OP_IdxInsert uniqueness check) have no
direct counterpart in 3.54.1. The equivalent today is `OP_SorterCompare`,
which `sqlite3RefillIndex` (src/build.c) uses to detect duplicates. Its
helper `sqlite3VdbeSorterCompare` (src/vdbesort.c) returns "not equal" when
any key column is NULL. That is the NULL-distinct logic from the fix's
build.c hunk (the jump-if-null before OP_IsUnique).

Change: remove the NULL-scan loop in `sqlite3VdbeSorterCompare` (and the
now-unused `int i`). Keys with NULLs are then compared like any other
value, which restores the pre-fix behaviour for the refill path. The
INSERT path (OP_NoConflict) is unchanged.

Failing oracle cases (unique.test):
- unique-4.8: `CREATE UNIQUE INDEX i4a ON t4(a,b)` gives
  `UNIQUE constraint failed: t4.a, t4.b` instead of `0 {}`.
- unique-4.9: `CREATE UNIQUE INDEX i4b ON t4(a,b,c)` gives
  `UNIQUE constraint failed: t4.a, t4.b, t4.c` instead of `0 {}`.
