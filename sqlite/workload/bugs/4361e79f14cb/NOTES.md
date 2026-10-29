# Reproducer notes

`repro.sh` reproduces the bug fixed by `fix.patch` (upstream, 2009-08-14),
covered by `test/corrupt.test` cases corrupt-6.1, corrupt-8.1, corrupt-8.2.

It builds a 1024-byte-page database with table `t1`, fills the root page
(page 2) with 63 small rows so the last cell sits right at the end of the
page, then deletes that row so the space it occupied becomes a freeblock.
It then directly corrupts that freeblock's size field (2 bytes at
`rootpage_offset+2`) to `0x00FF` (255), so the freeblock's last byte lies
255 bytes past where the freeblock's declared size allows it to be read —
i.e. the freeblock now claims to extend past the usable page size. This is
the same shape of corruption as corrupt-6.1/8.1/8.2 in `test/corrupt.test`.

Reopening the (corrupted) database and inserting a new row forces
`allocateSpace()` in btree.c to reuse that oversized freeblock.

- **sqlite3-clean** (fix applied): the page-parsing code detects that the
  freeblock's end lies past the usable page size and returns
  `SQLITE_CORRUPT_BKPT`. The `INSERT` fails with
  `database disk image is malformed` (exit status 1).

- **sqlite3-buggy** (`injection.patch` applied, fix reverted): the missing
  bounds checks let `allocateSpace()` proceed with the oversized
  freeblock, and the debug build's internal assertion
  (`pSpace+nByte<=data+pPage->pBt->usableSize`) fires, aborting the process
  (SIGABRT, exit status 134). In a non-debug build this would instead be a
  write past the end of the in-memory page buffer.
