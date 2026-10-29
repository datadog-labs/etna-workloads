Reproducer: repro.sql (fts4growth test 7.x, with synthetic data instead of the genesis text).

It builds an FTS4 table with 6 level-0 segments, runs a partial incremental merge ('merge=25,4'),
then simulates an old FTS version having done part of the work by rewriting the level-1
segdir end_block to a bare integer (no segment size). It then finishes the merge with
merge=2500,4 and merge=2500,2.

Clean: the final segment's end_block is just "1782" (no size stored, since it would be wrong).
Buggy: end_block is "1782 3881", i.e. an incorrect segment size is stored (bNoLeafData missing).
