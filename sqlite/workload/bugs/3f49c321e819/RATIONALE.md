# Rationale

Bug: for `RANGE BETWEEN <expr> PRECEDING AND <expr> PRECEDING` frames, the
generated code returned the row before running AGGINVERSE for the start
boundary, so the returned value included rows that had already left the frame.

Changes (all in `tree/src/window.c`, `sqlite3WindowCodeStep()`):

1. Main loop, `pMWin->eEnd==TK_PRECEDING` branch (second and later rows).
   The fix added `bRPS` and ran AGGINVERSE before RETURN_ROW when `bRPS` was
   true. I removed `bRPS` and restored the old order: AGGSTEP, RETURN_ROW,
   AGGINVERSE.
2. Flush block after the main loop, `pMWin->eEnd==TK_PRECEDING` branch.
   The fix added `bRPS` and an AGGINVERSE before RETURN_ROW. I removed both,
   so the flush path again does only AGGSTEP then RETURN_ROW.

I did not revert the comment-only hunks (the pseudo-code comment and the
"Beginning of the block" comment). They don't change behaviour.

Failing oracle cases (all in `test/window8.test`; 12 of 361): 6.2, 7.1.2,
7.1.4, 7.1.6, 7.2.2, 7.2.4, 7.3.2, 7.3.4, 7.3.6, 7.4.2, 7.4.4, 7.4.6. They
return wrong aggregates for RANGE PRECEDING..PRECEDING frames. For example,
7.4.6 expects `{} {} 1 4 4 4` and gets `{} {} 1 6 6 6`.
