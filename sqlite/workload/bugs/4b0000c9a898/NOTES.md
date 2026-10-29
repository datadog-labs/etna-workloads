repro.sql builds an FTS4 table with order=DESC holding docids -1 ('a b') and 1 ('b'), then runs the phrase query `"a* b"` (prefix term inside a phrase).

- clean: returns `-1`
- buggy: returns no rows. The phrase merge on a DESC doclist writes into the right-hand buffer in place, and the merged output can be larger than the input because of the mixed-sign rowid deltas. The fix allocates a separate, padded output buffer.

Both shells exit with status 0; only the result differs. This is the fts3prefix-7.1 case.
