Reproducer: repro.sql (translation of fts3corrupt-8.1..8.3).
Builds an fts3 table with nodesize=24 and two segments, overwrites segment block 2 with block 1 (via `.dbconfig defensive off`), then runs `merge=2,2`.
Clean: "Error near line 23: database disk image is malformed", exit 1.
Buggy: the missing `nSuffix<=0` corruption check in fts3IncrmergeAppend means the merge silently succeeds (no error, exit 0).
