# Rationale

Fix (2009-03-18): `sqlite3CreateIndex()` cleanup called `freeIndex()`, which released
the index's lookaside-allocated `zColAff` with `sqlite3_free()` (a lookaside pointer
passed to the non-lookaside free) -> crash with shared cache + lookaside.
The fix switched to `sqlite3_free(zColAff); sqlite3DbFree(db, pIndex)`.

In 3.54.1 the cleanup is `sqlite3FreeIndex()`, and the equivalent fix lives in two places:
`computeIndexAffStr()` allocates `zColAff` with `sqlite3DbMallocRaw(0, ...)` (never lookaside),
and `sqlite3FreeIndex()` frees it with `sqlite3DbFree(db, ...)`. Reversing the mismatch needs both:

1. `src/insert.c` `computeIndexAffStr`: allocate `zColAff` with `db` (lookaside-eligible) instead of `0`.
2. `src/build.c` `sqlite3FreeIndex`: free `zColAff` with `sqlite3_free()` instead of
   `sqlite3DbFree(db, ...)`. This is the pre-fix freeIndex behaviour (non-lookaside free
   of a lookaside pointer), reached from the `exit_create_index` cleanup.

Oracle: `./check.sh` shows 9 of 12 shared2.test cases failing (shared2-3.2 ... 6.2.2, incl. 5.1);
the run aborts with `Assertion sqlite3LookasideUsed(db,0)==0 failed` in
`sqlite3LeaveMutexAndCloseZombie`, i.e. lookaside memory mishandled on free.
