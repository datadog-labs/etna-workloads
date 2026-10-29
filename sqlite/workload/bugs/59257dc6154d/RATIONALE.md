# Rationale

## Changed hunk: `sqlite3BtreeBeginTrans()` in `tree/src/btree.c`

The fix (the only implementation hunk) added a block to `sqlite3BtreeBeginTrans()`.
When a write transaction begins and `pBt->nPage` differs from the db-size
field at header offset 28 (as happens after a pre-3.7.0 client appended to or
truncated the file), the block journals page 1 and rewrites the field.

I removed that block, and the local `MemPage *pPage1` it used. I restored the
`#ifndef SQLITE_OMIT_SHARED_CACHE` / `if( wrflag )` nesting to its pre-fix shape.
The shared-cache code is unchanged in behaviour. It still sets `pBt->pWriter`
and the `BTS_EXCLUSIVE` flag, which replaced the old `isExclusive` field.
The code is otherwise identical to the pre-fix state. The header size field
is not corrected at transaction start, so a savepoint or transaction rollback
that re-reads the size from page 1 gets a stale value.

## Oracle cases that fail

- `filefmt-2.1.5`, `filefmt-2.1.6`, `filefmt-2.2.5` and `filefmt-2.2.6` fail
  (integrity check and the header size check, which reads `00000010`).
- About 87 `pagerfault-22-*` cases fail (ioerr, oom, cantopen and shmerr
  variants). They expect the header update to be exercised under injected faults.
