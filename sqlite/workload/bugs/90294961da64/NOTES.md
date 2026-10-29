# Reproducer

`repro.sql` reproduces the fts3corrupt4.test case 6.1/6.2 bug:

1. `.dbconfig defensive off` — needed only because the shell enables the
   defensive setting by default (the test harness does not), which would
   otherwise block writing directly to the shadow table.
2. Create an fts3 table, then insert a segdir row by hand
   (`INSERT INTO Table0_segdir VALUES(1,NULL,1,NULL,NULL,NULL)`), simulating
   a corrupt database where a segment's root is NULL but its start_block is
   non-zero and non-leaf (`idx=1` is a non-leaf level, `start_block=1` is
   non-zero, `root` is NULL).
3. `SELECT ... WHERE Table0 MATCH 'a'` and `INSERT INTO Table0(Table0)
   VALUES('optimize')` both walk this segment and call
   `fts3SegReaderCursor()` with a non-zero `iStartBlock`, a non-NULL `zTerm`,
   and `zRoot == NULL`.

In `fts3.c`, the buggy code calls `fts3SelectLeaf(p, zTerm, nTerm, zRoot,
nRoot, ...)` whenever `iStartBlock && zTerm`, without checking `zRoot` is
non-NULL first. `fts3SelectLeaf` dereferences the root blob directly,
causing a NULL-pointer dereference / segfault. The fix adds a `&& zRoot`
guard so the leaf-narrowing optimization is skipped when there is no root
blob to search, falling back to reading the segment from its start block
(and succeeding, or failing with a controlled error, instead of crashing).

# Result

- `sqlite3-clean`: exits 0, succeeds quietly (schema accepted; MATCH/optimize
  find no match).
- `sqlite3-buggy`: crashes with SIGSEGV (exit status -11).
