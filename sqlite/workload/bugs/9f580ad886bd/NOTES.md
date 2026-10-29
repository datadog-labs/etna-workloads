# Reproducer notes

`repro.sh` builds a small auto-vacuum database (`PRAGMA page_size=1024`)
with a `t1` table big enough that its b-tree root page is an interior page
(32 rows of a 200-byte blob each, as in test/corruptB.test's corruptB-1.1).
It then reads the table's root page number and overwrites the interior
page's right-child pointer (bytes 8..11 of the page) with the root page's
own number, i.e. corruptB-1.3.1's corruption: "Set the right-child of a
B-Tree rootpage to refer to the root-page itself." This makes the root page
its own descendant, a loop in the b-tree structure.

`SELECT count(*) FROM t1` then forces a full table scan that walks into the
self-referencing right child.

- `sqlite3-clean` (has the fix): detects that a page is being visited as its
  own descendant (`getAndInitPage`'s `(*ppPage)==pParent` check, and the
  `BTCURSOR_MAX_DEPTH` cutoff in `moveToChild`) and returns a clean
  `SQLITE_CORRUPT` error — "database disk image is malformed" — exit
  status 1.
- `sqlite3-buggy` (injection.patch reverted, i.e. has the historical bug):
  lacks those checks, so the cursor recurses into the self-referencing page
  indefinitely until it blows past `BTCURSOR_MAX_DEPTH` and hits
  `assert(pCur->iPage<BTCURSOR_MAX_DEPTH)` in `moveToChild`, aborting the
  process (SIGABRT, exit status 134) instead of reporting corruption.
