# Reproducer notes

`repro.sql` is lifted directly from `fts5corruptB.test` test case 2.0/2.1
(the hexdb corrupt database literal, loaded with `.open --hexdb`), followed
by:

    SELECT count(*) FROM t WHERE t MATCH 'a';

The hexdb encodes an fts5 leaf page whose page-index records an `iTermOff`
value that is larger than the leaf's `szLeaf`. `fts5SegIterNextInit()` reads
this varint and, without the bounds check that `fix.patch` adds, uses it
directly as `pIter->iLeafOffset`. That offset is later used as an index/size
into the leaf's buffer, running off the end of the allocation.

- `bin/sqlite3-clean` (bounds check present): the oversized offset is caught
  and the query reports `Error near line 573: database disk image is
  malformed`, exit status 1.
- `bin/sqlite3-buggy` (`injection.patch` applied, bounds check removed): the
  out-of-bounds offset is used unchecked, causing a heap over-read that
  crashes the process (SIGSEGV, exit status 139) instead of returning a
  clean error.

No `sqlite3_test_control_pending_byte` override or extra setup is needed —
this specific corrupt database/query pair already triggers the crash.
