# Reproducer notes

`repro.sh` reproduces corruptJ-1.2 from `tree/test/corruptJ.test`.

It builds a database with `page_size=1024`, `auto_vacuum=0`, a table `t1(a,b)`
populated with 10 rows containing a 700-byte blob each, which makes the root
page of `t1` a multi-cell interior page with at least one real child page.
It then directly overwrites one byte in the root page (offset `2*1024-2`,
i.e. the last two bytes of page 2's cell-pointer area) with `0x02`, which
turns the left-child pointer of the root page's first cell into `2`, the
root page's own page number. This makes the root page appear to be a child
of itself. Finally it runs `DROP TABLE t1`, which calls `clearDatabasePage()`
to free all of the table's pages.

- **Clean shell**: `clearDatabasePage()` detects the corruption (the fix
  checks the page's in-memory reference count before recursing, and bails
  out) and `DROP TABLE t1` fails with `database disk image is malformed`.
  Exit status 0 for the shell process (the error is reported, not fatal).
- **Buggy shell** (`injection.patch` removes that reference-count check):
  `clearDatabasePage()` recurses into the root page again as if it were a
  child, re-walking the same cells and freeing them a second time, which
  corrupts internal data structures and crashes the process with a
  segmentation fault (exit status 139).
