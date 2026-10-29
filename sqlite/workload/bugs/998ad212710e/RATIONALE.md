# Rationale

Fix hunk: `walIndexMap()` in src/wal.c. Before the fix the wal-index mapping was
only (re)acquired when nothing was mapped (`pWiData==0`), so a mapping that
had become too small (another process grew the wal-index) was never enlarged;
the fix added `|| reqSize>pWal->szWIndex`.

In 3.54.1 the wal-index is mapped page-by-page, and the equivalent logic is
`walIndexPage()` (which calls `walIndexPageRealloc()` to map missing pages).
I reverted it to the pre-fix policy "only map if nothing is mapped yet": the
mapper is invoked only when page 0 is absent (or on the page-0 retry path);
otherwise a request for a page beyond what is already held returns
`*ppPage==NULL` with SQLITE_OK instead of growing the mapping. (The manifest
and test hunks of the fix are not implementation.)

Oracle failures (test/wal.test): wal-20.2, wal-20.3, wal-20.4. A second process
grows the wal past 64KB; the checkpoint in the first connection does not
map the additional wal-index pages, and checkpointing/reading fails.
All other 578 cases pass.
